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

public class IRcommand_Decler_Func_Close extends IRcommand
{
	TEMP t;
	String returnType;
	String return_label;

	public IRcommand_Decler_Func_Close(TEMP t, String returnType, String return_label)
	{
		this.t 		 			  = t;
		this.returnType   = returnType;
		this.return_label = return_label;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().print_close_func(t, returnType, return_label);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// TODO - change! copied from IRcommand_Allocate
		// sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
