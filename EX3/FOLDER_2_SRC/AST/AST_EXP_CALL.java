package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_CALL extends AST_EXP
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String funcName;
	public AST_EXP_LIST params;
	public AST_EXP_VAR var;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_CALL(String funcName,AST_EXP_LIST params, AST_EXP_VAR var, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.funcName = funcName;
		this.params = params;
		this.var = var;
	}

	/************************************************************/
	/* The printing message for a function declaration AST node */
	/************************************************************/
	public void PrintMe()
	{
		/***************************************/
		/* RECURSIVELY PRINT params + body ... */
		/***************************************/
		if (params != null) params.PrintMe();
		if (var != null) var.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("CALL(%s)\nWITH",funcName));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (params != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,params.SerialNumber);
		if (var != null)  AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		/*************************************************/
		/* AST NODE TYPE = AST NODE FUNCTION DECLARATION */
		/*************************************************/
		System.out.format("CALL(%s)\nWITH:\n",funcName);

		// TODO - Validate

		// Validate that the funcName was already presented in any scope
		TYPE funcType = SYMBOL_TABLE.getInstance().find(funcName);
		if (funcType == null)
		{
			System.out.format(">> ERROR [%d] non existing function %s\n",this.lineNumber,funcName);
			throw new AST_EXCEPTION(this);
		}

		// Validate that it is actually a funciton type, as we need to know its return type
		if (!(funcType instanceof TYPE_FUNCTION))
		{
			System.out.format(">> ERROR [%d] non Supported function type - critical!!! %s\n",this.lineNumber,funcName);
			throw new AST_EXCEPTION(this);
		}

		//Validate that the return type of the function exists
		TYPE_FUNCTION funcTypeValidated = (TYPE_FUNCTION)funcType;
		
		TYPE returnedType = SYMBOL_TABLE.getInstance().find(funcTypeValidated.returnType.name);
		if (returnedType == null)
		{
			System.out.format(">> ERROR [%d] function return type was not presented before calling the function - critical!!! %s\n",this.lineNumber,funcName);
			throw new AST_EXCEPTION(this);
		}

		// validate var (if exists) that is a class
		if (var != null)
		{
				TYPE varType = var.SemantMe();
				if (varType == null || !varType.isClass())
				{
					System.out.format(">> ERROR [%d] calling function on var that is not a class\n",this.lineNumber,funcName);
					throw new AST_EXCEPTION(this);
				}
		}

		// Validate params recursively
		if (params != null) params.SemantMe();

		return funcTypeValidated.returnType;
	}

}
