package TYPES;
import AST.*;

public abstract class TYPE
{
	/******************************/
	/*  Every type has a name ... */
	/******************************/
	public String name;

	public int typeOfType = 0;

	/*************/
	/* isClass() */
	/*************/
	public boolean isClass(){ return false;}

	/*************/
	/* isArray() */
	/*************/
	public boolean isArray(){ return false;}

	/*************/
	/* isFunc() */
	/*************/
	public boolean isFunc(){ return false;}

	/*****************/
	/* isClassFunc() */
	/*****************/
	public boolean isClassFunc(){ return false;}

	/****************/
	/* isClassVar() */
	/****************/
	public boolean isClassVar(){ return false;}

	public boolean isVoid() {
		 return this == TYPE_VOID.getInstance();
	}

	public boolean isInt() {
		 return this == TYPE_INT.getInstance();
	}
}
