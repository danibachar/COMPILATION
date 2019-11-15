package AST;

public class AST_EXP_NEW extends AST_EXP
{
	public String type;
  public AST_EXP exp;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_NEW(String type,AST_EXP exp)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		System.out.format("====================== newExp -> ID( %s )\n", type);

		this.type = type;
    this.exp = exp;
	}

	/************************************************/
	/* The printing message for an INT EXP AST node */
	/************************************************/
  public void PrintMe()
  {
    /********************************/
    /* AST NODE TYPE = AST EXP NEW */
    /********************************/
		System.out.print("AST NODE EXP NEW\n");
    // if (exp != null) System.out.format("VAR-DEC(%s):%s := exp\n",type,exp);
    // if (exp == null) System.out.format("VAR-DEC(%s):%s                \n",name,type);

    /**************************************/
    /* RECURSIVELY PRINT initialValue ... */
    /**************************************/
    if (exp != null) exp.PrintMe();

    /**********************************/
    /* PRINT to AST GRAPHVIZ DOT file */
    /**********************************/
    AST_GRAPHVIZ.getInstance().logNode(
      SerialNumber,
      String.format("NEW(%s)\n",type));

    /****************************************/
    /* PRINT Edges to AST GRAPHVIZ DOT file */
    /****************************************/
    if (exp != null) AST_GRAPHVIZ.getInstance().logEdge(SerialNumber,exp.SerialNumber);

  }
}
