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

public class IRcommand_Call_Func extends IRcommand
{
	String funcName;
	String params_string;
	String return_type;
	TEMP ret_ptr;
	// int scope;

	public IRcommand_Call_Func(String funcName, String params_string, String return_type, TEMP ret_ptr, int scope)
	{
		this.funcName 				 = funcName;
		this.params_string 		 = params_string;
		this.return_type 			 = return_type;
		this.ret_ptr 					 = ret_ptr;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().call_func(funcName, params_string, return_type, ret_ptr, scope);
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
