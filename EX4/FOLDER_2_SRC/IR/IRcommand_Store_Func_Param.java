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

public class IRcommand_Store_Func_Param extends IRcommand
{
	String var_name;
	TEMP src;

	public IRcommand_Store_Func_Param(String var_name,TEMP src, int scope)
	{
		this.src      = src;
		this.scope 		= scope;
		this.var_name = var_name;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_func_param(var_name, src, scope);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().store(var_name, src);
	}
}
