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

public class IRcommand_Load_Temp extends IRcommand
{
	TEMP dst;
	TEMP src;

	public IRcommand_Load_Temp(TEMP dst,TEMP src)
	{
		this.dst      = dst;
		this.src = src;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().load(dst,src);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Load_Temp - MIPS\n");
		//sir_MIPS_a_lot.getInstance().load(dst,var_name);
	}
}
