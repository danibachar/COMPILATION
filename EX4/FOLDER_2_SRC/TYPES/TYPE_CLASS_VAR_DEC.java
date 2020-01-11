package TYPES;

import AST.*;

public class TYPE_CLASS_VAR_DEC extends TYPE
{
	public TYPE t;
	public String name;


	public int index;
	public TYPE_CLASS typeClass;
	public AST_EXP exp;
	public boolean initialized = false;


	public boolean isClassVar(){ return true;}

	public TYPE_CLASS_VAR_DEC(TYPE t,String name)
	{
		this.t = t;
		this.name = name;
		if (name == null) {
			// System.out.format("TYPE_CLASS_VAR_DEC INIT without name - %s \n",name);
		}
		if (t == null) {
			// System.out.format("TYPE_CLASS_VAR_DEC INIT without type - %s \n",t);
		}
	}
}
