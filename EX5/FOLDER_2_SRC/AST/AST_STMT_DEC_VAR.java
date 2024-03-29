package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import Pair.*;
import java.util.*;

public class AST_STMT_DEC_VAR extends AST_STMT
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_DEC_VAR var;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_STMT_DEC_VAR(AST_DEC_VAR var, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.var = var;
	}

	public void PrintMe()
	{

		// System.out.print("AST_STMT_DEC_VAR\n");
		if (var != null) var.PrintMe();
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("STMT\nDEC\nVAR"));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.print("SEMANTME - AST_STMT_DEC_VAR\n");
		return var.SemantMe();
	}

	public TEMP IRme() throws Exception
	{
		// System.out.format("IRme - AST_STMT_DEC_VAR\nScope=%d\n",myScope);
		return var.IRme();
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_STMT_DEC_VAR\nScope=%d\n",myScope);
		if (var != null) var.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_STMT_DEC_VAR\nScope=%d\n",myScope);
		if (var != null) var.InitGlobals();
	}

}
