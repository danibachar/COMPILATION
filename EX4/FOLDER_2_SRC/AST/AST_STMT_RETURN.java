package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import javafx.util.Pair;
import java.util.*;

public class AST_STMT_RETURN extends AST_STMT
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_EXP exp;
	public TYPE expectedRetType;
	/*******************/
	/*  CONSTRUCTOR(S) */
	/*******************/
	public AST_STMT_RETURN(AST_EXP exp, Integer lineNumber)
	{
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.exp = exp;
	}

	public void setReturnType(TYPE retType) throws Exception
	{
		if (expectedRetType != null)
		{
			System.out.format("Return type can not be defined twice\n");
			throw new AST_EXCEPTION(this.lineNumber);
		}
		expectedRetType = retType;

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
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		/*************************************/
		/* AST NODE TYPE = AST SUBSCRIPT VAR */
		/*************************************/
		// System.out.print("SEMANTME - AST_STMT_RETURN\n");

		TYPE_FUNCTION func = SYMBOL_TABLE.getInstance().current_function;
		if (func == null) {
			System.out.format(">> ERROR [%d] trying to return from none function\n",this.lineNumber);
			throw new AST_EXCEPTION(this.lineNumber);
		}

		/****************************/
		/* [0] Semant the Condition */
		/****************************/
		TYPE exp_type = null;
		if (exp != null) exp_type = exp.SemantMe();
		myType = exp_type;
		if (exp_type == null) {
			if (func.returnType == null) {
				return null;
			}
			if (func.returnType == TYPE_VOID.getInstance()) {
				return null;
			}
			System.out.format(">> ERROR [%d] trying return void from non-void return type(%s) function)\n",this.lineNumber, func.returnType);
			throw new AST_EXCEPTION(this.lineNumber);
		}

		// If no exp_type func.returnType must be void!
		if (exp_type != null) {
			if (func.returnType == null) {
				System.out.format(">> ERROR [%d] trying return type(%s) from void or non existsfunction)\n",this.lineNumber, exp_type);
				throw new AST_EXCEPTION(this.lineNumber);
			}
			if (func.returnType == TYPE_VOID.getInstance()) {
				System.out.format(">> ERROR [%d] trying return type(%s) from void function)\n",this.lineNumber, exp_type);
				throw new AST_EXCEPTION(this.lineNumber);
			}

		}

		if (func.returnType.getClass() != exp_type.getClass()) {
			// Check if it is class var dec
			if (exp_type.isClassVar()) {
					TYPE_CLASS_VAR_DEC exp_class_var_type = (TYPE_CLASS_VAR_DEC)exp_type;
					myType = exp_class_var_type.t;
					if (exp_class_var_type.t.getClass() == func.returnType.getClass()) {
						return null;
					}
			}
			System.out.format(">> ERROR [%d] declared return type(%s) is different from func body return type(%s)\n",this.lineNumber, func.returnType, exp_type);
			throw new AST_EXCEPTION(this.lineNumber);
		}

		/*********************************************************/
		/* [4] Return value is irrelevant for class declarations */
		/*********************************************************/
		return null;
	}

	public TEMP IRme() throws Exception
	{
		TEMP retVal = null;
		if (exp != null) retVal= exp.IRme();
		if (retVal !=null)
		{

			if (retVal.isaddr){
				TEMP val = TEMP_FACTORY.getInstance().getFreshTEMP();
				val.setType(myType);
				val.checkInit = retVal.checkInit;
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(val, retVal));
				retVal = val;
			}
		}

		IR.getInstance().Add_IRcommand(new IRcommand_Return(retVal));
		// TODO: prepare ret value and use IRCommand for ret'ing it
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_STMT_RETURN NODE\n");
		if (exp != null) {  exp.Globalize(); }
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_STMT_RETURN NODE\n");
		if (exp != null) {  exp.InitGlobals(); }
	}
}
