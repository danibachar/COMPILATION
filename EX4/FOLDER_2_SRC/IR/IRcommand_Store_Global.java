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
import LLVM.*;
import MIPS.*;

public class IRcommand_Store_Global extends IRcommand
{
	String var_name;
	TEMP src;
	
	public IRcommand_Store_Global(String var_name,TEMP src)
	{
		this.src      = src;
		this.var_name = var_name;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_global(var_name,src);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().store_global(var_name,src);
	}
}
