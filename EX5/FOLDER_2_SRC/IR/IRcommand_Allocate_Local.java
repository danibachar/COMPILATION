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

public class IRcommand_Allocate_Local extends IRcommand
{
	String var_name;
	TYPE type;

	public IRcommand_Allocate_Local(String var_name, TYPE type)
	{
		this.var_name = var_name;
		this.type = type;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().allocate_local(var_name, type);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Allocate_Local - MIPS\n");
		sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
