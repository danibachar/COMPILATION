package AST;

import TEMP.*;
import IR.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import java.util.ArrayList;

public class AST_DEC_CLASS extends AST_DEC
{
	/********/
	/* NAME */
	/********/
	public String parent;
	public Integer parentLineNumber;
	public AST_DEC_CFIELDS body;
	public Integer bodyLineNumber;


	public boolean isClassDec() { return true;}
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_CLASS(
		String name,
		Integer nameLineNumber,
		String parent,
		Integer parentLineNumber,
		AST_DEC_CFIELDS body,
		Integer bodyLineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// if (parent != null) {
		// 	System.out.format("====================== classDec[%d,%d,%d] -> CLASS ID( %s ) EXTENDS( %s )\n",nameLineNumber, parentLineNumber ,bodyLineNumber, name, parent);
		// } else {
		// 	System.out.format("====================== classDec[%d,%d,%d] -> CLASS ID( %s ) \n", nameLineNumber, parentLineNumber ,bodyLineNumber, name);
		// }

		this.name = name;
		this.nameLineNumber = nameLineNumber;
		this.parent = parent;
		this.parentLineNumber = parentLineNumber;
		this.body = body;
		this.bodyLineNumber = bodyLineNumber;
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
			throw new AST_EXCEPTION(nameLineNumber);
		}
		/**************************************/
		/* Check That Name does NOT exist */
		/**************************************/
		if (SYMBOL_TABLE.getInstance().find(name) != null) {
			System.out.format(">> ERROR [%d] Class %s already exists\n",this.lineNumber,name);
			throw new AST_EXCEPTION(nameLineNumber);
		}

		/**************************************/
		/* Check That Extends previous defined class*/
		/**************************************/
		if (parent != null && SYMBOL_TABLE.getInstance().find(parent) == null)
		{
			System.out.format(">> ERROR [%d] Class %s Extends non existing Class %s\n",this.lineNumber,name, parent);
			throw new AST_EXCEPTION(parentLineNumber);
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
					throw new AST_EXCEPTION(it.head.nameLineNumber);
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
				throw new AST_EXCEPTION(v.initialValueLineNumber);
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
								throw new AST_EXCEPTION(v.nameLineNumber);
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
			TYPE_FUNCTION fd = new TYPE_FUNCTION( null, f.name, p );
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
									throw new AST_EXCEPTION(f.returnTypeNameLineNumber);
								}

								// Must have the same kind params and count

								// throw new AST_EXCEPTION(f.paramsLineNumber);

								// Must have the same params order

								// throw new AST_EXCEPTION(f.bodyLineNumber); - we dont care

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

	// public TEMP IRme() {
	// 	// context.loadClass(representingType);
  //       // int size = context.sizeOf(representingType);
	// 			//
  //       // IRLabel constructorLabel = context.constructorOf(representingType);
  //       // context.openScope(constructorLabel.toString(), Collections.emptyList(), IRContext.ScopeType.Function, false, false);
	// 			//
  //       // context.label(constructorLabel);
  //       // context.command(new IRFunctionInfo(constructorLabel.toString(),0, 0));
  //       // Register allocationSize = context.newRegister();
  //       // context.command(new IRConstCommand(allocationSize, size));
  //       // Register thisReg = context.malloc(allocationSize);
  //       // context.assignVirtualTable(thisReg, representingType);
	// 			//
  //       // Register temp = context.newRegister();
	// 			//
  //       // callInternalConstructor(representingType, context, thisReg, temp);
	//
	//
  //       // return instance
  //       // context.command(new IRSetValueCommand(ReturnRegister.instance, thisReg));
  //       // context.label(context.returnLabelForConstructor(representingType));
  //       // context.command(new IRReturnCommand());
	// 			//
  //       // context.closeScope();
	// 			//
  //       // context.openObjectScope(representingType);
	//
  //       // now, internal constructor
  //       // IRLabel internalLabel = context.internalConstructorOf(representingType);
  //       // context.label(internalLabel);
  //       // context.command(new IRFunctionInfo(internalLabel.toString(), 1, 0));
  //       // context.openScope(internalLabel.toString(), Collections.emptyList(), IRContext.ScopeType.Function, false, false);
	// 			//
  //       // for (AST_DEC field : fields) {
  //       //     if (field instanceof AST_DEC_VAR) {
  //       //         field.irMe(context);
  //       //     }
  //       // }
  //       // context.label(context.returnLabelForInternalConstructor(representingType));
  //       // context.command(new IRReturnCommand());
  //       // context.closeScope();
	//
  //       // now, class body
  //       // for (AST_DEC field : fields) {
  //       //     if (!(field instanceof AST_DEC_VAR)) {
  //       //         field.irMe(context);
  //       //     }
  //       // }
	//
  //       // context.closeObjectScope();
	// 			return null;
  //       // return NonExistsRegister.instance;
	// }
}
