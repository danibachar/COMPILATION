/***********/
/* PACKAGE */
/***********/
package AST;

/*******************/
/* PROJECT IMPORTS */
/*******************/
import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_TYPE_NAME extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String type;
	public String name;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_TYPE_NAME(String type,String name,Integer lineNumber)
	{
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.type = type;
		this.name = name;
	}

	/*************************************************/
	/* The printing message for a type name AST node */
	/*************************************************/
	public void PrintMe()
	{
		/**************************************/
		/* AST NODE TYPE = AST TYPE NAME NODE */
		/**************************************/
		// System.out.format("NAME(%s):TYPE(%s)\n",name,type);
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("NAME:TYPE\n%s:%s",name,type));
	}

	/*****************/
	/* SEMANT ME ... */
	/*****************/
	public TYPE SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.format("SEMANTME - NAME(%s):TYPE(%s)\n",name,type);
		TYPE t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null) {
			/**************************/
			/* ERROR: undeclared type */
			/**************************/
			System.out.print(">> ERROR AST_TYPE_NAME undeclared type");
			throw new AST_EXCEPTION(this.lineNumber);
		}
		else
		{
			/*******************************************************/
			/* Enter var with name=name and type=t to symbol table */
			/*******************************************************/
			SYMBOL_TABLE.getInstance().enter(name,t);
		}

		/****************************/
		/* return (existing) type t */
		/****************************/
		return t;
	}

	public TEMP IRme() throws Exception
	{
		// TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();

		// String var_name;
		// String ptr_type;
		// String ptr_type_init_val;
		// int align;

		// IR.getInstance()
		// 	.Add_IRcommand(new IRcommand_Allocate(name, "i32", "0", 4, myScope+1));
		// IR.getInstance()
			// 	.Add_IRcommand(new IRcommand_Load(temp_param, name, myScope));
		System.out.format("IRMe - AST_TYPE_NAME NODE(%s):%s\nScope=%d\n",name, type, myScope+1);
		return null;
	}
}
