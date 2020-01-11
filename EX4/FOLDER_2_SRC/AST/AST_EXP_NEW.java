package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import LocalVarCounter.*;
import LLVM.*;
import java.util.ArrayList;
import javafx.util.Pair;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

public class AST_EXP_NEW extends AST_EXP
{
	public String type;
  public AST_EXP exp;

	public boolean isNewArray() { return exp != null;}

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_NEW(String type,AST_EXP exp, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// System.out.format("====================== newExp -> ID( %s )\n", type);

		this.lineNumber = lineNumber;
		this.type = type;
    this.exp = exp;
	}

	/************************************************/
	/* The printing message for an INT EXP AST node */
	/************************************************/
  public void PrintMe()
  {
		// System.out.format("AST_EXP_NEW type - %s\n" ,type);
    /**************************************/
    /* RECURSIVELY PRINT initialValue ... */
    /**************************************/
    if (exp != null) exp.PrintMe();

    /**********************************/
    /* PRINT to AST GRAPHVIZ DOT file */
    /**********************************/
    AST_GRAPHVIZ.getInstance().logNode(
      SerialNumber,
      String.format("NEW(%s)\n",type));

    /****************************************/
    /* PRINT Edges to AST GRAPHVIZ DOT file */
    /****************************************/
    if (exp != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,exp.SerialNumber);

  }

	public TYPE SemantMe() throws Exception
	{
		TYPE t;
		// System.out.format("SEMANTME - AST_EXP_NEW type - %s\n" ,type);
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		/************************************************/
		/* Check That Type Was previously declared*/
		/************************************************/
		t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null)
		{
			System.out.format(">> ERROR [%d] Class type(%s) was not declared\n",this.lineNumber,type);
			throw new AST_EXCEPTION(this.lineNumber);
		}
		/************************************************/
		/*          Cannot assign void                  */
		/************************************************/
		if (t == TYPE_VOID.getInstance())
		{
			System.out.format(">> ERROR [%d] Cannot ask to create new void, daaa!\n",this.lineNumber,type);
			throw new AST_EXCEPTION(this.lineNumber);
		}
		/***********************************************************/
		/* Check That the Type is actually a class type or an array*/
		/***********************************************************/

		// Validating array
		if (exp != null) {
			TYPE expType = exp.SemantMe();
			if ( expType != TYPE_INT.getInstance()) {
				System.out.format(">> ERROR [%d] trying to init array[%s] with not declared type = %s\n",this.lineNumber,t, expType);
				throw new AST_EXCEPTION(this.lineNumber);
			}
			// We can send name null, as we don't really care about it (:
			// System.out.format("We can send name null, as we don't really care about it (:\n");
			// return new TYPE_ARRAY(null,TYPE_INT.getInstance());
		}
		// Validate Expression
		this.myType = t;
		return t;
	}

	public TEMP IRme() throws Exception
	{
		TEMP newObj = TEMP_FACTORY.getInstance().getFreshTEMP();

		//array
		String name = this.type;
		if (exp != null)
		{
			// System.out.format("Creating array %s\n", name);
			newObj.setType(new TYPE_ARRAY(name,myType));
			TEMP size = exp.IRme();
			TEMP actualSize = TEMP_FACTORY.getInstance().getFreshTEMP();
			IR.getInstance().Add_IRcommand(new IRcommand_Add_Int(actualSize, size, 1));
			// if (exp.isVar)
			// {
			// 	IR.getInstance().Add_IRcommand(new IRcommand_lw(size, size, 0));
			// }
			TEMP four = TEMP_FACTORY.getInstance().getFreshTEMP();
			four.setType(TYPE_INT.getInstance());
			// System.out.format("IRcommandConstInt (AST_EXP_NEW - array) %%Temp_%d = %d\n",four.getSerialNumber(),8);
			IR.getInstance().Add_IRcommand(new IRcommandConstInt(four, 8));
			TEMP sizeInBytes = TEMP_FACTORY.getInstance().getFreshTEMP();
			sizeInBytes.setType(TYPE_INT.getInstance());
			IR.getInstance().Add_IRcommand(new IRcommand_Binop_Mul_Integers(sizeInBytes, actualSize, four));

			TEMP allocated = TEMP_FACTORY.getInstance().getFreshTEMP();
			allocated.setType(newObj.getType());
			IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Array(allocated, sizeInBytes, myType));

			IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_Malloc(newObj, allocated));

			TEMP firstElement = TEMP_FACTORY.getInstance().getFreshTEMP();
			firstElement.setType(TYPE_INT.getInstance());
			IR.getInstance().Add_IRcommand(new IRcommand_Get_Element_Int(firstElement, allocated, TYPE_INT.getInstance(), 0));
			IR.getInstance().Add_IRcommand(new IRcommand_Store_Temp(firstElement, size));



			return newObj;
		}
		// class
		else {
			newObj.setType(myType);
			TYPE_CLASS classType = ((TYPE_CLASS)myType);
			int numberofMembers = classType.membersCount;
			// System.out.format("IRing class %s of type %d with %d members\n", myType.name, myType.typeOfType, numberofMembers);

			TEMP sizeInBytes = TEMP_FACTORY.getInstance().getFreshTEMP();
			sizeInBytes.setType(TYPE_INT.getInstance());
			// System.out.format("IRcommandConstInt (AST_EXP_NEW - class 1) %%Temp_%d = %d\n",sizeInBytes.getSerialNumber(),numberofMembers);
			IR.getInstance().Add_IRcommand(new IRcommandConstInt(sizeInBytes, numberofMembers));

			TEMP allocated = TEMP_FACTORY.getInstance().getFreshTEMP();
			allocated.setType(myType);
			IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Array(allocated, sizeInBytes, myType));

			IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_Malloc(newObj, allocated));

			TYPE_CLASS fatherClass = classType;
			while (fatherClass != null)
			{
				TYPE_CLASS_VAR_DEC_LIST currPos = fatherClass.data_members;
				fatherClass = fatherClass.father;
				while (currPos != null)
				{
					TYPE_CLASS_VAR_DEC cur = currPos.head;
					// System.out.format("New class with var %s %s %s\n", cur.name, cur.exp, cur.t);
					currPos = currPos.tail;
					if (cur.t  instanceof TYPE_FUNCTION )
					{
						continue;
					}
					if (cur.exp == null)
					{
						continue;
					}
					int varIndex = cur.index;

					TEMP newOffset = TEMP_FACTORY.getInstance().getFreshTEMP();
					newOffset.setType(TYPE_INT.getInstance());
					// System.out.format("IRcommandConstInt (AST_EXP_NEW - class 2) %%Temp_%d = %d\n",newOffset.getSerialNumber(),varIndex);
					IR.getInstance().Add_IRcommand(new IRcommandConstInt(newOffset,varIndex));

					TEMP elementAddress = TEMP_FACTORY.getInstance().getFreshTEMP();
					elementAddress.setType(classType);
					//Todo: check boundaries
				//	TEMP elementInt = TEMP_FACTORY.getInstance().getFreshTEMP();
					//elementInt.setType(TYPE_INT.getInstance());
					IR.getInstance().Add_IRcommand(new IRcommand_Get_Element_Temp(elementAddress, newObj, TYPE_INT.getInstance(), newOffset));
						TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
						pointerTemp.setType(cur.t);
						// System.out.format("Creating pointer Temp of index %d and type %s\n", pointerTemp.getSerialNumber(),pointerTemp.getType());
						IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_Pointer(pointerTemp, elementAddress));
						elementAddress = pointerTemp;
					elementAddress.isaddr = true;

					TEMP src = cur.exp.IRme();
					elementAddress.checkInit = true;
					IR.getInstance().
						Add_IRcommand(new IRcommand_Store_Temp(elementAddress,src));

				}
			}

			return newObj;

		}
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_NEW type - %s\nScope=%d\n" ,type,myScope);
		if (exp != null) exp.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_NEW type - %s\nScope=%d\n" ,type,myScope);
		if (exp != null) exp.InitGlobals();
	}
}
