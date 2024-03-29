package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public abstract class AST_DEC extends AST_Node
{
	public String name;
	public Integer nameLineNumber;

	public TYPE SemantMe() throws Exception
	{
		System.out.format("SEMANTME - AST_DEC Empty\n");
		return null;
	}

	public boolean isFuncDec() { return false;}
	public boolean isVarDec() { return false;}
	public boolean isClassDec() { return false;}
	public boolean isArrayDec() { return false;}
}
