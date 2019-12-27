package TYPES;

public abstract class TYPE
{
	/******************************/
	/*  Every type has a name ... */
	/******************************/
	public String name;

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
}
