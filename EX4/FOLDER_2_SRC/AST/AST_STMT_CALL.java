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

public class AST_STMT_CALL extends AST_STMT
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_EXP_CALL callExp;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_STMT_CALL(AST_EXP_CALL callExp, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.callExp = callExp;
	}

	public void PrintMe()
	{
		// System.out.print("AST_STMT_CALLT\n");
		if (callExp != null) callExp.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("STMT\nCALL"));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,callExp.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.print("SEMANTME - AST_STMT_CALL\n");
		return callExp.SemantMe();
	}

	public TEMP IRme() throws Exception
	{

		// System.out.format("IRme - AST_STMT_CALL\nScope=%d\n",myScope);
		if (callExp != null) callExp.IRme();

		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_STMT_CALL\nScope=%d\n",myScope);
		if (callExp != null) callExp.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_STMT_CALL\nScope=%d\n",myScope);
		if (callExp != null) callExp.InitGlobals();
	}

}
