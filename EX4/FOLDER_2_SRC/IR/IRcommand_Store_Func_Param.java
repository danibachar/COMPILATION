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
	TEMP dst;
	Integer src;

	public IRcommand_Store_Func_Param(TEMP dst, Integer src)
	{
		this.src      = src;
		this.dst 			= dst;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_func_param(dst, src);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().store(var_name, src);
	}
}
