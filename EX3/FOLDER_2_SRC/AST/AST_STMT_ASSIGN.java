package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_STMT_ASSIGN extends AST_STMT
{
	/***************/
	/*  var := exp */
	/***************/
	public AST_EXP_VAR var;
	public AST_EXP exp;

	/*******************/
	/*  CONSTRUCTOR(S) */
	/*******************/
	public AST_STMT_ASSIGN(AST_EXP_VAR var,AST_EXP exp, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		System.out.print("====================== stmt -> var ASSIGN exp SEMICOLON\n");

		this.lineNumber = lineNumber;
		this.var = var;
		this.exp = exp;
	}

	/*********************************************************/
	/* The printing message for an assign statement AST node */
	/*********************************************************/
	public void PrintMe()
	{
		/********************************************/
		/* AST NODE TYPE = AST ASSIGNMENT STATEMENT */
		/********************************************/
		System.out.print("AST NODE ASSIGN STMT\n");

		/***********************************/
		/* RECURSIVELY PRINT VAR + EXP ... */
		/***********************************/
		if (var != null) var.PrintMe();
		if (exp != null) exp.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"ASSIGN\nleft := right\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,exp.SerialNumber);
	}
	public TYPE SemantMe() throws Exception
	{
		TYPE t1 = null;
		TYPE t2 = null;

		if (var != null) t1 = var.SemantMe();
		if (exp != null) t2 = exp.SemantMe();

		// Maybe validate that types exists


		// allow class and array to get nil
		boolean isOneClass = t1.isClass() || t2.isClass();
		boolean isOneNil = t1 == TYPE_NIL.getInstance() || t2 == TYPE_NIL.getInstance();
		if (isOneClass && isOneNil)
		{
			return null;
		}

		//Allow assignment for inheritance - oneway!
		if (isOneClass && isOneNil)
		{
			return null;
		}

		// Validate same type
		if (t1 != t2)
		{
			System.out.format(">> ERROR [%d] type mismatch for var := exp\n",this.lineNumber);
			throw new AST_EXCEPTION(this);
		}
		return null;
	}
}
