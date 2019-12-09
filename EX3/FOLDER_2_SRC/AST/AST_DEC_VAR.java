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
	// public String name;
	public AST_EXP initialValue;

	public boolean isVarDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_VAR(String type,String name,AST_EXP initialValue,Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.type = type;
		this.name = name;
		this.initialValue = initialValue;
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
			throw new AST_EXCEPTION(this);
		}

		/**************************************/
		/* [2] Check That Name does NOT exist */
		/**************************************/
		TYPE temp = SYMBOL_TABLE.getInstance().findInCurrentScope(name);
		if (temp != null)
		{
			System.out.format(">> ERROR [%d] variable `%s` already exists in scope, found `%s`\n",this.lineNumber,name, temp.name);
			throw new AST_EXCEPTION(this);
		}

		// validate that the initialValue is the same type as the var type, and that it exists!
		if (initialValue != null)
		{
			TYPE initValueType = initialValue.SemantMe();
			if (initValueType == null)
			{
				System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",this.lineNumber,name);
				throw new AST_EXCEPTION(this);
			}
			if (initValueType.getClass() != t.getClass())
			{
				// Allow nil into class and array
				boolean isArrayOrClass = t.isClass() || t.isArray();
				boolean isAssigningNil = initValueType == TYPE_NIL.getInstance();
				if (!isAssigningNil || !isArrayOrClass) {
					if (t.isArray()) {
							// we need to check  the initValueType is the type of the array
							TYPE_ARRAY ta = (TYPE_ARRAY)t;
							if (!ta.isAssignableFrom(initValueType)) {
								System.out.format(">> ERROR [%d] Array initialValue(%s), t(%s)\n",this.lineNumber,initValueType, ta.type);
								System.out.format(">> ERROR [%d] Array initialValue that assigned to the var(%s) is not the same type of the var\n",this.lineNumber,name);
							}
					} else {
						System.out.format(">> ERROR [%d] initialValue(%s), t(%s)\n",this.lineNumber,initValueType, t);
						System.out.format(">> ERROR [%d] initialValue that assigned to the var(%s) is not the same type of the var\n",this.lineNumber,name);
						throw new AST_EXCEPTION(this);
					}
				}
			}
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
