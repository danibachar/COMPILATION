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

public class IRcommand_Add_Int extends IRcommand
{
	public TEMP dst;
	public TEMP t1;
	public int value;

	public IRcommand_Add_Int(TEMP dst,TEMP t1,int value)
	{
		this.dst = dst;
		this.t1 = t1;
		this.value = value;
	}

	/*******************/
	/* LLVM_bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().add(dst,t1,value);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Add_Int - MIPS\n");
		// sir_MIPS_a_lot.getInstance().add(dst,t1,value);
	}
}
