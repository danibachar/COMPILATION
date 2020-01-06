package AST;

import TYPES.*;
import TEMP.*;
import IR.*;
import MIPS.*;
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
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		return TYPE_INT.getInstance();
	}

	public TEMP IRme() throws Exception
	{
		System.out.format("IRme - AST_EXP_INT( %d ), Scope=%d\n",value,myScope);
		TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();
		IR.getInstance().Add_IRcommand(new IRcommandConstInt(t,value));
		return t;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_INT( %d ), Scope=%d\n",value,myScope);
		throw new AST_EXCEPTION(this.lineNumber);
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_INT( %d ), Scope=%d\n",value,myScope);
		throw new AST_EXCEPTION(this.lineNumber);
	}

}
