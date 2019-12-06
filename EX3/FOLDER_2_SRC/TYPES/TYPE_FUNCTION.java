package TYPES;

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

	/****************/
	/* CTROR(S) ... */
	/****************/
	public TYPE_FUNCTION(TYPE returnType,String name,TYPE_LIST params)
	{
		this.name = name;
		this.returnType = returnType;
		this.params = params;
		if (params != null) {
			System.out.format("### TYPE_FUNCTION = %s, params TYPE_LIST\n",name);
			// params.PrintMyType();
		} else {
			System.out.format("### TYPE_FUNCTION `%s` was initialized without params\n",name);
		}

	}
}
