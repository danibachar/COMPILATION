package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import LocalVarCounter.*;
import LLVM.*;
import javafx.util.Pair;
import java.util.*;

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
		this.value = value.replace("\"", "");;
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

		return TYPE_STRING.getInstance();
	}

	public TEMP IRme()
	{
		// TODO: String is not a fixed-size length (addition of 2 string for example can create any-sized string)
		// We probably want some variable-length allocation here, maybe allocate on HEAP somehow?
		TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();
		t.setType(TYPE_STRING.getInstance());
		IR.getInstance().Add_IRcommand(new IRcommandConstString(t,value));
		return t;
	}
}
