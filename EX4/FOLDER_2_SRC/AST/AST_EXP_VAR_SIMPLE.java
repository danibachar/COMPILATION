package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_VAR_SIMPLE extends AST_EXP_VAR
{
	/************************/
	/* simple variable name */
	/************************/
	// public String name;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_VAR_SIMPLE(String name, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		// System.out.format("====================== var -> ID( %s )\n",name);
		this.lineNumber = lineNumber;
		this.name = name;
	}

	/**************************************************/
	/* The printing message for a simple var AST node */
	/**************************************************/
	public void PrintMe()
	{
		/**********************************/
		/* AST NODE TYPE = AST SIMPLE VAR */
		/**********************************/
		// System.out.format("AST_EXP_VAR_SIMPLE( %s )\n",name);
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("SIMPLE\nVAR\n(%s)",name));
	}
	public TYPE SemantMe() throws Exception
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.format("SEMANTME - AST_EXP_VAR_SIMPLE( %s )\n",name);
		myType = SYMBOL_TABLE.getInstance().findField(name,false);
		return myType;
	}

	public TEMP IRme() throws Exception
	{
		TYPE t = myType;//SYMBOL_TABLE.getInstance().findField(name,false);
		String src_type = AST_HELPERS.type_to_string(t);
		int align = AST_HELPERS.type_to_align(t);

		TEMP dst = TEMP_FACTORY.getInstance().getFreshTEMP();
		TEMP src = TEMP_FACTORY.getInstance().findVarRecursive(name, myScope);
		if (src == null) {
			IR.getInstance()
				.Add_IRcommand(new IRcommand_Load_From_Var(dst, name, src_type, src_type+"*", align));
				return dst;
		}
		System.out.format("Load_From_Temp - name = %s, src_type = %s, align = %d\n",name,src_type,align);
		IR.getInstance()
			.Add_IRcommand(new IRcommand_Load_From_Temp(dst, src, src_type, src_type+"*", align));
		return dst;
	}

}
