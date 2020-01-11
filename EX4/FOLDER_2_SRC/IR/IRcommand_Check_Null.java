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

public class IRcommand_Check_Null extends IRcommand
{

	public TEMP dst;
	public boolean shouldReverse;

	public IRcommand_Check_Null(TEMP dst, boolean shouldReverse)
	{
		this.dst = dst;
		this.shouldReverse = shouldReverse;
	}

	public IRcommand_Check_Null(TEMP dst)
	{
		this.dst = dst;
		this.shouldReverse = false;
	}

	/*******************/
	/* LLVM_bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().check_null_deref(dst, shouldReverse);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().add(dst,t1,t2);
	}
}
