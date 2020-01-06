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
		initialValue.name = name;
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
		// String type = AST_HELPERS.type_to_string(t);
		// int align = AST_HELPERS.type_to_align(t);
		// String type_val = AST_HELPERS.type_to_def_ret_val(t);
		// if (myScope == 0) {
		// 	// Alloc
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));
		// 	if (initialValue != null) {
		//
		// 		Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
		// 		IR.getInstance()
		// 			.globalVarsInitCommands
		// 			.add(p);
		// 	}
		// }

		// if (t == TYPE_STRING.getInstance()) {
		// 	// TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		// 	if (initialValue != null) {
		// 		AST_HELPERS.update_constants_if_needed(name, initialValue);
				// AST_EXP_STRING e = (AST_EXP_STRING)initialValue;
				// // Adding to context - will be needed later
				// Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
				// IR.getInstance().constants.add(p);
				// // actual comamand
				// IR.getInstance()
				// 	.Add_IRcommand(new IRcommandConstString(name, e.value));
		// 	}
		//
		// } else if (t == TYPE_INT.getInstance()) {
		// 	if (myScope == 0) {
		// 		return null; //global handeled in sesmantme
		// 	}
		// 	TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
		// 	if (initialValue != null) {
		// 		System.out.format("2@@@@@initialValue\n");
		// 		IR.getInstance()
		// 			.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		// 	}
		//
		// } else if (t.isClass()) {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// } else if (t.isArray()) {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// } else if (t == TYPE_NIL.getInstance()) {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// } else if (t == TYPE_VOID.getInstance()) {
		// } else {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// 	// IR.getInstance()
		// 	// 	.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		// }
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
		myType = t;
		return t;
	}

	public TEMP IRme() throws Exception
	{

		if (initialValue != null) System.out.format("IRme - VAR-DEC(%s):%s := initialValue, Scope=%d\n",name,type,myScope);
		if (initialValue == null) System.out.format("IRme - VAR-DEC(%s):%s                , Scope=%d\n",name,type,myScope);
		if (myScope == 0) {
			// Global Scope Handled in SemantMe
			return null;
		}

		// Move this to separate class to hold the type logice over there
		String type = AST_HELPERS.type_to_string(myType);
		int align = AST_HELPERS.type_to_align(myType);
		String type_val = AST_HELPERS.type_to_def_ret_val(myType);
		// Allocate or fetches the temp
		TEMP dst = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		// Actually Memory allocation
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Allocate_Local(dst, type, type_val, align, myScope));
		// Handling the value
		if (initialValue != null) {
			TEMP src = initialValue.IRme();
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Store_To_Temp(dst, src, type, type+"*", align));
		}
		return null;
		//
		// if (t == TYPE_STRING.getInstance()) {
		// 	if (myScope == 0) {
		// 		System.out.format("@@@@@EARLY RETURN\n");
		// 		return null; //global handeled in sesmantme
		// 	}
		// 	TEMP dst = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommand_Allocate_Local(dst, type, type_val, align, myScope));
		// 	if (initialValue != null) {
		// 		AST_EXP_STRING e = (AST_EXP_STRING)initialValue;
		// 		TEMP src = e.IRme();
		// 		IR.getInstance()
		// 			.Add_IRcommand(new IRcommand_Store_To_Temp(dst, src, type, type+"*", align));
		// 		// IR.getInstance()
		// 		// 	.Add_IRcommand(new IRcommand_Store_String_Var_To_Temp(name+".VAR", tt, e.value, type, type+"*", align));
		// 	}
		//
		// } else if (t == TYPE_INT.getInstance()) {
		// 	if (myScope == 0) {
		// 		System.out.format("@@@@@EARLY RETURN\n");
		// 		return null; //global handeled in sesmantme
		// 	}
		// 	TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
		// 	if (initialValue != null) {
		// 		System.out.format("2@@@@@initialValue\n");
		// 		IR.getInstance()
		// 			.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		// 	}
		//
		// } else if (t.isClass()) {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// } else if (t.isArray()) {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// } else if (t == TYPE_NIL.getInstance()) {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// } else if (t == TYPE_VOID.getInstance()) {
		// } else {
		// 	throw new AST_EXCEPTION(this.lineNumber);
		// 	// IR.getInstance()
		// 	// 	.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme(), type, type+"*", align));
		// }

		// return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - VAR-DEC(%s):%s, Scope=%d\n",name,type,myScope);
		if (initialValue != null) { initialValue.Globalize(); }
		if (myScope > 0) {
			return;
		}
		// If the var is declared in scope=0 e.g Global we need to alloc according to class
		// support int, string, class, array
		String type = AST_HELPERS.type_to_string(myType);
		int align = AST_HELPERS.type_to_align(myType);
		String type_val = AST_HELPERS.type_to_def_ret_val(myType);
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - VAR-DEC(%s):%s, Scope=%d\n",name,type,myScope);
		if (initialValue != null) initialValue.InitGlobals();
	}

}
