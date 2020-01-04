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
	String src_type;
	String dst_type;
	int align;

	public IRcommand_Decler_Func_Close(TEMP t, String returnType, String return_label, String src_type, String dst_type, int align)
	{
		this.t 		 			  = t;
		this.returnType   = returnType;
		this.return_label = return_label;
		this.src_type = src_type;
		this.dst_type = dst_type;
		this.align = align;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().print_close_func(t, returnType, return_label, src_type, dst_type, align);
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
