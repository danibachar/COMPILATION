package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public abstract class AST_EXP extends AST_Node
{
	public boolean isConstExp() { return false;}
	public TYPE SemantMe() throws Exception
	{
		System.out.print("SEMANTME - AST_EXP - unknown expression\n");
		return null;
	}
}
