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

public class IRcommand_Allocate_Local extends IRcommand
{
	TEMP t;
	String ptr_type;
	String ptr_type_init_val;
	int align;

	public IRcommand_Allocate_Local(TEMP t, String ptr_type, String ptr_type_init_val, int align, int scope)
	{
		this.t 				 				 = t;
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
		LLVM.getInstance().allocate_local(t, ptr_type, ptr_type_init_val, align, scope);
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
