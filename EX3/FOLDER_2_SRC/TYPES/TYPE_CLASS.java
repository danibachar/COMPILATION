package TYPES;

import java.util.Map;

public class TYPE_CLASS extends TYPE
{
	/*********************************************************************/
	/* If this class does not extend a father class this should be null  */
	/*********************************************************************/
	public TYPE_CLASS father;

	/**************************************************/
	/* Gather up all data members in one place        */
	/* Note that data members coming from the AST are */
	/* packed together with the class methods         */
	/**************************************************/
	public TYPE_CLASS_VAR_DEC_LIST data_members;

	// Mapping of name to type
	// private final Map<String, TYPE> fields;
  // private final Map<String, TYPE> methods;

	/****************/
	/* CTROR(S) ... */
	/****************/
	public TYPE_CLASS(TYPE_CLASS father, String name, TYPE_CLASS_VAR_DEC_LIST data_members)
	{
		this.name = name;
		this.father = father;
		this.data_members = data_members;
		if (data_members != null) {
			System.out.format("### TYPE_CLASS = %s, params TYPE_LIST\n",name);
		} else {
			System.out.format("### TYPE_CLASS `%s` was initialized without datamembers\n this must mean pre-declaration\n",name);
		}

	}

	// public TYPE_CLASS(TYPE_CLASS father, String name, Map<String, TYPE> fields, Map<String, TYPE> methods)
	// {
	// 	this.name = name;
	// 	this.father = father;
	// 	this.data_members = null;
	// 	this.fields = fields;
	// 	this.methods = methods;
	// 	if (data_members != null) {
	// 		System.out.format("### TYPE_CLASS = %s, params TYPE_LIST\n",name);
	// 	} else {
	// 		System.out.format("### TYPE_CLASS `%s` was initialized without datamembers\n this must mean pre-declaration\n",name);
	// 	}
	//
	// }

	/*************/
	/* isClass() */
	/*************/
	@Override
	public boolean isClass(){ return true; }

	public boolean isAssignableFrom(TYPE t) {
		if (t == null) return false;
		if (t == TYPE_NIL.getInstance()) return true;
		// else if (t == TypeError.instance) return true;
		else if (!t.isClass()) return false;
		TYPE_CLASS checkedClass = (TYPE_CLASS) t;
		while (checkedClass != null) {
				if (checkedClass.equals(this))
						return true;
				checkedClass = checkedClass.father;
		}
		return false;
}
}
