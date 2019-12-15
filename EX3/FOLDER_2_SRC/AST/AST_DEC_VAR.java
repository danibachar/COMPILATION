package AST;

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
		if (initialValue != null)
		{
			AST_HELPERS.isValidTypeAssignableFromExpression(t, initialValue);
			// return;
			//
			// TYPE initValueType = initialValue.SemantMe();
			// // System.out.format("SEMANTME - VAR-DEC initValueType(%s)\n",initValueType);
			// if (initValueType == null) {
			// 	System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",this.lineNumber,name);
			// 	throw new AST_EXCEPTION(this);
			// }
			//
			//
			// // Allow Assignment for class nil or inheritance support
			// if (t.isClass()) {
			// 	TYPE_CLASS tc = (TYPE_CLASS)t;
			// 	if (initValueType.isClassVar()) {
			// 		TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)initValueType;
			// 		if (!tc.isAssignableFrom(testInitVlueType.t)) {
			// 			System.out.format(">> ERROR [%d] 1-trying assign class(%s) with the value(%s) \n",this.lineNumber,t, testInitVlueType.t);
			// 			throw new AST_EXCEPTION(this);
			// 		}
			// 	} else if (!tc.isAssignableFrom(initValueType)) {
			// 		System.out.format(">> ERROR [%d] 2-trying assign class(%s) with the value(%s) \n",this.lineNumber,t, initValueType);
			// 		throw new AST_EXCEPTION(this);
			// 	}
			// }
			// // Allow Assignment for array - nil or same array?
			// if (t.isArray()) {
			// 	TYPE_ARRAY tc = (TYPE_ARRAY)t;
			// 	if (initValueType.isClassVar()) {
			// 		TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)initValueType;
			// 		if (!tc.isAssignableFrom(testInitVlueType.t)) {
			// 			System.out.format(">> 1 ERROR [%d] trying assign array(%s) with the value(%s) \n",this.lineNumber,t, testInitVlueType.t);
			// 			throw new AST_EXCEPTION(this);
			// 		}
			// 	} else if (initialValue.isNewArray()) {
			// 		// Need to validate that the initValueType == tc.type
			// 		if (initValueType != tc.type) {
			// 			System.out.format(">> 2 ERROR [%d] trying assign array(%s) with the value(%s) \n",this.lineNumber,t, initValueType);
			// 			throw new AST_EXCEPTION(this);
			// 		}
			// 	} else if ( !tc.isAssignableFrom(initValueType)) {
			// 		System.out.format(">> 3 ERROR [%d] trying assign array(%s) with the value(%s) \n",this.lineNumber,t, initValueType);
			// 		throw new AST_EXCEPTION(this);
			// 	}
			// }
			//
			// if (t.isClassVar()) {
			// 	TYPE_CLASS_VAR_DEC tcv = (TYPE_CLASS_VAR_DEC)t;
			// 	// Allow Assignment for class nil or inheritance support
			// 	if (tcv.t.isClass()) {
			// 		TYPE_CLASS tc = (TYPE_CLASS)tcv.t;
			// 		if (initValueType.isClassVar()) {
			// 			TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)initValueType;
			// 			if (!tc.isAssignableFrom(testInitVlueType.t)) {
			// 				System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",this.lineNumber,t, testInitVlueType.t);
			// 				throw new AST_EXCEPTION(this);
			// 			}
			// 		} else if (!tc.isAssignableFrom(initValueType)) {
			// 			System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",this.lineNumber,t, initValueType);
			// 			throw new AST_EXCEPTION(this);
			// 		}
			// 	}
			// 	// Allow Assignment for array - nil or same array?
			// 	if (tcv.t.isArray()) {
			// 		TYPE_ARRAY tc = (TYPE_ARRAY)initValueType;
			// 		if (initValueType.isClassVar()) {
			// 			TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)initValueType;
			// 			if (!tc.isAssignableFrom(testInitVlueType.t)) {
			// 				System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",this.lineNumber,t, testInitVlueType.t);
			// 				throw new AST_EXCEPTION(this);
			// 			}
			// 		} else if (!tc.isAssignableFrom(initValueType)) {
			// 			System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",this.lineNumber,t, initValueType);
			// 			throw new AST_EXCEPTION(this);
			// 		}
			// 	}
			// }

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

}
