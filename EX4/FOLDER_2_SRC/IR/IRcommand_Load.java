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

public class IRcommand_Load extends IRcommand
{
	TEMP dst;
	String var_name;

	public IRcommand_Load(TEMP dst, String var_name, int scope)
	{
		this.dst      = dst;
		this.var_name = var_name;
		this.scope 		= scope;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().load(dst, var_name, scope);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		sir_MIPS_a_lot.getInstance().load(dst,var_name);
	}
}
