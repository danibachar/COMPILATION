package AST;

import TEMP.*;
import TYPES.*;

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

	public TYPE myType = null;

	public String name = null;

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

	public void Globalize() throws Exception {}
	public void InitGlobals() throws Exception {}

}
