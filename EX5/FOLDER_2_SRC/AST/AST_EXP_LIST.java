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

public class AST_EXP_LIST extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_EXP head;
	public AST_EXP_LIST tail;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_LIST(AST_EXP head,AST_EXP_LIST tail, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.head = head;
		this.tail = tail;
	}
	/******************************************************/
	/* The printing message for a statement list AST node */
	/******************************************************/
	public void PrintMe()
	{
		/********************************/
		/* AST NODE TYPE = AST EXP LIST */
		/********************************/
		// System.out.print("AST_EXP_LIST\n");
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
			"EXP\nLIST\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (head != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,head.SerialNumber);
		if (tail != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,tail.SerialNumber);
	}
	public TYPE_LIST SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.print("SEMANTME - AST_EXP_LIST\n");
		if (tail == null) {
			try {
				return new TYPE_LIST(head.SemantMe(),null);
			} catch (Exception e) {
				System.out.print(e);
				e.printStackTrace();
				throw e;
			}
		} else {
			try {
				return new TYPE_LIST(head.SemantMe(),tail.SemantMe());
			} catch (Exception e) {
				System.out.print(e);
				e.printStackTrace();
				throw e;
			}
		}
	}
	public TEMP IRme() throws Exception
	{
		// We are handling this outside of this node!
		// The onle other node that is actually using this AST is AST_EXP_CALL
		// Which needs to hold the list of params
		// System.out.format("IRme - AST_EXP_LIST\nnScope=%d\n",myScope);
		TEMP_LIST result = new TEMP_LIST();

		if (head != null) {
				result.head = head.IRme();
		}
		if (tail != null) {
			result.tail = (TEMP_LIST) tail.IRme();
		}

		return result;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_LIST\nnScope=%d\n",myScope);
		if (head != null) head.Globalize();
		if (tail != null) tail.Globalize();
	}
	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_LIST\nnScope=%d\n",myScope);
		if (head != null) head.InitGlobals();
		if (tail != null) tail.InitGlobals();
	}

}
