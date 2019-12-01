package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_TYPE_NAME_LIST extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_TYPE_NAME head;
	public AST_TYPE_NAME_LIST tail;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_TYPE_NAME_LIST(AST_TYPE_NAME head,AST_TYPE_NAME_LIST tail,Integer lineNumber)
	{
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.head = head;
		this.tail = tail;
	}

	/******************************************************/
	/* The printing message for a type name list AST node */
	/******************************************************/
	public void PrintMe()
	{
		/**************************************/
		/* AST NODE TYPE = AST TYPE NAME LIST */
		/**************************************/
		System.out.print("AST TYPE NAME LIST\n");

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
			"TYPE-NAME\nLIST\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (head != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,head.SerialNumber);
		if (tail != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,tail.SerialNumber);
	}

	public TYPE_LIST SemantMe() throws Exception
	{
		if (tail == null)
		{
			try {
				return new TYPE_LIST(
					head.SemantMe(),
					null
				);
			} catch (Exception e) {
				throw new AST_EXCEPTION(this);
			}

		}
		else
		{
			try {
				return new TYPE_LIST(
					head.SemantMe(),
					tail.SemantMe()
				);
			} catch (Exception e) {
				throw new AST_EXCEPTION(this);
			}

		}
	}
}
