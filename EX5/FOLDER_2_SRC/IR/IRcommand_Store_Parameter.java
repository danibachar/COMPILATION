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
import TYPES.TYPE;
import LLVM.*;
import MIPS.*;

public class IRcommand_Store_Parameter extends IRcommand
{
	String var_name;
	TYPE type;
	int index;

	public IRcommand_Store_Parameter(String var_name, TYPE type, int index)
	{
		this.var_name = var_name;
		this.type = type;
		this.index = index;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_paramter(var_name, type, index);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Store_Parameter - MIPS\n");
		sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
