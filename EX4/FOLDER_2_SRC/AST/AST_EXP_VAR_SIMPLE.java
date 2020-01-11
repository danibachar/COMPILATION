package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import LocalVarCounter.*;
import LLVM.*;
import javafx.util.Pair;
import java.util.*;

public class AST_EXP_VAR_SIMPLE extends AST_EXP_VAR
{
	/************************/
	/* simple variable name */
	/************************/
	// public String name;
	TYPE_CLASS typeClass;
	boolean isInFunc;
	public int varIndex;
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
		// System.out.format("SEMANTME - AST_EXP_VAR_SIMPLE( %s ), line = %d\n",name, this.lineNumber);
		myType = SYMBOL_TABLE.getInstance().findField(name, false);
		if (myType == null)
		{
			throw new AST_EXCEPTION(this.lineNumber);
		}
		typeClass = SYMBOL_TABLE.getInstance().current_class;
		SYMBOL_TABLE_ENTRY es = SYMBOL_TABLE.getInstance().findEntry(name);
		if (es != null) {
			isInFunc = es.scope_number > 0;
		} else {
			// TODO handling this case??/
		}

		varIndex = LocalVarCounter.getInstance().getIndex(name, myType);
		return myType;
	}

	public TEMP IRme() throws Exception
	{
		TEMP t = TEMP_FACTORY.getInstance().getFreshTEMP();
		t.setType(myType);
		if (isInFunc)  {
			t.isaddr = false;
			if (varIndex == -1) {
				// System.out.format("@@@ IRcommand_Load - dst = %s, name = %s\n", t, name);
				IR.getInstance().Add_IRcommand(new IRcommand_Load(t,name));
			} else {
				// System.out.format("@@@ IRcommand_Load_Local - dst = %s, varIndex = %s\n", t, varIndex);
				IR.getInstance().Add_IRcommand(new IRcommand_Load_Local(t,varIndex));
			}
		}
		else if (typeClass!=null && (typeClass.queryDataMembersReqursivly(name) != null)){
			int varIndex = typeClass.queryDataMembersReqursivly(name).index;
			t.setType(typeClass);
			IR.getInstance()
				.Add_IRcommand(new IRcommandGetDataMemberByPTR(t, TYPE_INT.getInstance(), varIndex));
			TEMP pointerTemp = TEMP_FACTORY.getInstance().getFreshTEMP();
			pointerTemp.setType(myType);
			pointerTemp.isaddr = t.isaddr;
			IR.getInstance()
			.Add_IRcommand(new IRcommand_Bitcast_Pointer(pointerTemp, t));
			t = pointerTemp;

			t.isaddr = true;
		} else {
			IR.getInstance().Add_IRcommand(new IRcommand_Load_Global(t,name));
			t.isaddr = false;
		}

		return t;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_VAR_SIMPLE name = %s\n",name);
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_VAR_SIMPLE name = %s\n",name);
	}

}
