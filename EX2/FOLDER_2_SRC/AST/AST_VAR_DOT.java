/***********/
/* PACKAGE */
/***********/
package AST;

public class AST_VAR_DOT extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_VAR var;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_VAR_DOT(AST_VAR var)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		System.out.format("====================== var . ");

		this.var = var;
	}

	public void PrintMe()
	{
		System.out.format("VAR_DOT");

    if (var != null) var.PrintMe();

		/***************************************/
		/* PRINT Node to AST GRAPHVIZ DOT file */
		/***************************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			String.format("NAME-DOT\n"));
	}
}
