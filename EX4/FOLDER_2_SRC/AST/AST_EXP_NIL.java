package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import java.util.ArrayList;
import javafx.util.Pair;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

public class AST_EXP_NIL extends AST_EXP
{
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public boolean isConstExp() { return true;}
	public AST_EXP_NIL(Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		// System.out.format("====================== exp -> NIL\n");
		this.lineNumber = lineNumber;
	}

	/******************************************************/
	/* The printing message for a STRING EXP AST node */
	/******************************************************/
	public void PrintMe()
	{
		/*******************************/
		/* AST NODE TYPE = AST STRING EXP */
		/*******************************/
		// System.out.format("AST_EXP_NIL\n");
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
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.format("SEMANTME -AST_EXP_NIL\n");
		return TYPE_NIL.getInstance();
	}

	public TEMP IRme() throws Exception
	{
		// System.out.format("IRme AST_EXP_NIL\nScope=%d\n",myScope);
		TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();
		t.setType( TYPE_NIL.getInstance());
		IR.getInstance().Add_IRcommand(new IRcommandNull(t));
		t.isaddr = false;
		return t;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize AST_EXP_NIL\nScope=%d\n",myScope);
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals AST_EXP_NIL\nScope=%d\n",myScope);
	}

}
