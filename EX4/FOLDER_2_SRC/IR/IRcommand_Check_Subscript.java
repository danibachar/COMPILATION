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

public class IRcommand_Check_Subscript extends IRcommand
{

	public TEMP dst;
	public TEMP subscript;
	
	public IRcommand_Check_Subscript(TEMP dst, TEMP subscript)
	{
		this.dst = dst;
		this.subscript = subscript;

	}

	/*******************/
	/* LLVM_bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().check_subscript(dst, subscript);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().add(dst,t1,t2);
	}
}
