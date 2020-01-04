package AST;

import IR.*;
import TEMP.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import java.util.*;
import javafx.util.Pair;

public class AST_DEC_VAR extends AST_DEC
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public String type;
	public Integer typeLineNumber;
	public AST_EXP initialValue;
	public Integer initialValueLineNumber;

	/************************************************/
	/* PRIMITIVE AD-HOC COUNTER FOR LOCAL VARIABLES */
	/************************************************/
	public static int localVariablesCounter = 0;


	public boolean isVarDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_VAR(
		String type,
		Integer typeLineNumber,
		String name,
		Integer nameLineNumber,
		AST_EXP initialValue,
		Integer initialValueLineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.name = name;
		this.nameLineNumber = nameLineNumber;

		this.type = type;
		this.typeLineNumber = typeLineNumber;
		this.initialValue = initialValue;
		this.initialValueLineNumber = initialValueLineNumber;
	}

	/********************************************************/
	/* The printing message for a declaration list AST node */
	/********************************************************/
	public void PrintMe()
	{
		/********************************/
		/* AST NODE TYPE = AST DEC LIST */
		/********************************/
		// if (initialValue != null) System.out.format("VAR-DEC(%s):%s := initialValue\n",name,type);
		// if (initialValue == null) System.out.format("VAR-DEC(%s):%s                \n",name,type);
		/**************************************/
		/* RECURSIVELY PRINT initialValue ... */
		/**************************************/
		if (initialValue != null)
		{
			initialValue.PrintMe();
		}

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("VAR\nDEC(%s)\n:%s",name,type));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (initialValue != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,initialValue.SerialNumber);

	}

	public TYPE SemantMe() throws Exception
	{
		TYPE t;
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;

		// if (initialValue != null) System.out.format("SEMANTME - VAR-DEC(%s):%s := initialValue\n",name,type);
		// if (initialValue == null) System.out.format("SEMANTME - VAR-DEC(%s):%s                \n",name,type);
		/****************************/
		/* [1] Check If Type exists */
		/****************************/

		t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null)
		{
			// if type is class we check if there was a previous TYPE_CLASS_VAR_DEC
			System.out.format(">> ERROR [%d] non existing type %s\n",this.lineNumber,type);
			throw new AST_EXCEPTION(typeLineNumber);
		}

		/**************************************/
		/* [2] Check That Name does NOT exist */
		/**************************************/
		TYPE temp = SYMBOL_TABLE.getInstance().findInCurrentScope(name);
		if (temp != null)
		{
			System.out.format(">> ERROR [%d] variable `%s` already exists in scope, found `%s`\n",this.lineNumber,name, temp.name);
			throw new AST_EXCEPTION(nameLineNumber);
		}

		// validate that the initialValue is the same type as the var type, and that it exists!
		if (initialValue != null) {
			AST_HELPERS.isValidTypeAssignableFromExpression(t, initialValue);
		}
		/***************************************************/
		/* [3] Enter the Function Type to the Symbol Table */
		/***************************************************/
		SYMBOL_TABLE.getInstance().enter(name,t);

		/*********************************************************/
		/* [4] Return value is irrelevant for class declarations */
		/*********************************************************/
		String type = AST_HELPERS.type_to_string(t);
		int align = AST_HELPERS.type_to_align(t);
		String type_val = AST_HELPERS.type_to_def_ret_val(t);
		if (myScope == 0) {
			// Alloc
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));
			if (initialValue != null) {
				Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
				IR.getInstance()
					.globalVarsInitCommands
					.add(p);
			}
		}

		if (t == TYPE_STRING.getInstance()) {
			// TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
			if (initialValue != null) {
				AST_EXP_STRING e = (AST_EXP_STRING)initialValue;
				IR.getInstance()
					.Add_IRcommand(new IRcommandConstString(name, e.value));
			}

		} else if (t == TYPE_INT.getInstance()) {
			if (myScope == 0) {
				System.out.format("@@@@@EARLY RETURN\n");
				return null; //global handeled in sesmantme
			}
			TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
			if (initialValue != null) {
				System.out.format("2@@@@@initialValue\n");
				IR.getInstance()
					.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
			}

		} else if (t.isClass()) {
			throw new AST_EXCEPTION(this.lineNumber);
		} else if (t.isArray()) {
			throw new AST_EXCEPTION(this.lineNumber);
		} else if (t == TYPE_NIL.getInstance()) {
			throw new AST_EXCEPTION(this.lineNumber);
		} else if (t == TYPE_VOID.getInstance()) {
		} else {
			throw new AST_EXCEPTION(this.lineNumber);
			// IR.getInstance()
			// 	.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		}
		// Constant declarations
		// if (initialValue != null && t == TYPE_STRING.getInstance()){
		// 	AST_EXP_STRING e = (AST_EXP_STRING)initialValue;
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommandConstString(name, e.value));
		// 		// name = name+".VAR1"
		// 		if (myScope == 0) {
		// 			Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
		// 			IR.getInstance()
		// 				.globalVarsInitCommands
		// 				.add(p);
		// 		}
		//
		//
		// } else {
		// 	System.out.format("###### ONLY STRING IRme - VAR-DEC(%s):%s GLOBAL Scope=%d\n",name,type,myScope);
		// }



		// return null;
		return t;
	}

	public TEMP IRme() throws Exception
	{

		if (initialValue != null) System.out.format("IRme - VAR-DEC(%s):%s := initialValue\nScope=%d\n",name,type,myScope);
		if (initialValue == null) System.out.format("IRme - VAR-DEC(%s):%s                \nScope=%d\n",name,type,myScope);

		// Move this to separate class to hold the type logice over there
		TYPE t = SYMBOL_TABLE.getInstance().find(type);

		if (t.isClassVar()) {
			TYPE_CLASS_VAR_DEC tc = (TYPE_CLASS_VAR_DEC)t;
			t = tc.t;
		}

		String type = AST_HELPERS.type_to_string(t);
		int align = AST_HELPERS.type_to_align(t);
		String type_val = AST_HELPERS.type_to_def_ret_val(t);

		/* Handling logic
			int:
				if global:
					alloc global - outside here in semant me - hack
					if have value:
						init in global vars init function - outside here in semant me - hack
					else:
						nothing?
				if local:
					alloc local - %Temp_0 = alloca i32, align 4
					if have value:
						create new temp to store the value in
						IRcommand_Store_To_Temp
					else:
						nothing?

			string:
				create const with var name - outside here in semant me - hack
				if global:
					alloc global - outside here in semant me - hack
					if have value:
						init in global vars init function - outside here in semant me - hack
					else:
						nothing?
				if local:
					alloc local - %Temp_0 = alloca i8*, align 8
					if have value:
						store from global const - store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.VAR, i32 0, i32 0), i8** %Temp_0, align 8
					else:
						nothing?
			array:

			class:

			nil:

			void:
		*/

		if (t == TYPE_STRING.getInstance()) {
			if (myScope == 0) {
				System.out.format("@@@@@EARLY RETURN\n");
				return null; //global handeled in sesmantme
			}
			TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
			if (initialValue != null) {
				AST_EXP_STRING e = (AST_EXP_STRING)initialValue;
				IR.getInstance()
					.Add_IRcommand(new IRcommand_Store_To_Var_String(name+".VAR", tt, e.value, type, type+"*", align));
			}

		} else if (t == TYPE_INT.getInstance()) {
			if (myScope == 0) {
				System.out.format("@@@@@EARLY RETURN\n");
				return null; //global handeled in sesmantme
			}
			TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
			if (initialValue != null) {
				System.out.format("2@@@@@initialValue\n");
				IR.getInstance()
					.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
			}

		} else if (t.isClass()) {
			throw new AST_EXCEPTION(this.lineNumber);
		} else if (t.isArray()) {
			throw new AST_EXCEPTION(this.lineNumber);
		} else if (t == TYPE_NIL.getInstance()) {
			throw new AST_EXCEPTION(this.lineNumber);
		} else if (t == TYPE_VOID.getInstance()) {
		} else {
			throw new AST_EXCEPTION(this.lineNumber);
			// IR.getInstance()
			// 	.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		}

		return null;

		//
		//
		// // If Global VAR
		// if (myScope == 0) {
		// 	// name = name+".VAR1"
		// 	System.out.format("IRme - VAR-DEC(%s):%s GLOBAL Scope=%d\n",name,type,myScope);
		// 	// Alloc
		// 	// IR.getInstance()
		// 	// 	.Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));
		//
		// 	// if (initialValue != null) {
		// 	// 	// Add global function
		// 	// 	Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
		// 	// 	IR.getInstance()
		// 	// 		.globalVarsInitCommands
		// 	// 		.add(p);
		// 	// 		// .add(new IRcommand_Store(name, initialValue.IRme(), myScope));
		// 	// }
		// 	return null;
		// }
		// // If Local Scope
		// System.out.format("IRme - VAR-DEC(%s):%s LOCAL Scope=%d\n",name,type,myScope);
		// // Find or alloc if needed
		// TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		//
		// IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
		// if (initialValue != null) {
		// 	System.out.format("IRme - VAR-DEC(%s)\n",t);
		// 	if (t == TYPE_STRING.getInstance()) {
		// 		System.out.format("IRme - VAR-DEC(%s)\n","TYPE_STRING");
		// 		IR.getInstance()
		// 			.Add_IRcommand(new IRcommand_Store_To_Var(name, tt, type, type+"*", align));
		// 	} else if (t.isClass()) {
		// 		throw new AST_EXCEPTION(this.lineNumber);
		// 	} else if (t.isArray()) {
		// 		throw new AST_EXCEPTION(this.lineNumber);
		// 	} else if (t == TYPE_NIL.getInstance()) {
		// 		throw new AST_EXCEPTION(this.lineNumber);
		// 	} else if (t == TYPE_VOID.getInstance()) {
		// 	} else {
		// 		IR.getInstance()
		// 			.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		// 	}
		//
		// }
		//
		// return null;
	}


}
