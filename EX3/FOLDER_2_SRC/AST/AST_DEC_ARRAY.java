package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_DEC_ARRAY extends AST_DEC
{
	/********/
	/* NAME */
	/********/
	// public String name;
	public String type;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_ARRAY(String name,String type, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		System.out.format("====================== arrayDec -> ARRAY( %s ) ID( %s ) = ID []\n", type, name);

		this.lineNumber = lineNumber;
		this.name = name;
		this.type = type;
	}

	public void PrintMe()
	{
		System.out.format("AST_DEC_ARRAY name = %s, type = %s\n",name, type);
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("ARRAY\nDEC(%s)\n:%s",name,type));
	}

	public TYPE SemantMe() throws Exception
	{
		TYPE t;
		System.out.format("SEMANTME - AST_DEC_ARRAY name = %s, type = %s\n",name, type);
		/****************************/
		/* [1] Check If Type exists */
		/****************************/
		t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null)
		{
			System.out.format(">> ERROR [%d] non existing type %s\n",this.lineNumber,type);
			throw new AST_EXCEPTION(this);
		}

		/**************************************/
		/* [2] Check That Name does NOT exist */
		/**************************************/
		if (SYMBOL_TABLE.getInstance().find(name) != null)
		{
			System.out.format(">> ERROR [%d] array %s already exists in scope\n",this.lineNumber,name);
			throw new AST_EXCEPTION(this);
		}

		/***************************************************/
		/* [3] Enter the Function Type to the Symbol Table */
		/***************************************************/
		SYMBOL_TABLE.getInstance().enter(name,t);

		/*********************************************************/
		/* [4] Return value is irrelevant for class declarations */
		/*********************************************************/
		return null;
	}
}
