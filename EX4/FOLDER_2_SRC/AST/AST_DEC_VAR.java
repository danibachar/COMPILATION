package AST;

import IR.*;
import TEMP.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

public class AST_DEC_VAR extends AST_DEC
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String type;
	public Integer typeLineNumber;
	public AST_EXP initialValue;
	public Integer initialValueLineNumber;

	/************************************************/
	/* PRIMITIVE AD-HOC COUNTER FOR LOCAL VARIABLES */
	/************************************************/
	public static int localVariablesCounter = 0;
	public boolean isGlobal;
  public boolean isInClass;
  public int varIndex;


	public boolean isVarDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_VAR(
		String type,
		Integer typeLineNumber,
		String name,
		Integer nameLineNumber,
		AST_EXP initialValue,
		Integer initialValueLineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.name = name;
		this.nameLineNumber = nameLineNumber;

		this.type = type;
		this.typeLineNumber = typeLineNumber;
		this.initialValue = initialValue;
		this.initialValueLineNumber = initialValueLineNumber;
		this.isInClass = false;
		this.isGlobal = false;
	}

	/********************************************************/
	/* The printing message for a declaration list AST node */
	/********************************************************/
	public void PrintMe()
	{
		/********************************/
		/* AST NODE TYPE = AST DEC LIST */
		/********************************/
		// if (initialValue != null) System.out.format("VAR-DEC(%s):%s := initialValue\n",name,type);
		// if (initialValue == null) System.out.format("VAR-DEC(%s):%s                \n",name,type);
		/**************************************/
		/* RECURSIVELY PRINT initialValue ... */
		/**************************************/
		if (initialValue != null)
		{
			initialValue.PrintMe();
		}

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("VAR\nDEC(%s)\n:%s",name,type));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (initialValue != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,initialValue.SerialNumber);

	}

	public TYPE SemantMe() throws Exception
	{
		TYPE t;
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;

		// if (initialValue != null) System.out.format("SEMANTME - VAR-DEC(%s):%s := initialValue\n",name,type);
		// if (initialValue == null) System.out.format("SEMANTME - VAR-DEC(%s):%s                \n",name,type);
		/****************************/
		/* [1] Check If Type exists */
		/****************************/
		// System.out.format("DEC_VAR: Looking to find type %s for name %s\n", type, name);
		t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null)
		{
			// if type is class we check if there was a previous TYPE_CLASS_VAR_DEC
			// System.out.format(">> ERROR [%d] non existing type %s\n",this.lineNumber,type);
			throw new AST_EXCEPTION(typeLineNumber);
		}

		/**************************************/
		/* [2] Check That Name does NOT exist */
		/**************************************/
		TYPE temp = SYMBOL_TABLE.getInstance().findInCurrentScope(name);
		if (temp != null)
		{
			System.out.format(">> ERROR [%d] variable `%s` already exists in scope, found `%s`\n",this.lineNumber,name, temp.name);
			throw new AST_EXCEPTION(nameLineNumber);
		}

		// validate that the initialValue is the same type as the var type, and that it exists!
		if (initialValue != null) {
			AST_HELPERS.isValidTypeAssignableFromExpression(t, initialValue);
		}
		/***************************************************/
		/* [3] Enter the Function Type to the Symbol Table */
		/***************************************************/
		SYMBOL_TABLE.getInstance().enter(name,t);

		/*********************************************************/
		/* [4] Return value is irrelevant for class declarations */
		/*********************************************************/
		// this.isInClass = SYMBOL_TABLE.getInstance().current_class != null;

		//myScope > 0 && !isInClass;
		boolean isInFunc =  myScope > 0 && !isInClass;

		this.isGlobal = !isInClass && !isInFunc;

		this.myType = t;
		// System.out.format("######### isGlobal = %s, isInClass = %s, isInFunc = %s \n", this.isGlobal, isInClass, isInFunc);
		if (!isGlobal && !isInClass)
    {
        varIndex = var_c.getInstance().declareLocal(name, myType);
    }


		return t;
	}

	public TEMP IRme() throws Exception
	{

		// if (initialValue != null) System.out.format("IRme - VAR-DEC(%s):%s := initialValue, Scope=%d\n",name,type,myScope);
		// if (initialValue == null) System.out.format("IRme - VAR-DEC(%s):%s                , Scope=%d\n",name,type,myScope);
		if (isGlobal || !isInClass)
		{
      TEMP src = null;
      if (initialValue != null && !isGlobal) {
          src = initialValue.IRme();
          if (src.isaddr) {
              //ir return address and not value
              TEMP expTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
              expTemp.setType(src.getType());
              expTemp.checkInit = src.checkInit;
              IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(expTemp, src));
              src = expTemp;
          }
      }

      if (isGlobal)
      {
					// System.out.format("@@@@@@@@ isGlobal = %s\n", name);
          IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Global(name, myType));
          if (initialValue != null)
          {
              LLVM.addGlobal(name, initialValue);
          }
      } else if (!isInClass){
          if (src != null) {
	          if (src.getType() instanceof TYPE_NIL) {
								TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
								pointerTemp.setType(src.getType());
								IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_local(pointerTemp,varIndex,myType));
								IR.getInstance().
									Add_IRcommand(new IRcommand_Store_Temp(pointerTemp,src));
	          } else {
							IR.getInstance().Add_IRcommand(new IRcommand_Store_Local(varIndex,src));

	          }
      	}
      }
    }

		return null;

	}

}
