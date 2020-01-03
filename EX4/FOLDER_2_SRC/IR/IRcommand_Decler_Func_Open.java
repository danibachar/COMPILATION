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

public class IRcommand_Decler_Func_Open extends IRcommand
{
	String func_name;
	String params_string;
	String return_typ;

	public IRcommand_Decler_Func_Open(String func_name,String params_string, String return_typ, int scope)
	{
		this.func_name 		 = func_name;
		this.params_string = params_string;
		this.return_typ 	 = return_typ;
		this.scope 						 = scope;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().print_open_func(func_name, params_string, return_typ);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// TODO - change! copied from IRcommand_Allocate
		// sir_MIPS_a_lot.getInstance().allocate(func_name);
	}
}
