package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import TEMP.*;
import IR.*;
import MIPS.*;
import AST_EXCEPTION.*;
import var_c.*;
import Pair.*;
import LLVM.*;
import java.util.*;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

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

	// Extra
	TYPE returnValType;
	boolean foundRet;
	TYPE_FUNCTION typeFunction;
	ArrayList<Pair<TYPE, Integer>> localVarInfo;

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

		this.foundRet = false;
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
			System.out.format(">> ERROR [%d] non existing return type %s\n",this.lineNumber,returnTypeName);
			throw new AST_EXCEPTION(returnTypeNameLineNumber);
		}
		this.returnValType = returnType;

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
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// For IRme
		var_c.getInstance().initiateCount();
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


		if (body != null) {
			for (AST_STMT_LIST it = body ; it != null ; it = it.tail)
			{
				if (it.head instanceof AST_STMT_RETURN)
				{
					((AST_STMT_RETURN)it.head).setReturnType(this.returnValType);
					this.foundRet = true;
				}
				else if (it.head instanceof AST_STMT_IF)
				{
					((AST_STMT_IF)it.head).update_return(this.returnValType);
				}
				else if (it.head instanceof AST_STMT_WHILE)
				{
					((AST_STMT_WHILE)it.head).update_return(this.returnValType);
				}
			}

			actualReturnType = body.SemantMe();
		}
		/*****************/
		/* [4] End Scope */
		/*****************/
		SYMBOL_TABLE.getInstance().endScope();

		// For IRme
		localVarInfo = new ArrayList<>();
		localVarInfo = var_c.getInstance().getLocalMap();
		/***************************************************/
		/* [5] Enter the Function Type to the Symbol Table */
		/***************************************************/
		SYMBOL_TABLE.getInstance().enter(name,f);
		myType = returnType;
		typeFunction = f;
		/*********************************************************/
		/* [6] Return value is irrelevant for class declarations */
		/*********************************************************/
		//TODO - validae if we need to return
		// return null;
		SYMBOL_TABLE.getInstance().current_function = null;
		return returnType;
	}

	public void initGlobals() throws Exception
	{
		IR.getInstance().
			Add_IRcommand(new IRcommand_Define_Func("init_globals", TYPE_VOID.getInstance(), null));
		for (Pair<String, AST_EXP> entry : LLVM.globals) {
			String key = entry.getKey();
			AST_EXP value = entry.getValue();
			TEMP tmp = value.IRme();
			if (tmp.isaddr) {
				TEMP expTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
				expTemp.setType(tmp.getType());
				expTemp.checkInit = tmp.checkInit;
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(expTemp, tmp));
				tmp = expTemp;
			}
			IR.getInstance().Add_IRcommand(new IRcommand_Store_Global(key,tmp));

		}
		IR.getInstance().Add_IRcommand(new IRcommand_Return(null));
		IR.getInstance().
			Add_IRcommand(new IRcommandEndFuncDef("init_globals", TYPE_VOID.getInstance(), null));
	}

	public TEMP IRme() throws Exception
	{
		// System.out.format("IRme - AST_DEC_FUNC(%s):%s, Scope=%d\n",name, returnTypeName, myScope);

		if (name.equals("main"))
		{
			initGlobals();
		}

		TYPE_LIST semantedArgs = null;
		String fullName = name;
		// todo - handke class fun name

		TYPE_LIST fullArgs = null;
		if (params != null) fullArgs = params.GetTypes();

		IR.getInstance().
			Add_IRcommand(new IRcommand_Define_Func(fullName, this.returnValType, fullArgs));

		AST_TYPE_NAME_LIST argList = null;
		// add the type of the class

		argList = this.params;

		TYPE_LIST semantedArgsIter = fullArgs;
		while(argList != null && argList.head != null){
			IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Param(argList.head.name, semantedArgsIter.head));
			argList = argList.tail;
			semantedArgsIter = semantedArgsIter.tail;
		}
		for (int i=0;i<localVarInfo.size();i++) {
			Pair<TYPE, Integer> info = localVarInfo.get(i);
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Local(info.getValue().toString(), info.getKey()));
		}

		argList = this.params;
		semantedArgsIter = fullArgs;
		int index = 0;
		while(argList != null && argList.head != null){
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Store_Parameter(
					argList.head.name, semantedArgsIter.head, index)
				);
			index++;
			argList = argList.tail;
			semantedArgsIter = semantedArgsIter.tail;
		}

		if (name.equals("main"))
		{
			IR.getInstance().
				Add_IRcommand(new IRcommand_Call_Func_Void("init_globals", TYPE_VOID.getInstance(), null, null));
		}

		if (body != null) body.IRme();

		if (!foundRet) {
			if (name.equals("main")) {
				IR.getInstance().Add_IRcommand(new IRcommand_Exit_Zero());
			}

			if (TYPE_VOID.getInstance() != returnValType) {
				IR.getInstance().Add_IRcommand(new IRcommand_DummyReturn(returnValType));
			} else {
				IR.getInstance().Add_IRcommand(new IRcommand_Return(null));
			}

		}

		IR.getInstance().
			Add_IRcommand(new IRcommandEndFuncDef(fullName, this.returnValType, fullArgs));
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_DEC_FUNC(%s):%s, Scope=%d\n",name, returnTypeName, myScope);
		if (body != null) body.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_DEC_FUNC(%s):%s, Scope=%d\n",name, returnTypeName, myScope);
		if (body != null) body.InitGlobals();
	}

}
