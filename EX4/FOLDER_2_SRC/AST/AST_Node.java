package AST;

import TEMP.*;

public abstract class AST_Node
{
	/*******************************************/
	/* The serial number is for debug purposes */
	/* In particular, it can help in creating  */
	/* a graphviz dot format of the AST ...    */
	/*******************************************/
	public int SerialNumber;

	public int lineNumber;

	public int myScope;

	/***********************************************/
	/* The default message for an unknown AST node */
	/***********************************************/
	public void PrintMe()
	{
		System.out.print("AST NODE UNKNOWN\n");
	}

	/*****************************************/
	/* The default IR action for an AST node */
	/*****************************************/
	public TEMP IRme()  throws Exception
	{
		System.out.format("IRme - AST NODE UNKNOW - line = %d\n",lineNumber);
		return null;
	}
}
