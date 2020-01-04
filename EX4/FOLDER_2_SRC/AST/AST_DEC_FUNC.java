package AST;

import java.util.ArrayList;

import TYPES.*;
import SYMBOL_TABLE.*;
import TEMP.*;
import IR.*;
import MIPS.*;
import AST_EXCEPTION.*;

public class AST_DEC_FUNC extends AST_DEC
{
	/****************/
	/* DATA MEMBERS */
	/****************/

	public String returnTypeName;
	public Integer returnTypeNameLineNumber;
	public AST_TYPE_NAME_LIST params;
	public Integer paramsLineNumber;
	public AST_STMT_LIST body;
	public Integer bodyLineNumber;

	public boolean isFuncDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_FUNC(
		String returnTypeName,
		Integer returnTypeNameLineNumber,
		String name,
		Integer nameLineNumber,
		AST_TYPE_NAME_LIST params,
		Integer paramsLineNumber,
		AST_STMT_LIST body,
		Integer bodyLineNumber
	) {
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.name = name;
		this.nameLineNumber = nameLineNumber;

		this.returnTypeName = returnTypeName;
		this.returnTypeNameLineNumber = returnTypeNameLineNumber;
		this.params = params;
		this.paramsLineNumber = paramsLineNumber;
		this.body = body;
		this.bodyLineNumber = bodyLineNumber;
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
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		/*******************/
		/* [0] return type */
		/*******************/
		returnType = SYMBOL_TABLE.getInstance().find(returnTypeName);
		if (returnType == null)
		{
			System.out.format(">> ERROR [%d] non existing return type %s\n",this.lineNumber,returnTypeName);
			throw new AST_EXCEPTION(returnTypeNameLineNumber);
		}

		// MAKE Sure there is no same function with same name in the current scope?
		TYPE temp = SYMBOL_TABLE.getInstance().findInCurrentScope(name);
		if (temp != null)
		{
			System.out.format(">> ERROR [%d] method `%s` already exists in scope, found `%s`\n",this.lineNumber,name, temp.name);
			throw new AST_EXCEPTION(nameLineNumber);
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
				throw new AST_EXCEPTION(it.lineNumber);
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

	public TEMP IRme() throws Exception
	{
		System.out.format("IRme - AST_DEC_FUNC(%s):%s\nScope=%d\n",name, returnTypeName, myScope);
		// public String returnTypeName;
		// public Integer returnTypeNameLineNumber;

		// public AST_TYPE_NAME_LIST params;
		// public Integer paramsLineNumber;

		// define void @foo(i32, i32) #0 {
		//   %3 = alloca i32, align 4
		//   %4 = alloca i32, align 4
		//   store i32 %0, i32* %3, align 4
		//   store i32 %1, i32* %4, align 4
		//   ret void
		// }

		String params_sent_string = "";
		String params_get_string = "";
		int counter = 0;

		// int bck_counter = TEMP_FACTORY.getInstance().counter;
		// TEMP_FACTORY.getInstance().counter = 0;
		TEMP_FACTORY.getInstance().beginScope(myScope+1);


		ArrayList<Integer> params_list = new ArrayList<Integer>();
		// SYMBOL_TABEL.getInstance().beginScope();
		// IR.getInstance().beginScope();
		for (AST_TYPE_NAME_LIST it = params; it  != null; it = it.tail) {
			if (it.head != null)  {
				String name = String.format("%s", it.head.name);
				String type = "i32";
				if (counter == 0) {
					params_get_string+=String.format("%s", type);
					params_sent_string+=String.format("%s %s", type, name);
				} else {
					params_get_string+=String.format(", %s", type);
					params_sent_string+=String.format(",  %s %s",  type, name);
				}

			}
			params_list.add(counter++);
			// counter++;
		}
		TYPE return_type = SYMBOL_TABLE.getInstance().find(returnTypeName);
		String return_type_str = AST_HELPERS.type_to_string(return_type);
		// check void
		// check pointer
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Decler_Func_Open(
				name,
				params_get_string,
				return_type_str,
				myScope
			));

			String return_label = TEMP_FACTORY.getInstance().create_shared_return_label();
			if (return_type_str != "void") {
				// Alloc for return value
				TEMP return_temp = TEMP_FACTORY.getInstance().create_shared_return_temp();
				IR.getInstance()
					.Add_IRcommand(new IRcommand_Allocate_Local(return_temp, "i32", "0", 4, myScope+1));
			}

		counter = 0;
		for (AST_TYPE_NAME_LIST it = params; it  != null; it = it.tail) {
			if (it.head == null)  { continue; }
			// TEMP_FACTORY.getInstance().getFreshTEMP();
			TEMP t = TEMP_FACTORY.getInstance()
				.fetchTempFromScope(it.head.name, myScope+1, true);

			// TEMP src = TEMP_FACTORY.getInstance().findVarRecursive(it.head.name, scope);

			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Local(t, "i32", "0", 4, myScope+1));
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Store_Func_Param(t, params_list.get(counter++)));

		}
		// Hack for propiatery main init

		TEMP tt = null;
		System.out.format("########## BEFORE IRme - AST_DEC_FUNC return temp = %s\n",tt);
		if (body != null) { tt = body.IRme(); };
		System.out.format("########## AFTER IRme - AST_DEC_FUNC return temp = %s\n",tt);
		//fetch typeeee
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Decler_Func_Close(tt, return_type_str, return_label));
		TEMP_FACTORY.getInstance().endScope(myScope);
		// IR.getInstance().endScope();
		// TEMP_FACTORY.getInstance().counter = bck_counter;

		return null;
	}


}
