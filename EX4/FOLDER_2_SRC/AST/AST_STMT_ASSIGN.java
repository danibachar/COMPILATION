package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import java.util.*;

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
		// exp.name = var.name;

		TYPE t1 = null;
		TYPE t2 = null;

		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		if (var != null) {
			// System.out.format("SEMANTME - AST_STMT_ASSIGN exp.name = %s\n", exp.name);
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
		return IRmePrimitive();
		// if (exp instanceof AST_EXP_NEW) {
		// 	return IRmeClassOrArray();
		// } else {
		// 	return IRmePrimitive();
		// }
	}

	public TEMP IRmeClassOrArray()  throws Exception {
		return null;
	}

	public TEMP IRmePrimitive()  throws Exception {
		if (var instanceof AST_EXP_VAR_SIMPLE) {
			TEMP src = exp.IRme();

			if (src.isaddr){
				//ir return address and not value
				TEMP expTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
				expTemp.setType(src.getType());
				expTemp.checkInit = src.checkInit;
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(expTemp, src));
				src = expTemp;
			}
			AST_EXP_VAR_SIMPLE simpleVar = (AST_EXP_VAR_SIMPLE)var;
			if (simpleVar.isInFunc){
				if (((AST_EXP_VAR_SIMPLE) var).varIndex > -1)
				{
					if (src.getType() instanceof TYPE_NIL)
					{
						TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
						pointerTemp.setType(src.getType());
						IR.getInstance()
							.Add_IRcommand(new IRcommand_Bitcast_local(pointerTemp,((AST_EXP_VAR_SIMPLE) var).varIndex,((AST_EXP_VAR_SIMPLE) var).myType));
						IR.getInstance()
							.Add_IRcommand(new IRcommand_Store_Temp(pointerTemp,src));
					} else {
						IR.getInstance()
							.Add_IRcommand(new IRcommand_Store_Local(((AST_EXP_VAR_SIMPLE) var).varIndex,src));
					}
				} else {
					IR.getInstance()
						.Add_IRcommand(new IRcommand_Store_Param(((AST_EXP_VAR_SIMPLE) var).name,src));
				}

				return null;
			} else if (simpleVar.typeClass == null || simpleVar.typeClass.queryDataMembersReqursivly(((AST_EXP_VAR_SIMPLE) var).name) == null)
			{
				IR.getInstance().
					Add_IRcommand(new IRcommand_Store_Global(((AST_EXP_VAR_SIMPLE) var).name,src));
				return null;
			}
		}

		TEMP dst = var.IRme();
		TEMP src = exp.IRme();
		if (src.getType() instanceof TYPE_NIL)
		{
			TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
			pointerTemp.setType(src.getType());
			pointerTemp.checkInit = dst.checkInit;
			IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_Pointer(pointerTemp, dst));
			dst = pointerTemp;
		}
		else if (src.isaddr){
			TEMP expTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
			expTemp.setType(src.getType());
			expTemp.checkInit = src.checkInit;
			IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(expTemp, src));
			src = expTemp;
		}
		IR.getInstance().
			Add_IRcommand(new IRcommand_Store_Temp(dst,src));

		return null;
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
