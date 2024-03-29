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

public class IRcommand_Binop_Div_Integers extends IRcommand
{
	public TEMP t1;
	public TEMP t2;
	public TEMP dst;

	public IRcommand_Binop_Div_Integers(TEMP dst,TEMP t1,TEMP t2)
	{
		this.dst = dst;
		this.t1 = t1;
		this.t2 = t2;
	}

	/*******************/
	/* LLVM_bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().div(dst,t1,t2);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Binop_Div_Integers - MIPS\n");
		//sir_MIPS_a_lot.getInstance().mul(dst,t1,t2);
	}
}
