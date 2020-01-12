package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import javafx.util.Pair;
import java.util.*;

public class AST_TYPE_NAME_LIST extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_TYPE_NAME head;
	public AST_TYPE_NAME_LIST tail;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_TYPE_NAME_LIST(AST_TYPE_NAME head, AST_TYPE_NAME_LIST tail, Integer lineNumber)
	{
		SerialNumber = AST_Node_Serial_Number.getFresh();

		this.lineNumber = lineNumber;
		this.head = head;
		this.tail = tail;
	}

	/******************************************************/
	/* The printing message for a type name list AST node */
	/******************************************************/
	public void PrintMe()
	{
		this.myScope = SYMBOL_TABLE.getInstance().scopeCount;
		// System.out.print("AST_TYPE_NAME_LIST\n");
		/*************************************/
		/* RECURSIVELY PRINT HEAD + TAIL ... */
		/*************************************/
		if (head != null) head.PrintMe();
		if (tail != null) tail.PrintMe();

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"TYPE-NAME\nLIST\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (head != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,head.SerialNumber);
		if (tail != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,tail.SerialNumber);
	}

	public TYPE_LIST SemantMe() throws Exception
	{
		// System.out.print("SEMANTME - AST_TYPE_NAME_LIST\n");
		if (tail == null)
		{
			try {
				return new TYPE_LIST(head.SemantMe(),null);
			} catch (Exception e) {
				throw new AST_EXCEPTION(this.lineNumber);
			}

		}
		else
		{
			try {
				return new TYPE_LIST(head.SemantMe(),tail.SemantMe());
			} catch (Exception e) {
				throw new AST_EXCEPTION(this.lineNumber);
			}

		}
	}

	public TYPE_LIST GetTypes() throws Exception
	{
		TYPE t = SYMBOL_TABLE.getInstance().findVarType(head.type);
		if (t == null)
		{
			System.out.format("Type %s is not supported", head.type);
			throw new AST_EXCEPTION(this.lineNumber);
		}

		if (tail == null)
		{
			return new TYPE_LIST(t,null);
		}
		else
		{
			return new TYPE_LIST(t, tail.GetTypes());
		}
	}

	public TEMP IRme() throws Exception
	{
		System.out.format("IRme - UNKNOWN AST AST_TYPE_NAME_LIST NODE, Scope=%d\n",myScope);
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - UNKNOWN AST AST_TYPE_NAME_LIST NODE, Scope=%d\n",myScope);
		if (head != null) { head.Globalize(); }
		if (tail != null) { tail.Globalize(); }
	}

	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - UNKNOWN AST AST_TYPE_NAME_LIST NODE, Scope=%d\n",myScope);
		if (head != null) { head.InitGlobals(); }
		if (tail != null) { tail.InitGlobals(); }
	}
}
