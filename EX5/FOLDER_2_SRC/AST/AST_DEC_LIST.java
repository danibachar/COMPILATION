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
import Pair.*;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

public class AST_DEC_LIST extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_DEC head;
	public AST_DEC_LIST tail;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_LIST(AST_DEC head,AST_DEC_LIST tail)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.head = head;
		this.tail = tail;
	}

	/********************************************************/
	/* The printing message for a declaration list AST node */
	/********************************************************/
	public void PrintMe()
	{
		// System.out.format("DEC_LIST\n");
		/*************************************/
		/* RECURSIVELY PRINT HEAD + TAIL ... */
		/*************************************/
		if (head != null) head.PrintMe();
		if (tail != null) tail.PrintMe();

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"DEC\nLIST\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (head != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,head.SerialNumber);
		if (tail != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,tail.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.format("SEMANTME - DEC_LIST\n");
		/*************************************/
		/* RECURSIVELY PRINT HEAD + TAIL ... */
		/*************************************/
		if (head != null) head.SemantMe();
		if (tail != null) tail.SemantMe();

		return null;
	}

	public TEMP IRme() throws Exception
	{
		// System.out.format("IRme - DEC_LIST, Scope=%d\n", myScope);
		if (head != null) head.IRme();
		if (tail != null) tail.IRme();
		if (tail == null)
		{
			// System.out.println("Done IR'ing!");
		}
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - DEC_LIST, Scope=%d\n", myScope);
		if (head != null) head.Globalize();
		if (tail != null) tail.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - DEC_LIST, Scope=%d\n", myScope);
		if (head != null) head.InitGlobals();
		if (tail != null) tail.InitGlobals();
	}

}
