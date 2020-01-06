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

public class IRcommand_Store_String_Var_To_Temp extends IRcommand
{
	String var_name;
	TEMP src;
	String value;
	String src_type;
	String dst_type;
	int align;

	public IRcommand_Store_String_Var_To_Temp(String var_name,TEMP src, String value, String src_type, String dst_type, int align)
	{
		this.src      = src;
		this.var_name = var_name;
		this.value = value;
		this.src_type = src_type;
		this.dst_type = dst_type;
		this.align = align;

	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_var_string_to_temp(var_name, src, value, src_type, dst_type, align);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().store(var_name, src);
	}
}
