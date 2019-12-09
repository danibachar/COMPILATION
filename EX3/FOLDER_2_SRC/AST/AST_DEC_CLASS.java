package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import java.util.ArrayList;

public class AST_DEC_CLASS extends AST_DEC
{
	/********/
	/* NAME */
	/********/
	// public String name;
	public String parent;
	public AST_DEC_CFIELDS body;
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_CLASS(String name,String parent,AST_DEC_CFIELDS body, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// if (parent != null) {
		// 	System.out.format("====================== classDec -> CLASS ID( %s ) EXTENDS( %s )\n", name, parent);
		// } else {
		// 	System.out.format("====================== classDec -> CLASS ID( %s ) \n", name);
		// }

		this.lineNumber = lineNumber;
		this.name = name;
		this.parent = parent;
		this.body = body;
	}

	/*********************************************************/
	/* The printing message for a class declaration AST node */
	/*********************************************************/
	public void PrintMe()
	{
		// System.out.format("AST_DEC_CLASS name = %s, parent = %s\n",name, parent);
		/*************************************/
		/* RECURSIVELY PRINT HEAD + TAIL ... */
		/*************************************/

		if (body != null) body.PrintMe();
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("CLASS\n%s",name));

		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,body.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		// System.out.format("SEMANTME - AST_DEC_CLASS name = %s, parent = %s\n",name, parent);
		/********************************************/
		/*Make sure we are at the most outer scope	*/
		/********************************************/
		if (SYMBOL_TABLE.getInstance().scopeCount > 0) {
			System.out.format(">> ERROR [%d] Class %s defined not in most outer scope\n",this.lineNumber,name);
			throw new AST_EXCEPTION(this);
		}
		/**************************************/
		/* Check That Name does NOT exist */
		/**************************************/
		if (SYMBOL_TABLE.getInstance().find(name) != null) {
			System.out.format(">> ERROR [%d] Class %s already exists\n",this.lineNumber,name);
			throw new AST_EXCEPTION(this);
		}

		/**************************************/
		/* Check That Extends previous defined class*/
		/**************************************/
		if (parent != null && SYMBOL_TABLE.getInstance().find(parent) == null)
		{
			System.out.format(">> ERROR [%d] Class %s Extends non existing Class %s\n",this.lineNumber,name, parent);
			throw new AST_EXCEPTION(this);
		}

		// Prepopulating the table for recursive definitions
		TYPE_CLASS father = null;
		if (parent != null) {
			father = (TYPE_CLASS)SYMBOL_TABLE.getInstance().find(parent);
		}

		/*************************/
		/* [1] Begin Class Scope */
		/*************************/
		SYMBOL_TABLE.getInstance().beginScope();


		/********************************************/
		/* Temp insertion for recursive reasons.		*/
		/* Will be cleared once the scope is closed */
		/********************************************/
		TYPE_CLASS t = new TYPE_CLASS(father, name, null, null);
		SYMBOL_TABLE.getInstance().enter(name,t);
		// Hack try fix
		SYMBOL_TABLE.getInstance().current_class = t;

		//First Iteration is to split func from var
		/**********************************************/
		/* First Iteration is to split func from vars */
		/**********************************************/
		ArrayList<AST_DEC_FUNC> func_decs = new ArrayList<AST_DEC_FUNC>();
		ArrayList<AST_DEC_VAR> var_decs = new ArrayList<AST_DEC_VAR>();
		for (AST_DEC_CFIELDS it=body;it != null;it=it.tail)
		{
				if (it.head == null) { continue; }
				if (it.head.isFuncDec()) {
					AST_DEC_FUNC f = (AST_DEC_FUNC)it.head;
					func_decs.add(f);
				} else if (it.head.isVarDec() ){
					AST_DEC_VAR v = (AST_DEC_VAR)it.head;
					var_decs.add(v);
				} else {
					System.out.format(">> ERROR [%d] Class %s has unknown data_member/method %s\n",this.lineNumber,it.head);
					throw new AST_EXCEPTION(this);
				}
		}
		/*************************/
		/* [3] Semant Vars first */
		/*************************/
		for (int i = 0; i < var_decs.size(); i++) {
			AST_DEC_VAR v = var_decs.get(i);
			// If we encounter none constant var dec, we throw.
			// We do that by checking its initValue var expression if it is constant
			// Constant expression is one of the following - Nil, String, Int
			if (v.initialValue != null && !v.initialValue.isConstExp()) {
				System.out.format(">> ERROR [%d] Class %s Extends %s has data_member that is initialized with no constant value %s \n",this.lineNumber,name, parent,v.initialValue);
				throw new AST_EXCEPTION(this);
			}
			TYPE_CLASS_VAR_DEC fd = new TYPE_CLASS_VAR_DEC(v.SemantMe(),v.name);
			t.data_members = new TYPE_CLASS_VAR_DEC_LIST(fd ,t.data_members);
			// Validating data memebers shadowing
			if (father != null) {
				for (TYPE_CLASS_VAR_DEC_LIST it2=father.data_members;it2 != null;it2=it2.tail) {
						if (it2.head != null) {
							// System.out.format("TYPE_CLASS_VAR_DEC_LIST compare it1.head.name = %s to it2.head.name = %s \n", fd.name, it2.head.name);
							// System.out.format("TYPE_CLASS_VAR_DEC_LIST compare it1.head.t = %s to it2.t = %s \n", fd.t, it2.head.t);
							// Inheritance does not allow shadowing vars
							if (fd.name.equals(it2.head.name)) {
								System.out.format(">> ERROR [%d] Class %s Extends %s and shadowing data memeber %s <-> %s\n",this.lineNumber,name, parent, fd.name, it2.head.name);
								throw new AST_EXCEPTION(v);
							}
						}
				}
			}
		}

		/*************************/
		/* [3] Semant Func later */
		/*************************/

		for (int i = 0; i < func_decs.size(); i++) {
			AST_DEC_FUNC f = func_decs.get(i);
			// Handling params
			TYPE_LIST p = null;
			if (f.params != null) { p = f.params.SemantMe(); }
			TYPE_CLASS_FUNC_DEC fd = new TYPE_CLASS_FUNC_DEC( null, f.name, p );
			t.methods = new TYPE_CLASS_FUNC_DEC_LIST(fd ,t.methods);
			fd.returnType = f.SemantMe();
			// Validate against each father
			if (father != null) {
				for (TYPE_CLASS_FUNC_DEC_LIST it2=father.methods;it2 != null;it2=it2.tail) {
						if (it2.head != null) {
							// System.out.format("TYPE_CLASS_FUNC_DEC_LIST compare it1.head.name = %s to it2.head.name = %s \n", fd.name, it2.head.name);
							// System.out.format("TYPE_CLASS_FUNC_DEC_LIST compare it1.head.returnType = %s to it2.returnType = %s \n", fd.returnType, it2.head.returnType);
							if (fd.name.equals(it2.head.name)) {
								// Must return the same type
								if (fd.returnType != it2.head.returnType) {
									System.out.format(">> ERROR [%d] Class %s Extends %s and overloading method with other return type (%s):%s <-> (%s):%s\n",this.lineNumber,name, parent, fd.name, fd.returnType, it2.head.name, it2.head.returnType);
									throw new AST_EXCEPTION(f);
								}

								// Must have the same kind params and count

								// Must have the same params order

							}
						}
				}
			}

		}


		/************************************************************/
		/* 										End Scope   												  */
		/* Note - this should clear the temp insertion of the class */
		/************************************************************/
		SYMBOL_TABLE.getInstance().endScope();
		/************************************************/
		/* [4] Enter the Class Type to the Symbol Table */
		/************************************************/
		SYMBOL_TABLE.getInstance().enter(name,t);

		/*********************************************************/
		/* [5] Return value is irrelevant for class declarations */
		/*********************************************************/
		SYMBOL_TABLE.getInstance().current_class = null;
		return null;
	}
}
