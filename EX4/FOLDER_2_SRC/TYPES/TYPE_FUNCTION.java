package TYPES;

import AST.*;

public class TYPE_FUNCTION extends TYPE
{
	/***********************************/
	/* The return type of the function */
	/***********************************/
	public TYPE returnType;

	/*************************/
	/* types of input params */
	/*************************/
	public TYPE_LIST params;
	public TYPE_CLASS origClass;

	public boolean isFunc(){ return true;}
	/****************/
	/* CTROR(S) ... */
	/****************/
	public TYPE_FUNCTION(TYPE returnType,String name,TYPE_LIST params)
	{
		this.name = name;
		this.returnType = returnType;
		this.params = params;
		this.typeOfType = 2;

	}

	public boolean compareSignature(TYPE_FUNCTION func)
	{
		System.out.format("Comparing signatures for function %s\n", name);
		if (!returnType.name.equals(func.returnType.name))
		{
			return false;
		}
		TYPE_LIST currItParams = params;
		TYPE_LIST otherItParams = func.params;
		while (currItParams != null && otherItParams != null)
		{
			if (!currItParams.head.name.equals(otherItParams.head.name))
			{
				return false;
			}
			currItParams = currItParams.tail;
			otherItParams = otherItParams.tail;
		}
		if ((currItParams == null && otherItParams != null) || (currItParams != null && otherItParams == null))
		{
			return false;
		}
		return true;
	}
}
