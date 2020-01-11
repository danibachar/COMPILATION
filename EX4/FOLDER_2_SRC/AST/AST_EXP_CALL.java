package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import LocalVarCounter.*;
import LLVM.*;
import java.util.ArrayList;
import javafx.util.Pair;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;
import java.util.Collections;

public class AST_EXP_CALL extends AST_EXP
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String funcName;
	public AST_EXP_LIST params;
	public AST_EXP_VAR var;

	public boolean shouldReveseParams;
	public TYPE_CLASS classType;
	public TYPE returnType;
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
					this.shouldReveseParams = false;
					if (paramsTypes == null || !areParamsValid(funcDec.params, paramsTypes,false))
					{
						System.out.format(">> ERROR [%d] params mismatch for class(%s) function call -  %s\n",this.lineNumber, varClass.name, funcName);
						throw new AST_EXCEPTION(this.lineNumber);
					}

				}
				myType = funcDec.returnType;
				this.classType = varClass;
				this.returnType = funcDec.returnType;
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
				this.shouldReveseParams = true;
				if (paramsTypes == null || !areParamsValid(funcTypeValidated.params, paramsTypes,true)) {
					System.out.format(">> ERROR [%d] params mismatch for global function call - %s 123\n",this.lineNumber,funcName);
					throw new AST_EXCEPTION(this.lineNumber);
				}

			}
			myType = funcTypeValidated.returnType;
			this.returnType = funcTypeValidated.returnType;
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

		// System.out.format("IRme - AST_EXP_CALL(%s)", funcName);
		// System.out.format("IRme - ON:(%s)\n", t_var!=null ? t_var.getSerialNumber():null);
		// System.out.format("IRme - WITH:(%s)\n",t!=null ? t.getSerialNumber():null);
		// System.out.format("IRme - Scope=%d\n",myScope);
		if (this.var == null) { // global or global in scope
			return IRmeScopeOrGlobalFunc();
		} else { // funciton call on field/class
			return IRmeVar();
		}
	}

	public TEMP IRmeVar() throws Exception {
		TYPE_FUNCTION functionType = (TYPE_FUNCTION)SYMBOL_TABLE.getInstance().find(funcName);
		TEMP varTemp = this.var.IRme();
		if (varTemp.isaddr)
		{
			TEMP arr1 = TEMP_FACTORY.getInstance().getFreshTEMP();
			arr1.setType(varTemp.getType());
			arr1.checkInit = varTemp.checkInit;
			IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(arr1, varTemp));
			varTemp = arr1;
		}
		IR.getInstance().Add_IRcommand(new IRcommand_Check_Null(varTemp));
		System.out.format("IRing method call with var %d\n", varTemp.getSerialNumber());
		TEMP_LIST t = new TEMP_LIST(varTemp, null);
		// AST_EXP_LIST params = args;
		if (params != null) {
			 t.tail = (TEMP_LIST)params.IRme();
		}

		TEMP_LIST temps=t;
		while (temps != null && params != null)
		{
			if (temps.head.isaddr){
				//ir return address and not value
				TEMP newtemp = TEMP_FACTORY.getInstance().getFreshTEMP();
				newtemp.setType(temps.head.getType());
				newtemp.checkInit = temps.head.checkInit;
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(newtemp, temps.head));
				temps.head = newtemp;
			}
			temps = temps.tail;
			params = params.tail;
		}
		System.out.format("Calling method with class %s and class %s\n", classType.name, ((TYPE_CLASS)varTemp.getType()).name);
		String fullName = classType.queryDataMembersReqursivly(name).typeClass.name + "_" + name;
		TYPE_LIST newParams = new TYPE_LIST(classType, functionType.params);
		if (functionType.returnType == TYPE_VOID.getInstance()){
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Call_Func_Void(fullName, functionType.returnType, t, newParams));
			return null;
		}

		TEMP dst = TEMP_FACTORY.getInstance().getFreshTEMP();
		dst.setType(functionType.returnType);
		IR.getInstance().Add_IRcommand(new IRcommand_Call_Func(dst, fullName, functionType.returnType, t, newParams));
		return dst;
	}

	public TEMP IRmeScopeOrGlobalFunc() throws Exception {
		TYPE_FUNCTION definedType = (TYPE_FUNCTION)SYMBOL_TABLE.getInstance().find(funcName);
		// TODO: simply call the function by name (what about name-colision?)
		String name = this.funcName;
		if (definedType.origClass != null)
		{
			name = definedType.origClass.name+"_" +  this.funcName;
		}
		System.out.format("IRing function call %s\n", name);
		TEMP_LIST t=null;
		// AST_EXP_LIST params = params;
		if (params != null) { t = (TEMP_LIST)params.IRme(); }
		if (params != null)
		{
			TEMP_LIST temps=t;
			TYPE_LIST types = definedType.params;

			while (temps != null && params != null)
			{

			if (temps.head.isaddr){
				// String llvmType1 = LLVM.getInstance().typeToString(temps.head.getType());
				// String llvmType2 = LLVM.getInstance().typeToString(types.head);
				// if (llvmType1.endsWith("*") && llvmType1.equals(llvmType2))
				// {
				// 	TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
				// 	pointerTemp.setType(temps.head.getType());
				// 	System.out.format("Creating pointerTemp of index %d %s\n", pointerTemp.getSerialNumber(), pointerTemp.getType());
				// 	IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_Pointer(pointerTemp, temps.head));
				// 	temps.head = pointerTemp;
				// }
				//ir return address and not value
				TEMP newtemp = TEMP_FACTORY.getInstance().getFreshTEMP();
				newtemp.setType(types.head);
				newtemp.checkInit = temps.head.checkInit;
				System.out.format("Loading in call func %s\n", newtemp.getSerialNumber());
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(newtemp, temps.head));
				temps.head = newtemp;
			}
			temps = temps.tail;
			params = params.tail;
			types = types.tail;
		}
		}

		if (returnType == TYPE_VOID.getInstance()){
			System.out.format("###### Calling method with named %s\n", funcName);
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Call_Func_Void(funcName, returnType, t, definedType.params));
			return null;
		}

		TEMP dst = TEMP_FACTORY.getInstance().getFreshTEMP();
		dst.setType(returnType);
		dst.isaddr = false;
		IR.getInstance().Add_IRcommand(new IRcommand_Call_Func(dst, name, returnType, t,definedType.params));
		return dst;
	}


	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_CALL(%s)", funcName);
		if (params != null) params.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_CALL(%s)", funcName);
		if (params != null) params.InitGlobals();
	}

}
