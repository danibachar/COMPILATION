package AST;

import IR.*;
import TEMP.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import java.util.ArrayList;

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
		// return null;
		return t;
	}

	public TEMP IRme() throws Exception
	{

		if (initialValue != null) System.out.format("IRme - VAR-DEC(%s):%s := initialValue\nScope=%d\n",name,type,myScope);
		if (initialValue == null) System.out.format("IRme - VAR-DEC(%s):%s                \nScope=%d\n",name,type,myScope);


		/*
		 Here we need to pay attention to the scope:
		 If we are in a global scope:
			- allocate global var
			- if initValue ?
				- we need to create private func
				- we need to apply store from within it
		Else we are in some scope -
			- allocate local var - use scope from symbole tyble
			- if initValue ?
				- we need to sttore
		*/
		TYPE t = SYMBOL_TABLE.getInstance().find(type);

		if (t.isClassVar()) {
			TYPE_CLASS_VAR_DEC tc = (TYPE_CLASS_VAR_DEC)t;
			t = tc.t;
		}

		String type = "i32";
		String type_val = "0";
		int align = 4;
		if (t.isClass() || t.isArray()) {
			type = "i32*";
			type_val = "null";
			align = 8;
		}
		if (t == TYPE_STRING.getInstance()) {
			type = "i8*";
			type_val = "null";
			align = 8;
		}


		if (myScope == 0) {
				IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Global(name, type, type_val, align, myScope));
		} else {
			TEMP tt = IR.getInstance().fetchTempFromScope(name, myScope, true);
			IR.getInstance().Add_IRcommand(new IRcommand_Allocate_Local(tt, type, type_val, align, myScope));
		}
		// IR.getInstance().Add_IRcommand(new IRcommand_Allocate(name, type, type_val, align, myScope));
		if (initialValue != null) {
			IR.getInstance().Add_IRcommand(new IRcommand_Store(name, initialValue.IRme(), myScope));
		}

		return null;
	}


}
