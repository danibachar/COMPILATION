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
		System.out.print("AST_STMT_ASSIGN\n");
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
		System.out.print("SEMANTME - AST_STMT_ASSIGN\n");
		TYPE t1 = null;
		TYPE t2 = null;

		if (var != null) {
			t1 = var.SemantMe();
			System.out.format("SEMANTME - AST_STMT_ASSIGN var name = %s\n", t1.name);
		}
		if (exp != null) {
			t2 = exp.SemantMe();
			System.out.format("SEMANTME - AST_STMT_ASSIGN exp name = %s\n", t2.name);
		}


		// Maybe validate that types exists


		// allow class and array to get nil
		if (t1.isClass() && t2 == TYPE_NIL.getInstance())
		{
			System.out.format("SEMANTME - AST_STMT_ASSIGN allow class to be nil\n");
			return null;
		}
		if (t1.isArray() && t2 == TYPE_NIL.getInstance())
		{
			System.out.format("SEMANTME - AST_STMT_ASSIGN allow array to be nil\n");
			return null;
		}
		//Allow assignment for inheritance - oneway!
		if (t1.isClass() && t2.isClass())
		{
			TYPE_CLASS t1_cast = (TYPE_CLASS)t1;
			TYPE_CLASS t2_cast = (TYPE_CLASS)t2;
			if (t1_cast.isAssignableFrom(t2_cast))
			{
				System.out.format("SEMANTME - AST_STMT_ASSIGN t1 can be assigned t2\n");
				return null;
			}
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
