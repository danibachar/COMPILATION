package AST;

public class AST_VAR_DOT_LIST extends AST_Node
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public AST_VAR_DOT head;
	public AST_VAR_DOT_LIST tail;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_VAR_DOT_LIST(AST_VAR_DOT head,AST_VAR_DOT_LIST tail)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		System.out.print("====================== AST_VAR_DOT_LIST\n");

		this.head = head;
		this.tail = tail;
	}

	public void PrintMe()
	{
		System.out.print("AST VAR DOT LIST\n");

		if (head != null) head.PrintMe();
		if (tail != null) tail.PrintMe();

		/**********************************/
		/* PRINT to AST GRAPHVIZ DOT file */
		/**********************************/
		AST_GRAPHVIZ.getInstance().logNode(
			SerialNumber,
			"VAR-DOT\nLIST\n");

		/****************************************/
		/* PRINT Edges to AST GRAPHVIZ DOT file */
		/****************************************/
		if (head != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,head.SerialNumber);
		if (tail != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,tail.SerialNumber);
	}
}
