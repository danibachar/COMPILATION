package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import Pair.*;
import java.util.*;

public abstract class AST_STMT extends AST_Node
{
	/*********************************************************/
	/* The default message for an unknown AST statement node */
	/*********************************************************/
	public void PrintMe()
	{
		System.out.print("UNKNOWN AST STATEMENT NODE\n");
	}

	public TYPE SemantMe() throws Exception
	{
		System.out.print("SEMANTME - UNKNOWN AST STATEMENT NODE\n");
		return null;
	}

	public TEMP IRme() throws Exception
	{
		System.out.format("IRMe - UNKNOWN AST STATEMENT NODE\nScope=%d\n",myScope);
		return null;
	}
	public void Globalize() throws Exception {
		System.out.format("Globalize - UNKNOWN AST STATEMENT NODE\nScope=%d\n",myScope);
	}
	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_STMT_WHILE, Scope=%d\n",myScope);
	}
}
