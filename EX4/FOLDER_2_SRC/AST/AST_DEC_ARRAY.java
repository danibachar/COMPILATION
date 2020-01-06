package AST;

import TEMP.*;
import IR.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import java.util.ArrayList;

public class AST_DEC_ARRAY extends AST_DEC
{
	/********/
	/* NAME */
	/********/
	public String type;
	public Integer typeLineNumber;
	public boolean isArrayDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_ARRAY(String name,Integer nameLineNumber,String type, Integer typeLineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// System.out.format("====================== arrayDec -> ARRAY( %s ) ID( %s ) \n", type, name);
		this.name = name;
		this.nameLineNumber = nameLineNumber;

		this.type = type;
		this.typeLineNumber = typeLineNumber;
	}

	public void PrintMe()
	{
		// System.out.format("AST_DEC_ARRAY name = %s, type = %s\n",name, type);
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
		// System.out.format("SEMANTME - AST_DEC_ARRAY name = %s, type = %s\n",name, type);
		/********************************************/
		/*Make sure we are at the most outer scope	*/
		/********************************************/
		if (SYMBOL_TABLE.getInstance().scopeCount > 0) {
			System.out.format(">> ERROR [%d] Array %s defined not in most outer scope\n",this.nameLineNumber,name);
			throw new AST_EXCEPTION(this.nameLineNumber);
		}

		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		/****************************/
		/* [1] Check If Type exists */
		/****************************/
		// System.out.format("@@@@ AST_DEC_ARRAY type:%s\n",type);
		// System.out.format("@@@@ AST_DEC_ARRAY name:%s\n",name);
		t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null)
		{
			System.out.format(">> ERROR [%d] non existing type %s\n",this.typeLineNumber,type);
			throw new AST_EXCEPTION(this.typeLineNumber);
		}

		/**************************************/
		/* [2] Check That Name does NOT exist */
		/**************************************/
		if (SYMBOL_TABLE.getInstance().find(name) != null)
		{
			System.out.format(">> ERROR [%d] array %s already exists in scope\n",this.nameLineNumber,name);
			throw new AST_EXCEPTION(this.nameLineNumber);
		}

		/**************************************/
		/* [2] Dont allow void arrays 				*/
		/**************************************/
		if (t == TYPE_VOID.getInstance())
		{
			System.out.format(">> ERROR [%d] array %s cannot be of type(%s) void\n",this.typeLineNumber,name,t);
			throw new AST_EXCEPTION(this.typeLineNumber);
		}

		/***************************************************/
		/* [3] Enter the Function Type to the Symbol Table */
		/***************************************************/
		TYPE_ARRAY newT = new TYPE_ARRAY(name, t);
		SYMBOL_TABLE.getInstance().enter(name,newT);
		myType = newT;
		/*********************************************************/
		/* [4] Return value is irrelevant for class declarations */
		/*********************************************************/
		return null;
	}

	public TEMP IRme() throws Exception
	{

		System.out.format("IRme - AST_DEC_ARRAY name = %s, type = %s\nScope=%d\n",name, type,myScope);
		// IR.getInstance().Add_IRcommand(new IRcommand_Label("main"));
		// if (body != null) body.IRme();
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_DEC_ARRAY name = %s, type = %s\nScope=%d\n",name, type,myScope);
		throw new AST_EXCEPTION(this.lineNumber);
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_DEC_ARRAY name = %s, type = %s\nScope=%d\n",name, type,myScope);
		throw new AST_EXCEPTION(this.lineNumber);
	}
}
