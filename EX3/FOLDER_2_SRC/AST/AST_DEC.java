package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public abstract class AST_DEC extends AST_Node
{
	public TYPE SemantMe() throws Exception
	{
		System.out.format("AST_DEC\n");
		return null;
	}
}
