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
import var_c.*;
import LLVM.*;
import javafx.util.Pair;
import java.util.*;

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
	public AST_TYPE_NAME(String type, String name,Integer lineNumber)
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
		System.out.format("IRme - AST_TYPE_NAME NODE(%s):%s, Scope=%d\n",name, type, myScope+1);
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_TYPE_NAME NODE(%s):%s, Scope=%d\n",name, type, myScope+1);
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_TYPE_NAME NODE(%s):%s, Scope=%d\n",name, type, myScope+1);
	}
}
