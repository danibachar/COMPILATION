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

public class IRcommand_Allocate extends IRcommand
{
	String var_name;
	String ptr_type;
	String ptr_type_init_val;
	int align;

	public IRcommand_Allocate(String var_name, String ptr_type, String ptr_type_init_val, int align, int scope)
	{
		this.var_name 				 = var_name;
		this.ptr_type 				 = ptr_type;
		this.ptr_type_init_val = ptr_type_init_val;
		this.align 						 = align;
		this.scope 						 = scope;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().allocate(var_name, ptr_type, ptr_type_init_val, align, scope);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// TODO - change! copied from IRcommand_Allocate
		sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
