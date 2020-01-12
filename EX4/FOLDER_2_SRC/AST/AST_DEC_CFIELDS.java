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

public class AST_DEC_CFIELDS extends AST_DEC
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_DEC head;
	public Integer headLineNumber;
	public AST_DEC_CFIELDS tail;
	public Integer tailLineNumber;


	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_CFIELDS(
		AST_DEC head,
		Integer headLineNumber,
		AST_DEC_CFIELDS tail,
		Integer tailLineNumber
	){
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// System.out.format("====================== cFieldsDes \n");
		this.head = head;
		this.headLineNumber = headLineNumber;
		this.tail = tail;
		this.tailLineNumber = tailLineNumber;
	}

	/************************************************************/
	/* The printing message for a function declaration AST node */
	/************************************************************/
	public void PrintMe()
	{
		// System.out.format("AST_DEC_CFIELDS\n");
		/***************************************/
		/* RECURSIVELY PRINT params + body ... */
		/***************************************/
		if (head != null) head.PrintMe();
		if (tail != null) tail.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("CFIELDS"));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (head != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,head.SerialNumber);
		if (tail != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,tail.SerialNumber);
	}

	public TEMP IRme() throws Exception
	{
		// System.out.format("IRme - AST_DEC_CFIELDS\n");
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_DEC_CFIELDS\n");
		if (head != null) head.Globalize();
		if (tail != null) tail.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_DEC_CFIELDS\n");
		if (head != null) head.Globalize();
		if (tail != null) tail.Globalize();
	}
}
