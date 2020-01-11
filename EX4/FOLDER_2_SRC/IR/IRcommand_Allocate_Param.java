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

public class IRcommand_Allocate_Param extends IRcommand
{
	String var_name;
	TYPE type;
	
	public IRcommand_Allocate_Param(String var_name, TYPE type)
	{
		this.var_name = var_name;
		this.type = type;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().allocate_param(var_name, type);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
