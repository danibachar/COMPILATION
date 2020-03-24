package AST;

import TYPES.*;
import TEMP.*;
import IR.*;
import MIPS.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

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

		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;

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
			if ((t1 == TYPE_STRING.getInstance()) && (t2 == TYPE_STRING.getInstance())) {
				return TYPE_STRING.getInstance();
			}
		}


		System.out.format(">> ERROR [%d] AST_EXP_BINOP(%s) Fail!!! t1(%s) != t2(%s)\n",this.lineNumber, opSymbol(),t1,t2);
		throw new AST_EXCEPTION(this.lineNumber);
	}

	public TEMP IRme() throws Exception
	{
		TEMP t1 = null;
		TEMP t2 = null;
		TEMP dst = TEMP_FACTORY.getInstance().getFreshTEMP();
		TEMP leftTemp = left.IRme();
		TEMP rightTemp = right.IRme();

		boolean shouldCastToInt = false;
		boolean shouldCheckOverflow = false;
			if (rightTemp!=null && rightTemp.isaddr)
			{
				t2 = TEMP_FACTORY.getInstance().getFreshTEMP();

				t2.setType(rightTemp.getType());
				t2.checkInit = rightTemp.checkInit;
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(t2, rightTemp));
			}
			if (leftTemp != null && leftTemp.isaddr){
				t1 = TEMP_FACTORY.getInstance().getFreshTEMP();
				t1.setType(leftTemp.getType());
				t1.checkInit = leftTemp.checkInit;

				IR.getInstance().Add_IRcommand(new IRcommand_Load_Temp(t1, leftTemp));
			}
		if (t1 == null)
		{
			t1 = leftTemp;
		}
		if (t2 == null)
		{
			t2 = rightTemp;
		}

		if (OP == 3)
		{
			if (t1.getType() instanceof TYPE_STRING)
			{
				dst.setType(TYPE_STRING.getInstance());
				IR.
				getInstance().
				Add_IRcommand(new IRcommand_Binop_Add_Strings(dst,t1,t2));
			}
			else{
				dst.setType(TYPE_INT.getInstance());
				IR.
				getInstance().
				Add_IRcommand(new IRcommand_Binop_Add_Integers(dst,t1,t2));
				shouldCheckOverflow = true;

			}
		}

				if (OP == 2)
				{
					shouldCastToInt = true;
					IR.
					getInstance().
					Add_IRcommand(new IRcommand_Binop_LT_Integers(dst,t2,t1));
				}

		if (OP == 1)
		{
			shouldCastToInt = true;
			IR.
			getInstance().
			Add_IRcommand(new IRcommand_Binop_LT_Integers(dst,t1,t2));
		}


		if (OP == 0)
		{
			shouldCastToInt = true;
			boolean oneIsNull = false;
			if (t1.getType() instanceof TYPE_NIL)
			{
				TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
			pointerTemp.setType(t2.getType());
			pointerTemp.checkInit = t2.checkInit;
			IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_To_Null(pointerTemp, t2));
			t2 = pointerTemp;
			oneIsNull = true;
			}
			if (t2.getType() instanceof TYPE_NIL)
			{
				TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
			pointerTemp.setType(t1.getType());
			pointerTemp.checkInit = t1.checkInit;
			IR.getInstance().Add_IRcommand(new IRcommand_Bitcast_To_Null(pointerTemp, t1));
			t1 = pointerTemp;
			oneIsNull = true;
			}
			if (oneIsNull)
			{
				t1.setType(TYPE_NIL.getInstance());
				t2.setType(TYPE_NIL.getInstance());
			}
			if (!oneIsNull &&  (t1.getType() instanceof TYPE_STRING || t2.getType() instanceof TYPE_STRING))
			{
				IR.
				getInstance().
				Add_IRcommand(new IRcommand_Binop_EQ_Strings(dst,t1,t2));
			}
			else
			{
				IR.
				getInstance().
				Add_IRcommand(new IRcommand_Binop_EQ_Integers(dst,t1,t2));
			}

		}
		if (OP == 4)
		{
			dst.setType(TYPE_INT.getInstance());
				IR.
				getInstance().
				Add_IRcommand(new IRcommand_Binop_Dec_Integers(dst,t1,t2));
			shouldCheckOverflow = true;
		}
		if (OP == 5)
		{
			dst.setType(TYPE_INT.getInstance());

			IR.
			getInstance().
			Add_IRcommand(new IRcommand_Binop_Mul_Integers(dst,t1,t2));
			shouldCheckOverflow = true;
		}
		if (OP == 6)
		{
			dst.setType(TYPE_INT.getInstance());

			IR.
			getInstance().
			Add_IRcommand(new IRcommand_Binop_Div_Integers(dst,t1,t2));
			shouldCheckOverflow = true;
		}
		if (shouldCastToInt)
		{
			t2 = TEMP_FACTORY.getInstance().getFreshTEMP();
			t2.setType(TYPE_INT.getInstance());
			IR.
			getInstance().
			Add_IRcommand(new IRcommand_Zext(t2,dst));
			dst = t2;
		}

		return dst;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_BINOP(%s)\n",opSymbol());
		if (right != null) right.Globalize();
		if (left != null) left.Globalize();
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_BINOP(%s)\n",opSymbol());
		if (right != null) right.InitGlobals();
		if (left != null) left.InitGlobals();
	}
}
