package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_NIL extends AST_EXP
{
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_NIL(Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		System.out.format("====================== exp -> NIL\n");
		this.lineNumber = lineNumber;
	}

	/******************************************************/
	/* The printing message for a STRING EXP AST node */
	/******************************************************/
	public void PrintMe()
	{
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("NIL\n")
		);
	}

	public TYPE SemantMe() throws Exception
	{
		/*******************************/
		/* AST NODE TYPE = AST STRING EXP */
		/*******************************/
		System.out.format("AST NODE NIL\n");
		return TYPE_NIL.getInstance();
	}

}
