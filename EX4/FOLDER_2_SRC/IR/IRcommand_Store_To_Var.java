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

public class IRcommand_Store_To_Var extends IRcommand
{
	String var_name;
	TEMP src;
	String src_type;
	String dst_type;
	int align;

	public IRcommand_Store_To_Var(String var_name,TEMP src,String src_type, String dst_type, int align)
	{
		this.src      = src;
		this.var_name = var_name;
		this.src_type = src_type;
		this.dst_type = dst_type;
		this.align = align;

	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_to_var(var_name, src, src_type, dst_type, align);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().store(var_name, src);
	}
}
