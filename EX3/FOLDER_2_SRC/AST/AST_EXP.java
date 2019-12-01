package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public abstract class AST_EXP extends AST_Node
{
	public TYPE SemantMe() throws Exception
	{
		System.out.print("AST_EXP - unknown expression\n");
		return null;
	}
}
