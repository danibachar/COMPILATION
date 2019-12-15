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
	public TYPE_CLASS_FUNC_DEC_LIST methods;

	/****************/
	/* CTROR(S) ... */
	/****************/
	public TYPE_CLASS(
		TYPE_CLASS father,
		String name,
		TYPE_CLASS_VAR_DEC_LIST data_members,
		TYPE_CLASS_FUNC_DEC_LIST methods
	) {
		this.name = name;
		this.father = father;
		this.data_members = data_members;
		this.methods = methods;
		// if (data_members != null) {
		// 	System.out.format("TYPE_CLASS = %s has data_members\n",name);
		// } else {
		// 	System.out.format("TYPE_CLASS `%s` was initialized without datamembers\n this must mean pre-declaration or no data members at all\n",name);
		// }


		// if (methods != null) {
		// 	System.out.format("TYPE_CLASS = %s has methods\n",name);
		// } else {
		// 	System.out.format("TYPE_CLASS `%s` was initialized without methods\n this must mean pre-declaration or no methods at all\n",name);
		// }


	}

	/*************/
	/* isClass() */
	/*************/
	@Override
	public boolean isClass(){ return true; }

	public boolean isAssignableFrom(TYPE t) {
		if (t == null) return false;
		if (t == TYPE_NIL.getInstance()) return true;
		else if (!t.isClass()) return false;
		TYPE_CLASS checkedClass = null;
		if (t.isClassVar()) {
			TYPE_CLASS_VAR_DEC tv = (TYPE_CLASS_VAR_DEC)t;
			checkedClass = (TYPE_CLASS)tv.t;
		} else {
			checkedClass = (TYPE_CLASS) t;
		}
		while (checkedClass != null) {
				if (checkedClass.equals(this))
						return true;
				checkedClass = checkedClass.father;
		}
		return false;
	}

	public TYPE_CLASS_VAR_DEC queryDataMembersReqursivly(String fieldName) {
		// Search here
		// System.out.format("Start Looking for supported fields names = %s in class =  %s\n",fieldName, name);
		for (TYPE_CLASS_VAR_DEC_LIST it=this.data_members;it != null;it=it.tail) {
			if (it.head != null) {
				// System.out.format("Looking for fieldlName head.name - %s \n",it.head.name);
				// System.out.format("Looking for fieldlName head.t - %s \n",it.head.t);
				if (it.head.name.equals(fieldName)) {
					// System.out.format("Found data memeber Name %s  with type (%s)=%s\n",it.head.name, it.head.t, it.head.t.name);
					return it.head;
				}
			}
		}
		// Search Parent Reqursivly
		if (father != null) {
				return father.queryDataMembersReqursivly(fieldName);
		}
		return null;
	}

	public TYPE_FUNCTION queryMethodsReqursivly(String method_name) {
		// Search here
		// System.out.format("Start Looking for supported method_name = %s in class =  %s\n",method_name, name);
		for (TYPE_CLASS_FUNC_DEC_LIST it=this.methods;it != null;it=it.tail) {
			if (it.head != null) {
				// System.out.format("Looking for method head.name - %s \n",it.head.name);
				// System.out.format("Looking for method head.t - %s \n",it.head.returnType);
				if (it.head.name.equals(method_name)) {
					// System.out.format("Found method Name %s  with returnType %s\n",it.head.name, it.head.returnType);
					return it.head;
				}
			}
		}
		// Search Parent Reqursivly
		if (father != null) {
				return father.queryMethodsReqursivly(method_name);
		}
		return null;
	}
}
