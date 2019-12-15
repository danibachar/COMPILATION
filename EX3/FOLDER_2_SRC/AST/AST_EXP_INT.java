package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_INT extends AST_EXP
{
	public int value;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public boolean isConstExp() { return true;}
	public AST_EXP_INT(int value, Integer lineNumber) {
			this(value, true, lineNumber);
	}
	public AST_EXP_INT(int value, boolean sign, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();
		value = value * (sign ? 1 : -1);
		if (value >= 32768 || value < -32768) {

		}
		// System.out.format("====================== exp -> INT( %d )\n", value);
		this.lineNumber = lineNumber;
		this.value = value;
	}

	/************************************************/
	/* The printing message for an INT EXP AST node */
	/************************************************/
	public void PrintMe()
	{
		/*******************************/
		/* AST NODE TYPE = AST INT EXP */
		/*******************************/
		// System.out.format("AST_EXP_INT( %d )\n",value);
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("INT(%d)",value));
	}

	public TYPE SemantMe() throws Exception
	{
		// System.out.format("SEMANTME - AST_EXP_INT( %d )\n",value);
		return TYPE_INT.getInstance();
	}
}
