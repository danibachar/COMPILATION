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

public class IRcommand_Load_From_Var extends IRcommand
{
	TEMP dst;
	String var_name;
	String src_type;
 	String dst_type;
	int align;

	public IRcommand_Load_From_Var(
		TEMP dst, String var_name, String src_type, String dst_type, int align
	) {
		this.dst      = dst;
		this.var_name = var_name;
		this.src_type = src_type;
		this.dst_type = dst_type;
		this.align 		= align;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().load_from_var(dst, var_name, src_type, dst_type, align);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().load(dst,var_name);
	}
}
