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
	public AST_DEC_CFIELDS tail;


	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_CFIELDS(AST_DEC head, AST_DEC_CFIELDS tail, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		System.out.format("====================== cFieldsDes \n");
		this.lineNumber = lineNumber;
		this.head = head;
		this.tail = tail;
	}

	/************************************************************/
	/* The printing message for a function declaration AST node */
	/************************************************************/
	public void PrintMe()
	{
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

	public TYPE_LIST SemantMe() throws Exception
	{
		System.out.format("AST_DEC_CFIELDS\n");
		if (tail == null)
		{
			System.out.format("tail = null\n");
			try {
				return new TYPE_LIST(
					head.SemantMe(),
					null
				);
			} catch (Exception e) {
				System.out.print(e);
				e.printStackTrace();
				throw e;
			}

		}
		else
		{
			System.out.format("tail != null\n");
			try {
				return new TYPE_LIST(
					head.SemantMe(),
					tail.SemantMe()
				);
			} catch (Exception e) {
				System.out.print(e);
				e.printStackTrace();
				throw e;
			}

		}
	}
}
