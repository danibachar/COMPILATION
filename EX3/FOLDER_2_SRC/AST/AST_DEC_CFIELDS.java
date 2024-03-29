package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

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

	// public TYPE_CLASS_VAR_DEC_LIST SemantMe() throws Exception
	// {
	// 	System.out.format("!!!!!!!! SHOULD NOT BE CALLED HANDLED IN CLASS!!!!!!!!!!!!!\n");
	//
	// 	if (head == null) {
	// 			System.out.format("SEMANTME - AST_DEC_CFIELDS with null as head - critical issue\n");
	// 	} else {
	// 			System.out.format("SEMANTME - AST_DEC_CFIELDS\n");
	// 	}
	//
	// 	if (tail == null)
	// 	{
	// 		try {
	// 			TYPE_CLASS_VAR_DEC cv = new TYPE_CLASS_VAR_DEC(head.SemantMe(), head.name);
	// 			System.out.format("AST_DEC_CFIELDS( head) head name = %s, type = %s\n", cv.name, cv.t);
	// 			return new TYPE_CLASS_VAR_DEC_LIST(cv,null);
	// 			// return new TYPE_LIST(head.SemantMe(),null);
	// 		} catch (Exception e) {
	// 			System.out.print(e);
	// 			e.printStackTrace();
	// 			throw e;
	// 		}
	//
	// 	}
	// 	else
	// 	{
	// 		try {
	// 			TYPE_CLASS_VAR_DEC cv = new TYPE_CLASS_VAR_DEC(head.SemantMe(), head.name);
	// 			System.out.format("AST_DEC_CFIELDS (head+tail) head name = %s, type = %s\n", cv.name, cv.t);
	// 			return new TYPE_CLASS_VAR_DEC_LIST(cv,tail.SemantMe());
	// 			// return new TYPE_LIST(head.SemantMe(),tail.SemantMe());
	// 		} catch (Exception e) {
	// 			System.out.print(e);
	// 			e.printStackTrace();
	// 			throw e;
	// 		}
	//
	// 	}
	// }
}
