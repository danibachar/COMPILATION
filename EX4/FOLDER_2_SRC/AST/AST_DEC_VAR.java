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

		// Constant declarations
		if (initialValue != null && t == TYPE_STRING.getInstance()){
			AST_EXP_STRING e = (AST_EXP_STRING)initialValue;
			IR.getInstance()
				.Add_IRcommand(new IRcommandConstString(name, e.value));
				// name = name+".VAR1"
				Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
				IR.getInstance()
					.globalVarsInitCommands
					.add(p);

		} else {
			System.out.format("###### ONLY STRING IRme - VAR-DEC(%s):%s GLOBAL Scope=%d\n",name,type,myScope);
		}

		if (myScope == 0 ||  t == TYPE_STRING.getInstance()) {
			String type = AST_HELPERS.type_to_string(t);
			int align = AST_HELPERS.type_to_align(t);
			String type_val = AST_HELPERS.type_to_def_ret_val(t);
			// Alloc
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));
		}

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

		// if (t.isClass() || t.isArray()) {
		// 	type = "i32*";
		// 	type_val = "null";
		// 	align = 8;
		// }
		// if (t == TYPE_STRING.getInstance()) {
		// 	type = "i8*";
		// 	type_val = "null";
		// 	align = 8;
		// }

		/* Handling logic
			int:
			 handled,
			string:
				we need to create a global var with the value, just like for a regular global var,
				then we need to continue with the local var
				note we need to use the name to genarate 2 names!
				one for the global var that holds the value - copied from the const - remeber to handled
				and one for the local var - need to alloc!
			array:
			class:
		*/


		// If Global VAR
		if (myScope == 0) {
			// name = name+".VAR1"
			System.out.format("IRme - VAR-DEC(%s):%s GLOBAL Scope=%d\n",name,type,myScope);
			// Alloc
			// IR.getInstance()
			// 	.Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));

			// if (initialValue != null) {
			// 	// Add global function
			// 	Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, initialValue);
			// 	IR.getInstance()
			// 		.globalVarsInitCommands
			// 		.add(p);
			// 		// .add(new IRcommand_Store(name, initialValue.IRme(), myScope));
			// }
			return null;
		}
		// If Local Scope
		System.out.format("IRme - VAR-DEC(%s):%s LOCAL Scope=%d\n",name,type,myScope);
		// Find or alloc if needed
		TEMP tt = TEMP_FACTORY.getInstance().fetchTempFromScope(name, myScope, true);
		IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
		if (initialValue != null) {
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Store_To_Temp(tt, initialValue.IRme()));
		}

		return null;
	}


}
