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

public class IRcommand_Load_Global extends IRcommand
{
	TEMP dst;
	String name;
	
	public IRcommand_Load_Global(TEMP dst,String name)
	{
		this.dst      = dst;
		this.name = name;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().load_global(dst,name);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().load(dst,var_name);
	}
}
