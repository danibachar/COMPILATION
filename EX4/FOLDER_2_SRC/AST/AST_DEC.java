package AST;

import TEMP.*;
import IR.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public abstract class AST_DEC extends AST_Node
{
	public String name;
	public Integer nameLineNumber;

	public TYPE SemantMe() throws Exception
	{
		System.out.format("SEMANTME - AST_DEC Empty\nScope=%d\n",myScope);
		return null;
	}

	public boolean isFuncDec() { return false;}
	public boolean isVarDec() { return false;}
	public boolean isClassDec() { return false;}
	public boolean isArrayDec() { return false;}
}
