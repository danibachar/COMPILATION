package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_VAR_SIMPLE extends AST_EXP_VAR
{
	/************************/
	/* simple variable name */
	/************************/
	public String name;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_VAR_SIMPLE(String name, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		System.out.format("====================== var -> ID( %s )\n",name);
		this.lineNumber = lineNumber;
		this.name = name;
	}

	/**************************************************/
	/* The printing message for a simple var AST node */
	/**************************************************/
	public void PrintMe()
	{
		/**********************************/
		/* AST NODE TYPE = AST SIMPLE VAR */
		/**********************************/
		System.out.format("AST NODE SIMPLE VAR( %s )\n",name);

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("SIMPLE\nVAR\n(%s)",name));
	}
	public TYPE SemantMe() throws Exception
	{
		// Search Full Scope for any declaration, will return null if not found
		return SYMBOL_TABLE.getInstance().find(name);
	}
}
