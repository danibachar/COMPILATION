package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

import java.util.*;
import javafx.util.Pair;

public class AST_STMT_ASSIGN extends AST_STMT
{
	/***************/
	/*  var := exp */
	/***************/
	public AST_EXP_VAR var;
	public AST_EXP exp;

	/*******************/
	/*  CONSTRUCTOR(S) */
	/*******************/
	public AST_STMT_ASSIGN(AST_EXP_VAR var,AST_EXP exp, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// System.out.print("====================== stmt -> var ASSIGN exp SEMICOLON\n");

		this.lineNumber = lineNumber;
		this.var = var;
		this.exp = exp;
	}

	/*********************************************************/
	/* The printing message for an assign statement AST node */
	/*********************************************************/
	public void PrintMe()
	{
		/********************************************/
		/* AST NODE TYPE = AST ASSIGNMENT STATEMENT */
		/********************************************/
		// System.out.print("AST_STMT_ASSIGN\n");
		/***********************************/
		/* RECURSIVELY PRINT VAR + EXP ... */
		/***********************************/
		if (var != null) var.PrintMe();
		if (exp != null) exp.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"ASSIGN\nleft := right\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,exp.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		exp.name = var.name;

		TYPE t1 = null;
		TYPE t2 = null;

		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		if (var != null) {
			// System.out.format("SEMANTME - AST_STMT_ASSIGN before var\nlinenumber = %d\n", this.lineNumber);
			t1 = var.SemantMe();
			AST_HELPERS.isValidTypeAssignableFromExpression(t1, exp);
			return null;
			// System.out.format("SEMANTME - AST_STMT_ASSIGN var name = %s\nlinenumber = %d\n", t1.name,this.lineNumber);
		}
		if (exp != null) {
			// System.out.format("SEMANTME - AST_STMT_ASSIGN before exp\nlinenumber = %d\n", this.lineNumber);
			t2 = exp.SemantMe();
			// System.out.format("SEMANTME - AST_STMT_ASSIGN exp name = %s\nlinenumber = %d\n", t2.name,this.lineNumber);
		}
		// Maybe validate that types exists

		// allow class and array to get nil
		if (t1.isClass() && t2 == TYPE_NIL.getInstance()) {
			// System.out.format("SEMANTME - AST_STMT_ASSIGN allow class to be nil\nlinenumber = %d\n",this.lineNumber);
			return null;
		}
		if (t1.isArray() && t2 == TYPE_NIL.getInstance()) {
			// System.out.format("SEMANTME - AST_STMT_ASSIGN allow array to be nil\nlinenumber = %d\n",this.lineNumber);
			return null;
		}
		//Allow assignment for inheritance - oneway!
		if (t1.isClass() && t2.isClass())
		{
			TYPE_CLASS t1_cast = (TYPE_CLASS)t1;
			TYPE_CLASS t2_cast = (TYPE_CLASS)t2;
			if (t1_cast.isAssignableFrom(t2_cast)) {
				// System.out.format("SEMANTME - AST_STMT_ASSIGN allow class inheritance\nlinenumber = %d\n",this.lineNumber);
				return null;
			}
		}

		if (t1.isArray()) {
			TYPE_ARRAY tc = (TYPE_ARRAY)t1;
			// if (tc.isAssignableFrom(t2)) {
			// 	System.out.format("SEMANTME - (1)AST_STMT_ASSIGN allow array(%s) to be assigned with %s\nlinenumber = %d\n",tc,t2,this.lineNumber);
			// 	return null;
			// }
			// // Need to validate that the initValueType == tc.type
			// if (tc.type.getClass() == t2.getClass()) {
			// 	System.out.format("SEMANTME - (2)AST_STMT_ASSIGN allow array(%s) to be assigned with %s\nlinenumber = %d\n",tc.name,t2,this.lineNumber);
			// 	return null;
			// }

			if (t2.isClassVar()) {
				TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)t2;
				if (!tc.isAssignableFrom(testInitVlueType.t)) {
					System.out.format(">> 1 ERROR [%d] trying assign array(%s) with the value(%s) \n",this.lineNumber,t1, testInitVlueType.t);
					throw new AST_EXCEPTION(this.lineNumber);
				}
			} else if (exp.isNewArray()) {
				// Need to validate that the initValueType == tc.type
				if (t2 != tc.type) {
					System.out.format(">> 2 ERROR [%d] trying assign array(%s) with the value(%s) \n",this.lineNumber,t1, t2);
					throw new AST_EXCEPTION(this.lineNumber);
				}
			} else if (!tc.isAssignableFrom(t2)) {
				System.out.format(">> 3 ERROR [%d] trying assign array(%s) with the value(%s) \n",this.lineNumber,t1, t2);
				throw new AST_EXCEPTION(this.lineNumber);
			}
			return null;
			// System.out.format("SEMANTME - AST_STMT_ASSIGN allow array(%s) to be assigned with %s\nlinenumber = %d\n",t1_array,t2,this.lineNumber);
		}


		if (t1.getClass() == t2.getClass()) {
			// System.out.format("SEMANTME - AST_STMT_ASSIGN same var class\nlinenumber = %d\n",this.lineNumber);
			return null;
		}
		System.out.format(">> ERROR [%d] type mismatch for var(%s) := exp(%s)\n",this.lineNumber,t1,t2);
		throw new AST_EXCEPTION(this.lineNumber);
	}

	public TEMP IRme()  throws Exception
	{
		if (myScope == 0) {
			// Global Scope Assignemnts are handled else where - TODO
			return null;
		}

		System.out.format("IRme - AST_STMT_ASSIGN (%s) -> (%s), myType=(%s) ,Scope=%d\n",exp, var, myType, myScope);

		TYPE t = myType;
		String src_type = AST_HELPERS.type_to_string(t);
		int align = AST_HELPERS.type_to_align(t);

		TEMP src = exp.IRme();
		TEMP dst = var.IRme();
		// This is a hack, it is better to explicit about var vs temp!
		// if (src == null) {
		// 	String n = exp.name;
		// 	if (n == null) {
		// 			n = var.name;
		// 	}
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommand_Load_From_Var(dst, n, src_type, src_type+"*", align));
		// 		return null;
		// }
		// IR.getInstance()
		// 	.Add_IRcommand(new IRcommand_Load_From_Temp(dst, src, src_type, src_type+"*", align));

		return null;

		// if (var instanceof AST_EXP_VAR_SIMPLE) {
		//
		//
		// 	TEMP dst = TEMP_FACTORY.getInstance().getFreshTEMP();
		// 	TEMP src = TEMP_FACTORY.getInstance().findVarRecursive(name, myScope);
		// 	if (src == null) {
		// 		IR.getInstance()
		// 			.Add_IRcommand(new IRcommand_Load_From_Var(dst, name, src_type, src_type+"*", align));
		// 			return dst;
		// 	}
		// 	System.out.format("Load_From_Temp - name = %s, src_type = %s, align = %d\n",name,src_type,align);
		// 	IR.getInstance()
		// 		.Add_IRcommand(new IRcommand_Load_From_Temp(dst, src, src_type, src_type+"*", align));
		// 	return dst;
		//
		// 	// TEMP dst = TEMP_FACTORY.getInstance()
		// 	// 	.findVarRecursive(((AST_EXP_VAR_SIMPLE) var).name, myScope);
		// 	// if (dst == null) {
		// 	// 	// throw new AST_EXCEPTION(var.lineNumber);
		// 	// 	IR.getInstance()
		// 	// 		.Add_IRcommand(new IRcommand_Store_To_Var(((AST_EXP_VAR_SIMPLE) var).name, src, "i32", "i32*",4));
		// 	// 		return null;
		// 	// }
		// 	// IR.getInstance()
		// 	// 	.Add_IRcommand(new IRcommand_Store_To_Temp(dst, src, "i32", "i32*", 4));
		// } else if (var instanceof AST_EXP_VAR_FIELD) {
		//
		// } else if (var instanceof AST_EXP_VAR_SUBSCRIPT) {
		//
		// } else {
		// 	throw AST_EXCEPTION(this.lineNumber);
		// }
		// TEMP dst = var.IRme();
		// IR.getInstance()
		// 	.Add_IRcommand(new IRcommand_Store(((AST_EXP_VAR_SIMPLE) var).name, src, myScope));

		// return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_STMT_ASSIGN (%s) -> (%s), Scope=%d\n",exp, var, myScope);
		if (var != null) { var.Globalize(); }
		if (exp != null) { exp.Globalize(); }
		// AST_HELPERS.update_constants_if_needed(exp.name, exp);
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_STMT_ASSIGN (%s) -> (%s), Scope=%d\n",exp, var, myScope);
		if (var != null) { var.InitGlobals(); }
		if (exp != null) { exp.InitGlobals(); }
	}
}
