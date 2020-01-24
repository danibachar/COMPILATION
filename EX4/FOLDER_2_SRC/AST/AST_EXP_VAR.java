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

public abstract class AST_EXP_VAR extends AST_EXP
{
	// public String name=null;
	public void PrintMe()
	{
		System.out.print("UNKNOWN AST_EXP_VAR");
	}

	public TYPE SemantMe() throws Exception
	{
		System.out.print("SEMANTME - AST_EXP_VAR - unknown expression\n");
		return null;
	}

	public TEMP IRme() throws Exception
	{
		System.out.format("IRme - AST_EXP_VAR - unknown expression, Scope=%d\n",myScope);
		return null;
	}

	public void Globalize() throws Exception {
		System.out.format("Globalize - AST_EXP_VAR_SUBSCRIPT, Scope=%d\n",myScope);
		// TODO - if globalize we maybe
	}
	public void InitGlobals() throws Exception {
		System.out.format("InitGlobals - AST_EXP_VAR_SUBSCRIPT, Scope=%d\n",myScope);
	}
}
