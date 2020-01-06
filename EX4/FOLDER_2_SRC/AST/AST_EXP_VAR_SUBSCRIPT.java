package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_VAR_SUBSCRIPT extends AST_EXP_VAR
{
	public AST_EXP_VAR var;
	public AST_EXP subscript;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_VAR_SUBSCRIPT(AST_EXP_VAR var,AST_EXP subscript, Integer lineNumber)
	{
		// System.out.print("====================== var -> var [ exp ]\n");
		this.lineNumber	= lineNumber;
		this.var = var;
		this.subscript = subscript;
	}

	/*****************************************************/
	/* The printing message for a subscript var AST node */
	/*****************************************************/
	public void PrintMe()
	{
		/*************************************/
		/* AST NODE TYPE = AST SUBSCRIPT VAR */
		/*************************************/
		// System.out.print("AST_EXP_VAR_SUBSCRIPT\n");
		/****************************************/
		/* RECURSIVELY PRINT VAR + SUBSRIPT ... */
		/****************************************/
		if (var != null) var.PrintMe();
		if (subscript != null) subscript.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"SUBSCRIPT\nVAR\n...[...]");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (var       != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,var.SerialNumber);
		if (subscript != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,subscript.SerialNumber);
	}

	public TYPE SemantMe() throws Exception
	{
		TYPE varType = null;
		TYPE subscriptType = null;
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.print("SEMANTME - AST_EXP_VAR_SUBSCRIPT\n");

		// Validate that the subscript is kind of int AST_EXP
		if (subscript != null)
		{
				subscriptType = subscript.SemantMe();
				if (subscriptType == null || (subscriptType != TYPE_INT.getInstance()) )
				{
					System.out.format(">> ERROR [%d] Trying access var subscript with non-integral index = %s\n",this.lineNumber, subscriptType);
					throw new AST_EXCEPTION(this.lineNumber);
				}
		}

		// Validate that the var is kind of array AST_EXP_VAR
		if (var != null)
		{
			varType = var.SemantMe();
			if (varType == null) {
				System.out.format(">> ERROR [%d] Trying access var subscript of non array type(%s)\n",this.lineNumber, varType);
				throw new AST_EXCEPTION(this.lineNumber);
			}
			if (varType.isArray()) {
				TYPE_ARRAY arr = (TYPE_ARRAY)varType;
				// System.out.format("@@@@@ 1 SEMANTME - AST_EXP_VAR_SUBSCRIPT TYPE =  %s, name = %s\n", arr.type, arr.name);
				return arr.type;
			}
			// Check for class var
			if (varType.isClassVar()) {
				TYPE_CLASS_VAR_DEC varTypeClass = (TYPE_CLASS_VAR_DEC)varType;
				if (varTypeClass.t.isArray()) {
					TYPE_ARRAY arr = (TYPE_ARRAY)varTypeClass.t;
					// System.out.format("@@@@@ 2 SEMANTME - AST_EXP_VAR_SUBSCRIPT TYPE = %s, name = %2\n", arr.type, arr.name);
					return arr.type;
				}
			}
			System.out.format(">> ERROR [%d] Trying access var subscript of non array type(%s)\n",this.lineNumber, varType);
			throw new AST_EXCEPTION(this.lineNumber);
		}
		System.out.format(">> ERROR [%d] missing var type(%s)\n",this.lineNumber, varType);
		throw new AST_EXCEPTION(this.lineNumber);
	}

	public TEMP IRme() throws Exception
	{
		System.out.format("IRme - AST_EXP_VAR_SUBSCRIPT\nScope=%d\n",myScope);
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_VAR_SUBSCRIPT\nScope=%d\n",myScope);
		if (var != null) var.Globalize();
		if (subscript != null) subscript.Globalize();
		// TODO - if globalize we maybe
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_VAR_SUBSCRIPT\nScope=%d\n",myScope);
		if (var != null) var.InitGlobals();
		if (subscript != null) subscript.InitGlobals();
	}
}
