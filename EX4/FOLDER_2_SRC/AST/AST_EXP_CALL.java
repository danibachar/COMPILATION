package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import java.util.ArrayList;
import java.util.Collections;

public class AST_EXP_CALL extends AST_EXP
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String funcName;
	public AST_EXP_LIST params;
	public AST_EXP_VAR var;

	private ArrayList<TYPE> sent_input_params = new ArrayList<TYPE>();

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
		/*************************************************/
		/* AST NODE TYPE = AST NODE FUNCTION DECLARATION */
		/*************************************************/
		// System.out.format("AST_EXP_CALL(%s)\nWITH:\n",funcName);
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
		// System.out.format("SEMANTME - AST_EXP_CALL(%s)WITH:(%s):%s\n",funcName,var, var!=null ? var.name:null);
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// Validate params recursively
		TYPE_LIST paramsTypes = null;
		if (params != null) {
			paramsTypes = params.SemantMe();
		}

		if (var != null)
		{
			// If var is not null we need to validate it as well
			// For now the only case this is possible is if the var is a class
				TYPE_CLASS varClass = null;
				TYPE varType = var.SemantMe();
				if (varType == null) {
					System.out.format(">> ERROR [%d] calling function(%s) on var(%s):%s that is not a class\n",this.lineNumber,funcName, varType, var);
					throw new AST_EXCEPTION(this.lineNumber);
				}

				if (!varType.isClass()) {
					// Check maybe it is a field holding a class
					if (!varType.isClassVar()) {
						System.out.format(">> ERROR [%d] calling function(%s) on var(%s):%s that is not a class\n",this.lineNumber,funcName, varType, var);
						throw new AST_EXCEPTION(this.lineNumber);
					}

					TYPE_CLASS_VAR_DEC var_type_class = (TYPE_CLASS_VAR_DEC)varType;
					if (!var_type_class.t.isClass()) {
						System.out.format(">> ERROR [%d] calling function(%s) on var(%s):%s that is not a class\n",this.lineNumber,funcName, varType, var);
						throw new AST_EXCEPTION(this.lineNumber);
					}
					varClass = (TYPE_CLASS)var_type_class.t;
				} else {
					varClass = (TYPE_CLASS)varType;
				}


				//TODO = Make sure that the class holds the fields!!!
				TYPE_FUNCTION funcDec = varClass.queryMethodsReqursivly(funcName);
				if (funcDec == null) {
					System.out.format(">> (1) ERROR [%d] trying to call non existing function %s in class %s\n",this.lineNumber,funcName, varClass.name);
					throw new AST_EXCEPTION(this.lineNumber);
				}

				// Validate Params
				if (params != null)
				{
					// We should have params to check
					if (paramsTypes == null || !areParamsValid(funcDec.params, paramsTypes,false))
					{
						System.out.format(">> ERROR [%d] params mismatch for class(%s) function call -  %s\n",this.lineNumber, varClass.name, funcName);
						throw new AST_EXCEPTION(this.lineNumber);
					}

				}
				myType = funcDec.returnType;
				return funcDec.returnType;
		} else {
			// Global/Global in scope function call!!!

			// TODO - we need to check case where we call class function within the class

			// Validate that the funcName was already presented in any scope
			TYPE funcType = SYMBOL_TABLE.getInstance().find(funcName);
			if (funcType == null)
			{
				funcType = SYMBOL_TABLE.getInstance().findFunc(funcName,false);
				if (funcType == null) {
					System.out.format(">> (2) ERROR [%d] non existing function %s\n",this.lineNumber,funcName);
					throw new AST_EXCEPTION(this.lineNumber);
				}
				// if (funcType.isClassFunc()) {
				// 	TYPE_CLASS_FUNC_DEC funcTypeValidated = (TYPE_FUNCTION)funcType;
				// 	funcType = TYPE_FUNCTION(funcType.returnType, funcType.name, funcType.params);
				// }
			}
			// Validate that it is actually a funciton type, as we need to know its return type
			if (!(funcType instanceof TYPE_FUNCTION))
			{
				System.out.format(">> ERROR [%d] non Supported function type - critical!!! %s\n",this.lineNumber,funcName);
				throw new AST_EXCEPTION(this.lineNumber);
			}

			//Validate that the return type of the function exists
			TYPE_FUNCTION funcTypeValidated = (TYPE_FUNCTION)funcType;

			TYPE returnedType = SYMBOL_TABLE.getInstance().find(funcTypeValidated.returnType.name);
			if (returnedType == null)
			{
				System.out.format(">> ERROR [%d] function return type was not presented before calling the function - critical!!! %s\n",this.lineNumber,funcName);
				throw new AST_EXCEPTION(this.lineNumber);
			}

			// TODO - Validate Params!!!
			if (params != null)
			{
				if (funcTypeValidated.params == null) {
					System.out.format(">> ERROR [%d] params mismatch for global function call - %s ###\n",this.lineNumber,funcName);
					throw new AST_EXCEPTION(this.lineNumber);
				}
				// We should have params to check
				if (paramsTypes == null || !areParamsValid(funcTypeValidated.params, paramsTypes,true)) {
					System.out.format(">> ERROR [%d] params mismatch for global function call - %s 123\n",this.lineNumber,funcName);
					throw new AST_EXCEPTION(this.lineNumber);
				}

			}
			myType = funcTypeValidated.returnType;
			return funcTypeValidated.returnType;
		}

	}

	private boolean areParamsValid(TYPE_LIST original, TYPE_LIST sent, boolean reverse)
	{

		ArrayList<TYPE> expected_input_params = new ArrayList<TYPE>();
		sent_input_params.clear();

		for (TYPE_LIST it = original; it  != null; it = it.tail) {
			if (it.head != null)  {
					expected_input_params.add(it.head);
					// System.out.format("TYPE_LIST (%d) original value %s = %s\n",expected_input_params.size(), it.head.name, it.head);
			}

		}
		for (TYPE_LIST it = sent; it  != null; it = it.tail) {
			if (it.head != null)  {
				sent_input_params.add(it.head);
				// System.out.format("TYPE_LIST (%d) sent value %s = %s\n",sent_input_params.size(), it.head.name, it.head);
			}
		}

		if (expected_input_params.size() != sent_input_params.size()) {
			System.out.format("Validating Params Count mismatch %d =?? %d\n",expected_input_params.size(),sent_input_params.size());
			return false;
		}
		// Reverse for collection be the same
		if (reverse) {
				Collections.reverse(expected_input_params);
		}

		// System.out.format("expected_input_params = %s\n",expected_input_params);
		// System.out.format("sent_input_params = %s\n",sent_input_params);
		// System.out.format("reverse ? %s\n",reverse);
		for (int i = 0; i < expected_input_params.size(); i++) {

			TYPE expected = expected_input_params.get(i);
			TYPE send = sent_input_params.get(i);

			if (expected.isClassVar()) {
				// System.out.format("expected is class Var\n");
				TYPE_CLASS_VAR_DEC tmp = (TYPE_CLASS_VAR_DEC)expected;
				expected = tmp.t;
			}
			if (send.isClassVar()) {
				// System.out.format("send is class Var\n");
				TYPE_CLASS_VAR_DEC tmp = (TYPE_CLASS_VAR_DEC)send;
				send = tmp.t;
			}

			if (expected.isClass()) {
				TYPE_CLASS c = (TYPE_CLASS)expected;
				if (!c.isAssignableFrom(send)) {
					System.out.format("Validating Params for class mismatch \n");
					return false;
        }
			} else if (expected.isArray()) {
				TYPE_ARRAY a = (TYPE_ARRAY)expected;
				if (!a.isAssignableFrom(send)) {
					System.out.format("Validating Params for Array\n");
					return false;
				}
			} else if (expected != send) {
				System.out.format("Validating Params expected(%s:%s) not what is sent(%s:%s) mismatch \n", expected,expected.name, send,send.name);
				return false;
			}
		}

		return true;
	}

	public TEMP IRme() throws Exception
	{
		TEMP t=null;
		TEMP t_var=null;

		// if (var != null) { t_var = var.IRme(); } // No need to handle instance function
		// if (params != null) {  t = params.head.IRme();  }

		/*
		Calling function is a bit of a tricky issue we need to take care of 2 cases
		1) Global function call
		2) Instance function call - need to fetch this address - we will not handle such case - not required
		*/

		System.out.format("IRme - AST_EXP_CALL(%s)", funcName);
		System.out.format("IRme - ON:(%s)\n", t_var!=null ? t_var.getSerialNumber():null);
		System.out.format("IRme - WITH:(%s)\n",t!=null ? t.getSerialNumber():null);
		System.out.format("IRme - Scope=%d\n",myScope);
		TYPE_FUNCTION funcTypeValidated = (TYPE_FUNCTION)SYMBOL_TABLE.getInstance().find(funcName);
		String type_string = AST_HELPERS.type_to_string(funcTypeValidated.returnType);
		System.out.format("IRme - Return type = %s\n",type_string);


		/*
		 - load params
		 %3 = load i32, i32* %1, align 4
		 %4 = load i32, i32* %2, align 4
		 fileWriter.format("  %%Temp_%d = load i32, i32* @%s, align 4\n",idxdst, var_name);
		 if (params != null) {  t = params.head.IRme();  }
		*/
		String params_sent_string = "";
		int counter = 0;
		for (AST_EXP_LIST it = params; it  != null; it = it.tail) {
			if (it.head != null)  {

				TEMP temp_param = it.head.IRme();

				String name = String.format("%%Temp_%d", temp_param.getSerialNumber());
				//type temp_x
				String type = AST_HELPERS.type_to_string(sent_input_params.get(counter));
				if (counter == 0) {
					params_sent_string+=String.format("%s %s", type, name);
				} else {
					params_sent_string+=String.format(",  %s %s",  type, name);
				}
			}
			counter++;
		}

		TEMP tt = TEMP_FACTORY.getInstance().getFreshTEMP();
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Call_Func(funcName, params_sent_string, type_string, tt, myScope));

		return tt;
	}

}
