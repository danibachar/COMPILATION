package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;


public class AST_DEC_CLASS extends AST_DEC
{
	/********/
	/* NAME */
	/********/
	public String name;
	public String parent;
	public AST_DEC_CFIELDS body;
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_CLASS(String name,String parent,AST_DEC_CFIELDS body, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		if (parent != null) {
			System.out.format("====================== classDec -> CLASS ID( %s ) EXTENDS( %s )\n", name, parent);
		} else {
			System.out.format("====================== classDec -> CLASS ID( %s ) \n", name);
		}

		this.lineNumber = lineNumber;
		this.name = name;
		this.parent = parent;
		this.body = body;
	}

	/*********************************************************/
	/* The printing message for a class declaration AST node */
	/*********************************************************/
	public void PrintMe()
	{
		/*************************************/
		/* RECURSIVELY PRINT HEAD + TAIL ... */
		/*************************************/
		System.out.format("CLASS DEC = %s\n",name);

		if (body != null) body.PrintMe();
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("CLASS\n%s",name));

		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,body.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		System.out.format("AST_DEC_CLASS name = %s, parent = %s\n",name, parent);
		/**************************************/
		/* Check That Name does NOT exist */
		/**************************************/
		if (SYMBOL_TABLE.getInstance().find(name) != null)
		{
			System.out.format(">> ERROR [%d] Class %s already exists\n",this.lineNumber,name);
			throw new AST_EXCEPTION(this);
		}

		/**************************************/
		/* Check That Extends previous defined class*/
		/**************************************/
		if (parent != null && SYMBOL_TABLE.getInstance().find(parent) == null)
		{
			System.out.format(">> ERROR [%d] Class %s Extends non existing Class %s\n",this.lineNumber,name, parent);
			throw new AST_EXCEPTION(this);
		}

		// TODO - validate body as follow:
		// func can refer to any data Members
		// func cannot refer to func that was not declared yet


		// We are making some pointer game hhere, not sure it will work
		// 1) creating and adding the type before
		// 2) then semant the body
		// 3) then fetching actual instance (or hold a pointer?) and update the body

		//prepopulate for
		// TYPE_CLASS_VAR_DEC tc = new TYPE_CLASS_VAR_DEC(,name);

		/*************************/
		/* [1] Begin Class Scope */
		/*************************/
		SYMBOL_TABLE.getInstance().beginScope();

		/***************************/
		/* [2] Semant Data Members */
		/***************************/
		TYPE_CLASS father = null;
		if (parent != null) {
			father = (TYPE_CLASS)SYMBOL_TABLE.getInstance().find(parent);
		}
		TYPE_CLASS t = new TYPE_CLASS(father, name, null);
		SYMBOL_TABLE.getInstance().enter(name,t);
		t.data_members = body.SemantMe();

		/*****************/
		/* [3] End Scope */
		/*****************/
		SYMBOL_TABLE.getInstance().endScope();

		/************************************************/
		/* [4] Enter the Class Type to the Symbol Table */
		/************************************************/


		/*********************************************************/
		/* [5] Return value is irrelevant for class declarations */
		/*********************************************************/
		return null;
	}
}
