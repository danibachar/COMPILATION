package TYPES;

import AST.*;

public class TYPE_CLASS_FUNC_DEC extends TYPE
{
	public TYPE returnType;
	public TYPE_LIST params;
	public String name;

	public boolean isClassFunc(){ return true;}

	public TYPE_CLASS_FUNC_DEC(TYPE returnType, String name, TYPE_LIST params)
	{
		this.returnType = returnType;
		this.name = name;
		this.params = params;
	}
}
