package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_BINOP extends AST_EXP
{
	int OP;

	public AST_EXP left;
	public Integer leftLineNumber;
	public AST_EXP right;
	public Integer rightLineNumber;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_BINOP(AST_EXP left, Integer leftLineNumber,AST_EXP right,Integer rightLineNumber, int OP)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();


		this.lineNumber = rightLineNumber;
		this.left = left;
		this.leftLineNumber = leftLineNumber;
		this.right = right;
		this.rightLineNumber = rightLineNumber;
		this.OP = OP;

		// System.out.format("====================== exp -> exp BINOP(%s) exp\n", opSymbol());
	}

	public String opSymbol()
	{
		String sOP="";

		/*********************************/
		/* CONVERT OP to a printable sOP */
		/*********************************/
		if (OP == 0) {sOP = "=";}
		if (OP == 1) {sOP = "<";}
		if (OP == 2) {sOP = ">";}
		if (OP == 3) {sOP = "+";}
		if (OP == 4) {sOP = "-";}
		if (OP == 5) {sOP = "*";}
		if (OP == 6) {sOP = "/";}

		return sOP;
	}

	/*************************************************/
	/* The printing message for a binop exp AST node */
	/*************************************************/
	public void PrintMe()
	{
		String sOP=opSymbol();
		/*************************************/
		/* AST NODE TYPE = AST SUBSCRIPT VAR */
		/*************************************/
		// System.out.format("AST_EXP_BINOP(%s)\n",opSymbol());
		/**************************************/
		/* RECURSIVELY PRINT left + right ... */
		/**************************************/
		if (left != null) left.PrintMe();
		if (right != null) right.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("BINOP(%s)",sOP));

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (left  != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,left.SerialNumber);
		if (right != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,right.SerialNumber);
	}
	public TYPE SemantMe() throws Exception
	{
		TYPE t1 = null;
		TYPE t2 = null;

		if (left  != null) t1 = left.SemantMe();
		if (right != null) t2 = right.SemantMe();

		// System.out.format("SEMANTME - AST_EXP_BINOP(%s) between t1=%s, t2=%s\n",opSymbol(), t1, t2);

		// Allow any kind of operation between 2 ints
		if ((t1 == TYPE_INT.getInstance()) && (t2 == TYPE_INT.getInstance())) {
			return TYPE_INT.getInstance();
		}

		// Check if we are using class var as it might have a different
		TYPE_CLASS_VAR_DEC t1_var = null;
		TYPE_CLASS_VAR_DEC t2_var = null;
		if (t1 != null && t1.isClassVar()) {
				t1_var = (TYPE_CLASS_VAR_DEC)t1;
		}
		if (t2 != null && t2.isClassVar()) {
				t2_var = (TYPE_CLASS_VAR_DEC)t2;
		}

		if (t1_var != null && t1_var.t != null) {
			 if (t1_var.t == TYPE_INT.getInstance() && t2 == TYPE_INT.getInstance()) {
				 return TYPE_INT.getInstance();
			 }
			 if (t1_var.t.isClass() || t1_var.t.isArray() && t2 == TYPE_NIL.getInstance()) {
				 return TYPE_INT.getInstance();
			 }
			 if (OP == 0) {
				 if (( t1_var.t == TYPE_STRING.getInstance()) && (t2 == TYPE_STRING.getInstance())) {
	 				return TYPE_INT.getInstance();
	 			}
			 }
			 if (OP == 3) {
				 if (( t1_var.t == TYPE_STRING.getInstance()) && (t2 == TYPE_STRING.getInstance())) {
	 				return TYPE_STRING.getInstance();
	 			}
			 }
		}

		if (t2_var != null && t2_var.t != null) {
			 if (t2_var.t == TYPE_INT.getInstance() && t1 == TYPE_INT.getInstance()) {
				 return TYPE_INT.getInstance();
			 }
			 if (t2_var.t.isClass() || t2_var.t.isArray() && t1 == TYPE_NIL.getInstance()) {
				 return TYPE_INT.getInstance();
			 }
			 if (OP == 0) {
				 if ((t2_var.t == TYPE_STRING.getInstance()) && (t1 == TYPE_STRING.getInstance())) {
	 				return TYPE_INT.getInstance();
	 			}
			 }
			 if (OP == 3) {
				 if (( t2_var.t == TYPE_STRING.getInstance()) && (t1 == TYPE_STRING.getInstance())) {
	 				return TYPE_STRING.getInstance();
	 			}
			 }
		}

		if (t1_var != null && t2_var != null) {
			if ((t2_var.t == TYPE_INT.getInstance()) && (t1_var.t == TYPE_INT.getInstance())) {
				return TYPE_INT.getInstance();
			}
			if (OP == 0) {
				if ((t2_var.t == TYPE_STRING.getInstance()) && (t1_var.t == TYPE_STRING.getInstance())) {
					return TYPE_INT.getInstance();
				}
				// Check class? and array
				// if (t1_var.t.isArray() && t2_var.t.isArray()) {
				// 	if (t1_var.t.equals(t2_var.t)) {
				// 		return TYPE_INT.getInstance();
				// 	}
				// }
				// Allow compare classes that extends each other
				if (t1_var.isClass() && t2_var.isClass()) {
					TYPE_CLASS castT1 = (TYPE_CLASS)t1;
					TYPE_CLASS castT2 = (TYPE_CLASS)t2;
					if (castT1.isAssignableFrom(castT2) || castT2.isAssignableFrom(castT1)) {
							return TYPE_INT.getInstance();
					}
				}
			}
		}

		// Equality Testing
		if (OP == 0) {
			// Allow Strings Comparing
			if ((t1 == TYPE_STRING.getInstance()) && (t2 == TYPE_STRING.getInstance())) {
				return TYPE_INT.getInstance();
			}
			// Allow compare nil to class
			if ((t1 != null && t1.isClass() && t2 == TYPE_NIL.getInstance()) || (t2 != null && t2.isClass() && t1 == TYPE_NIL.getInstance())) {
				return TYPE_INT.getInstance();
			}
			// Allow compare nil to array
			if ((t1 != null && t1.isArray() && t2 == TYPE_NIL.getInstance()) || (t2 != null && t2.isArray() && t1 == TYPE_NIL.getInstance())) {
				return TYPE_INT.getInstance();
			}
			// Allow compare 2 nils
			if ((t1 == TYPE_NIL.getInstance()) && (t2 == TYPE_NIL.getInstance())) {
				return TYPE_INT.getInstance();
			}
			// Allow compare classes that extends each other
			if (t1.isClass() && t2.isClass()) {
				TYPE_CLASS castT1 = (TYPE_CLASS)t1;
				TYPE_CLASS castT2 = (TYPE_CLASS)t2;
				if (castT1.isAssignableFrom(castT2) || castT2.isAssignableFrom(castT1)) {
						return TYPE_INT.getInstance();
				}
			}

		}

		// Plus Operation Testing
		if (OP == 3) {
			// Allow concatenation of strings
			if ((t1 == TYPE_STRING.getInstance()) && (t2 == TYPE_STRING.getInstance())) {
				return TYPE_STRING.getInstance();
			}

			// Allow
		}


		System.out.format(">> ERROR [%d] AST_EXP_BINOP(%s) Fail!!! t1(%s) != t2(%s)\n",this.lineNumber, opSymbol(),t1,t2);
		throw new AST_EXCEPTION(this.lineNumber);
	}

}
