package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_VAR_FIELD extends AST_EXP_VAR
{
	public AST_EXP_VAR var;
	public String fieldName;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_VAR_FIELD(AST_EXP_VAR var,String fieldName, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		System.out.format("====================== var -> var DOT ID( %s )\n",fieldName);
		this.lineNumber = lineNumber;
		this.var = var;
		this.fieldName = fieldName;
	}

	/*************************************************/
	/* The printing message for a field var AST node */
	/*************************************************/
	public void PrintMe()
	{
		/*********************************/
		/* AST NODE TYPE = AST FIELD VAR */
		/*********************************/
		System.out.format("AST_EXP_VAR_FIELD\n(___.%s)\n",fieldName);
		/**********************************************/
		/* RECURSIVELY PRINT VAR, then FIELD NAME ... */
		/**********************************************/
		if (var != null) var.PrintMe();

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("FIELD\nVAR\n___.%s",fieldName));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (var  != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
	}
	public TYPE SemantMe() throws Exception
	{
		TYPE t = null;
		TYPE_CLASS tc = null;
		System.out.format("SEMANTME - AST_EXP_VAR_FIELD\n(___.%s)\n",fieldName);
		/******************************/
		/* [1] Recursively semant var */
		/******************************/
		if (var != null) t = var.SemantMe();

		/*********************************/
		/* [2] Make sure type is a class */
		/*********************************/
		if (t.isClass() == false)
		{
			System.out.format(">> ERROR [%d:%d] access %s field of a non-class variable\n",6,6,fieldName);
			throw new AST_EXCEPTION(this);
			// System.exit(0);
		}
		else
		{
			tc = (TYPE_CLASS) t;
		}

		/************************************/
		/* [3] Look for fiedlName inside tc */
		/************************************/
		System.out.format("Start Looking for supported fields names = %s in class =  %s\n",fieldName,tc.name);
		for (TYPE_CLASS_VAR_DEC_LIST it=tc.data_members;it != null;it=it.tail)
		{
			System.out.format("Looking for fieldlName head - %s \n",it.head);
			System.out.format("Looking for fieldlName tail - %s \n",it.tail);
			if (it.head != null)
			{
				if (it.head.name.equals(fieldName)) {
					System.out.format("Found Head Name %s  with type %s\n",it.head.name, it.head.t.name);
					return it.head.t;
				}
			}
		}

		/*********************************************/
		/* [4] fieldName does not exist in class var */
		/*********************************************/
		System.out.format(">> ERROR [%d] field %s does not exist in class\n",this.lineNumber,fieldName);
		throw new AST_EXCEPTION(this);
	}
}
