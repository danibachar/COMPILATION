package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_DEC_FUNC extends AST_DEC
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String returnTypeName;
	// public String name;
	public AST_TYPE_NAME_LIST params;
	public AST_STMT_LIST body;

	public boolean isFuncDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_FUNC(
		String returnTypeName,
		String name,
		AST_TYPE_NAME_LIST params,
		AST_STMT_LIST body,
		Integer lineNumber
	) {
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.returnTypeName = returnTypeName;
		this.name = name;
		this.params = params;
		this.body = body;
	}

	/************************************************************/
	/* The printing message for a function declaration AST node */
	/************************************************************/
	public void PrintMe()
	{
		/*************************************************/
		/* AST NODE TYPE = AST NODE FUNCTION DECLARATION */
		/*************************************************/
		// System.out.format("AST_DEC_FUNC(%s):%s\n",name,returnTypeName);
		/***************************************/
		/* RECURSIVELY PRINT params + body ... */
		/***************************************/
		if (params != null) params.PrintMe();
		if (body   != null) body.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("FUNC(%s)\n:%s\n",name,returnTypeName));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (params != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,params.SerialNumber);
		if (body   != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,body.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		TYPE t;
		TYPE returnType = null;
		TYPE_LIST type_list = null;
		// System.out.format("SEMANTME - AST_DEC_FUNC(%s):%s\n",name,returnTypeName);

		/*******************/
		/* [0] return type */
		/*******************/
		returnType = SYMBOL_TABLE.getInstance().find(returnTypeName);
		if (returnType == null)
		{
			System.out.format(">> ERROR [%d] non existing return type %s\n",this.lineNumber,returnType);
			throw new AST_EXCEPTION(this);
		}

		// MAKE Sure there is no same function with same name in the current scope?
		TYPE temp = SYMBOL_TABLE.getInstance().findInCurrentScope(name);
		if (temp != null)
		{
			System.out.format(">> ERROR [%d] method `%s` already exists in scope, found `%s`\n",this.lineNumber,name, temp.name);
			throw new AST_EXCEPTION(this);
		}

		/****************************/
		/* [1] Begin Function Scope */
		/****************************/
		SYMBOL_TABLE.getInstance().beginScope();

		/***************************/
		/* [2] Semant Input Params */
		/***************************/

		for (AST_TYPE_NAME_LIST it = params; it  != null; it = it.tail) {

			t = SYMBOL_TABLE.getInstance().find(it.head.type);
			if (t == null) {
				System.out.format(">> ERROR [%d] non existing type %s\n",this.lineNumber, it.head.type);
				throw new AST_EXCEPTION(this);
			} else {
				// System.out.format("Semant Input Params(%s):%s\n",name,returnTypeName);
				// System.out.format("Semant Input Params(%s):%s:%s\n",it.head.name,it.head.type,t);
				type_list = new TYPE_LIST(t,type_list);
				SYMBOL_TABLE.getInstance().enter(it.head.name,t);
			}
		}

		// Adding before the body Semantic Analysis for recursive purpuse
		// After the scope will get close it will remove the symbole from the TABLE
		// So we are adding it once more after the scope closed
		TYPE_FUNCTION f = new TYPE_FUNCTION(returnType,name,type_list);
		SYMBOL_TABLE.getInstance().enter(name,f);
		SYMBOL_TABLE.getInstance().current_function = f;
		/*********************************************/
		/* 							[3] Semant Body 						 */
		/* Note that we allow empty body of function */
		/*********************************************/
		TYPE actualReturnType = null;
		if (body != null) { actualReturnType = body.SemantMe(); }

		// Validate the the actual return type from the body is identical to the retuen type configured
		// TODO -- actualReturnType == returnType
		// if (actualReturnType != returnType)
		// {
		// 	System.out.format(">> ERROR [%d] return type = %s, and body (actual return type = %s) are not the same \n",this.lineNumber, returnType, actualReturnType);
		// 	throw new AST_EXCEPTION(this);
		// }
		/*****************/
		/* [4] End Scope */
		/*****************/
		SYMBOL_TABLE.getInstance().endScope();

		/***************************************************/
		/* [5] Enter the Function Type to the Symbol Table */
		/***************************************************/
		SYMBOL_TABLE.getInstance().enter(name,f);

		/*********************************************************/
		/* [6] Return value is irrelevant for class declarations */
		/*********************************************************/
		//TODO - validae if we need to return
		// return null;
		SYMBOL_TABLE.getInstance().current_function = null;
		return returnType;
	}

}
