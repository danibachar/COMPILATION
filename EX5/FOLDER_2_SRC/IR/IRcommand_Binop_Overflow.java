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

public class IRcommand_Binop_Overflow extends IRcommand
{
	public TEMP dst;
	public TEMP val;


	public IRcommand_Binop_Overflow(TEMP dst,TEMP val)
	{
		this.dst = dst;
		this.val = val;

	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().handle_overflow(dst,val);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		
	}
}
