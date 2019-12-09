package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_STMT_RETURN extends AST_STMT
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_EXP exp;

	/*******************/
	/*  CONSTRUCTOR(S) */
	/*******************/
	public AST_STMT_RETURN(AST_EXP exp, Integer lineNumber)
	{
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.exp = exp;
	}

	/************************************************************/
	/* The printing message for a function declaration AST node */
	/************************************************************/
	public void PrintMe()
	{
		// System.out.print("AST_STMT_RETURN\n");
		/*****************************/
		/* RECURSIVELY PRINT exp ... */
		/*****************************/
		if (exp != null) exp.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"RETURN");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (exp != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,exp.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		/*************************************/
		/* AST NODE TYPE = AST SUBSCRIPT VAR */
		/*************************************/
		System.out.print("SEMANTME - AST_STMT_RETURN\n");

		TYPE_FUNCTION func = SYMBOL_TABLE.getInstance().current_function;
		if (func == null) {
			System.out.format(">> ERROR [%d] trying to return from none function\n",this.lineNumber);
			throw new AST_EXCEPTION(this);
		}

		/****************************/
		/* [0] Semant the Condition */
		/****************************/
		TYPE exp_type = null;
		if (exp != null) exp_type = exp.SemantMe();

		// If no exp_type func.returnType must be void!
		if (exp_type != null && func.returnType == TYPE_VOID.getInstance()) {
			System.out.format(">> ERROR [%d] trying return type(%s) from void function)\n",this.lineNumber, exp_type);
			throw new AST_EXCEPTION(this);
		}

		if (exp_type == null && func.returnType != TYPE_VOID.getInstance()) {
			System.out.format(">> ERROR [%d] trying return void from non-void return type(%s) function)\n",this.lineNumber, func.returnType);
			throw new AST_EXCEPTION(this);
		}

		if (func.returnType.getClass() != exp_type.getClass()) {
			// Check if it is class var dec
			if (exp_type.isClassVar()) {
					TYPE_CLASS_VAR_DEC exp_class_var_type = (TYPE_CLASS_VAR_DEC)exp_type;
					if (exp_class_var_type.getClass() == func.returnType.getClass()) {
						return null;
					}
			}
			System.out.format(">> ERROR [%d] declared return type(%s) is different from func body return type(%s)\n",this.lineNumber, func.returnType, exp_type);
			throw new AST_EXCEPTION(this);
		}

		/*********************************************************/
		/* [4] Return value is irrelevant for class declarations */
		/*********************************************************/
		return null;
	}
}
