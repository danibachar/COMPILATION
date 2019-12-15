package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public abstract class AST_EXP_VAR extends AST_EXP
{
	public String name=null;
	public void PrintMe()
	{
		System.out.print("UNKNOWN AST_EXP_VAR");
	}

	public TYPE SemantMe() throws Exception
	{
		// System.out.print("SEMANTME - AST_EXP_VAR - unknown expression\n");
		return null;
	}
}
