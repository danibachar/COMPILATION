package AST;

import TEMP.*;
import IR.*;
import MIPS.*;
import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;
import var_c.*;
import LLVM.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;

public abstract class AST_DEC extends AST_Node
{
	public String name;
	public Integer nameLineNumber;

	public TYPE SemantMe() throws Exception
	{
		System.out.format("SEMANTME - AST_DEC Empty\nScope=%d\n",myScope);
		return null;
	}
	public TEMP IRme()  throws Exception
	{
		System.out.print("IRme - AST_DEC UNKNOWN\n");
		return null;
	}

	public boolean isFuncDec() { return false;}
	public boolean isVarDec() { return false;}
	public boolean isClassDec() { return false;}
	public boolean isArrayDec() { return false;}
}
