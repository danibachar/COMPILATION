package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

import java.util.*;
import javafx.util.Pair;

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

	public TEMP IRme() throws Exception
	{
		//TODO - Specail handling strings, separate needs to handle globaly

		System.out.format("IRme AST_EXP_STRING(%s), Scope=%d\n",value,myScope);
		if (myScope == 0) { return null; }
		if (name == null) {
			System.out.format("ERROR could not find in global vars AST_EXP_STRING(%s), Scope=%d\n",value,myScope);
			throw new AST_EXCEPTION(this.lineNumber);
		}

		// TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Assign_Global_Var_Const_Value(name, value));
			return null;
		// return t;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize AST_EXP_STRING(%s), Scope=%d\n",value,myScope);
		IR.getInstance()
			.Add_IRcommand(new IRcommandConstString(name, value));
	}

	public void InitGlobals() throws Exception {
		// Early return for non globals
		// This String Expression might be part of soome nested scope
		// We want to create const for it. hence the Globalize code above
		// But still,We dont want to init the global var with tis const value at build time, only run time!

		if (myScope > 0) { return; }
		System.out.format("InitGlobals AST_EXP_STRING(%s), Scope=%d\n",value,myScope);
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Assign_Global_Var_Const_Value(name, value));
	}
}
