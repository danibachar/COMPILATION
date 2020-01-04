package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_STRING extends AST_EXP
{
	public String value;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public boolean isConstExp() { return true;}
	public AST_EXP_STRING(String value, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		// System.out.format("====================== exp -> STRING( %s )\n", value);
		this.lineNumber = lineNumber;
		this.value = value;
	}

	/******************************************************/
	/* The printing message for a STRING EXP AST node */
	/******************************************************/
	public void PrintMe()
	{
		/*******************************/
		/* AST NODE TYPE = AST STRING EXP */
		/*******************************/
		// System.out.format("AST_EXP_STRING( %s )\n",value);
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("STRING\n%s",value.replace('"','\'')));
	}
	public TYPE SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.format("SEMANTME - AST_EXP_STRING( %s )\n",value);
		return TYPE_STRING.getInstance();
	}

	public TEMP IRme() throws Exception
	{
		//TODO - Specail handling strings, separate needs to handle globaly

		System.out.format("IRme AST_EXP_STRING(%s), Scope=%d\n",value,myScope);
		if (myScope == 0) {
				return null;
		}
		TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();
		// IR.getInstance().Add_IRcommand(new IRcommandTempString(t,value));
		return t;
		// return null;

	}
}
