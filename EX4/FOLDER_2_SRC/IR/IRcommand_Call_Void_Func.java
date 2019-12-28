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

public class IRcommand_Call_Void_Func extends IRcommand
{
	String funcName;
	String params_string;
	int scope;

	public IRcommand_Call_Void_Func(String funcName, String params_string, int scope)
	{
		this.funcName 				 = funcName;
		this.params_string 				 = params_string;
		this.scope 						 = scope;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().call_void_func(funcName, params_string, scope);
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
