package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import LocalVarCounter.*;
import LLVM.*;
import javafx.util.Pair;
import java.util.*;

public class AST_EXP_VAR_FIELD extends AST_EXP_VAR
{
	public AST_EXP_VAR var;
	public String fieldName;
	TYPE_CLASS semantedClass;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_VAR_FIELD(AST_EXP_VAR var,String fieldName, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		// System.out.format("====================== var -> var DOT ID( %s )\n",fieldName);
		this.lineNumber = lineNumber;
		this.var = var;
		this.fieldName = fieldName;
	}

	/*************************************************/
	/* The printing message for a field var AST node */
	/*************************************************/
	public void PrintMe()
	{
		/*********************************/
		/* AST NODE TYPE = AST FIELD VAR */
		/*********************************/
		// System.out.format("AST_EXP_VAR_FIELD\n(___.%s)\n",fieldName);
		/**********************************************/
		/* RECURSIVELY PRINT VAR, then FIELD NAME ... */
		/**********************************************/
		if (var != null) var.PrintMe();

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("FIELD\nVAR\n___.%s",fieldName));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (var  != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
	}
	public TYPE SemantMe() throws Exception
	{
		TYPE t = null;
		TYPE_CLASS tc = null;
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.format("SEMANTME - AST_EXP_VAR_FIELD\n(___.%s)\n",fieldName);
		/******************************/
		/* [1] Recursively semant var */
		/******************************/
		if (var != null) t = var.SemantMe();

		/*********************************/
		/* [2] Make sure type is a class */
		/*********************************/
		if (!t.isClass()) {
			// check for var - look for better folution
			if (t.isClassVar()) {
				TYPE_CLASS_VAR_DEC tmp = (TYPE_CLASS_VAR_DEC)t;
				if (!tmp.t.isClass()) {
					System.out.format(">> ERROR [%d] access %s field of a non-class variable type(%s)\n",this.lineNumber,fieldName,t);
					throw new AST_EXCEPTION(this.lineNumber);
				} else {
						tc = (TYPE_CLASS)tmp.t;
				}

			} else {
				System.out.format(">> ERROR [%d] access %s field of a non-class variable type(%s)\n",this.lineNumber,fieldName,t);
				throw new AST_EXCEPTION(this.lineNumber);
			}
		} else {
			tc = (TYPE_CLASS) t;
			this.semantedClass = tc;
		}

		/************************************/
		/* [3] Look for fiedlName inside tc */
		/************************************/
		if (tc != null) {
			TYPE_CLASS_VAR_DEC data_member_type = tc.queryDataMembersReqursivly(fieldName);
			if (data_member_type != null) {
					return data_member_type.t;
			}
		}


		/*********************************************/
		/* [4] fieldName does not exist in class var */
		/*********************************************/
		System.out.format(">> ERROR [%d] field %s does not exist in class\n",this.lineNumber,fieldName);
		throw new AST_EXCEPTION(this.lineNumber);
	}

	public TEMP IRme() throws Exception
	{
		TEMP obj = var.IRme();
		if (obj.isaddr) {
			TEMP obj1 = TEMP_FACTORY.getInstance().getFreshTEMP();
			obj1.setType(obj.getType());
			obj1.checkInit = obj.checkInit;
			IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(obj1, obj));
			obj = obj1;
		}
		IR.getInstance().Add_IRcommand(new IRcommand_Check_Null(obj, true));

		TYPE_CLASS_VAR_DEC varDec = semantedClass.queryDataMembersReqursivly(fieldName);
		int varIndex = varDec.index;

		TEMP newOffset = TEMP_FACTORY.getInstance().getFreshTEMP();
		newOffset.setType(TYPE_INT.getInstance());
		// System.out.format("IRcommandConstInt (AST_EXP_VAR_FIELD) %%Temp_%d = %d\n",newOffset.getSerialNumber(),varIndex);
		IR.getInstance().Add_IRcommand(new IRcommandConstInt(newOffset,varIndex));

		TEMP elementAddress = TEMP_FACTORY.getInstance().getFreshTEMP();
		elementAddress.setType(semantedClass);
		//Todo: check boundaries
	//	TEMP elementInt = TEMP_FACTORY.getInstance().getFreshTEMP();
		//elementInt.setType(TYPE_INT.getInstance());

		IR.getInstance().Add_IRcommand(new IRcommand_Get_Element_Temp(elementAddress, obj, TYPE_INT.getInstance(), newOffset));
			TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
			pointerTemp.setType(varDec.t);
			IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_Pointer(pointerTemp, elementAddress));
			elementAddress = pointerTemp;
		elementAddress.isaddr = true;
		elementAddress.checkInit = true;


		return elementAddress;
	}

	public void Globalize() throws Exception {
		System.out.format("IRme Globalize\n(___.%s)\nScope=%d\n",fieldName,myScope);
		if (var != null) var.Globalize();
	}
	public void InitGlobals() throws Exception {
		System.out.format("IRme InitGlobals\n(___.%s)\nScope=%d\n",fieldName,myScope);
		if (var != null) var.InitGlobals();
	}
}
