package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

public class AST_EXP_NEW extends AST_EXP
{
	public String type;
  public AST_EXP exp;

	public boolean isNewArray() { return exp != null;}

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public AST_EXP_NEW(String type,AST_EXP exp, Integer lineNumber)
	{
		/******************************/
		/* SET A UNIQUE SERIAL NUMBER */
		/******************************/
		SerialNumber = AST_Node_Serial_Number.getFresh();

		/***************************************/
		/* PRINT CORRESPONDING DERIVATION RULE */
		/***************************************/
		// System.out.format("====================== newExp -> ID( %s )\n", type);

		this.lineNumber = lineNumber;
		this.type = type;
    this.exp = exp;
	}

	/************************************************/
	/* The printing message for an INT EXP AST node */
	/************************************************/
  public void PrintMe()
  {
		// System.out.format("AST_EXP_NEW type - %s\n" ,type);
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

	public TYPE SemantMe() throws Exception
	{
		TYPE t;
		// System.out.format("SEMANTME - AST_EXP_NEW type - %s\n" ,type);
		/************************************************/
		/* Check That Type Was previously declared*/
		/************************************************/
		t = SYMBOL_TABLE.getInstance().find(type);
		if (t == null)
		{
			System.out.format(">> ERROR [%d] Class type(%s) was not declared\n",this.lineNumber,type);
			throw new AST_EXCEPTION(this);
		}
		if (t == TYPE_VOID.getInstance())
		{
			System.out.format(">> ERROR [%d] Cannot ask to create new void, daaa!\n",this.lineNumber,type);
			throw new AST_EXCEPTION(this);
		}
		/***********************************************************/
		/* Check That the Type is actually a class type or an array*/
		/***********************************************************/
		if (!t.isClass() && exp == null)
		{
			System.out.format(">> ERROR [%d] trying to create new entity that is not a class/array type(%s)\n",this.lineNumber,type);
			throw new AST_EXCEPTION(this);
		}

		// Validate inheritance assignment


		// Validating array
		if (exp != null) {
			TYPE expType = exp.SemantMe();
			// TYPE nt = SYMBOL_TABLE.getInstance().find(expType.name);
			if ( expType != TYPE_INT.getInstance()) {
				System.out.format(">> ERROR [%d] trying to init array[%s] with not declared type = %s\n",this.lineNumber,type, expType);
				throw new AST_EXCEPTION(this);
			}
			// return new TYPE_ARRAY(,int)
		}
		// Validate Expression

		return t;
	}
}
