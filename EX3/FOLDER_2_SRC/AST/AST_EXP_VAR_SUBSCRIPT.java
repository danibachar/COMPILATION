package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_VAR_SUBSCRIPT extends AST_EXP_VAR
{
	public AST_EXP_VAR var;
	public AST_EXP subscript;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_VAR_SUBSCRIPT(AST_EXP_VAR var,AST_EXP subscript, Integer lineNumber)
	{
		System.out.print("====================== var -> var [ exp ]\n");
		this.lineNumber	= lineNumber;
		this.var = var;
		this.subscript = subscript;
	}

	/*****************************************************/
	/* The printing message for a subscript var AST node */
	/*****************************************************/
	public void PrintMe()
	{
		/*************************************/
		/* AST NODE TYPE = AST SUBSCRIPT VAR */
		/*************************************/
		System.out.print("AST NODE SUBSCRIPT VAR\n");

		/****************************************/
		/* RECURSIVELY PRINT VAR + SUBSRIPT ... */
		/****************************************/
		if (var != null) var.PrintMe();
		if (subscript != null) subscript.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"SUBSCRIPT\nVAR\n...[...]");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (var       != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
		if (subscript != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,subscript.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		TYPE varType;
		TYPE subscriptType;

		System.out.print("AST_EXP_VAR_SUBSCRIPT\n");

		// Validate that the var is kind of array AST_EXP_VAR
		if (var != null)
		{
			 varType = var.SemantMe();
			 if (!varType.isArray())
	 		{
	 			System.out.format(">> ERROR [%d] Trying access var subscript of non array type\n",this.lineNumber);
	 			throw new AST_EXCEPTION(this);
	 		}
		}

		// Validate that the subscript is kind of int AST_EXP
		if (subscript != null)
		{
				subscriptType = subscript.SemantMe();
				if (subscriptType == null|| (subscriptType == TYPE_INT.getInstance()) )
				{
					System.out.format(">> ERROR [%d] Trying access var subscript with non-integral index\n",this.lineNumber);
					throw new AST_EXCEPTION(this);
				}
		}

		return null;
	}
}
