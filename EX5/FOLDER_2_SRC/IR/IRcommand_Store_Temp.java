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

public class IRcommand_Store_Temp extends IRcommand
{
	TEMP dst;
	TEMP src;

	public IRcommand_Store_Temp(TEMP dst,TEMP src)
	{
		this.src      = src;
		this.dst = dst;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store(dst,src);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Store_Temp - MIPS\n");
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
