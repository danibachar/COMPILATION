/***********/
/* PACKAGE */
/***********/
package IR;

/*******************/
/* GENERAL IMPORTS */
/*******************/

/*******************/
/* PROJECT IMPORTS */
/*******************/
import TEMP.*;
import TYPES.TYPE;
import LLVM.*;
import MIPS.*;

public class IRcommand_Store_Param extends IRcommand
{
	String name;
	TEMP src;
	
	public IRcommand_Store_Param(String name,TEMP src)
	{
		this.name = name;
		this.src = src;

	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_param(name, src);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
	}
}
