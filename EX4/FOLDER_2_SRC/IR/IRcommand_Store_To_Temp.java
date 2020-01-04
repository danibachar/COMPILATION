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

public class IRcommand_Store_To_Temp extends IRcommand
{
	TEMP dst;
	TEMP src;
	String src_type;
	String dst_type;
	int align;

	public IRcommand_Store_To_Temp(TEMP dst,TEMP src, String src_type, String dst_type, int align)
	{
		this.src = src;
		this.dst = dst;
		this.src_type = src_type;
		this.dst_type = dst_type;
		this.align = align;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_to_temp(dst, src, src_type, dst_type, align);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().store(var_name, src);
	}
}
