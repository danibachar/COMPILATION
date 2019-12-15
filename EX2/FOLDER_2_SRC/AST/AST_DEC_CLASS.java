package AST;

public class AST_DEC_CLASS extends AST_DEC
{
	/********/
	/* NAME */
	/********/
	public String name;
	public String parent;
	public AST_DEC_CFIELDS body;
	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_DEC_CLASS(String name,String parent,AST_DEC_CFIELDS body)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// if (parent != null) {
		// 	System.out.format("====================== classDec -> CLASS ID( %s ) EXTENDS( %s )\n", name, parent);
		// } else {
		// 	System.out.format("====================== classDec -> CLASS ID( %s ) \n", name);
		// }

		this.name = name;
		this.parent = parent;
		this.body = body;
	}

	/*********************************************************/
	/* The printing message for a class declaration AST node */
	/*********************************************************/
	public void PrintMe()
	{
		/*************************************/
		/* RECURSIVELY PRINT HEAD + TAIL ... */
		/*************************************/
		System.out.format("CLASS DEC = %s\n",name);

		if (body != null) body.PrintMe();
		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("CLASS\n%s",name));

		AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,body.SerialNumber);
	}
}
