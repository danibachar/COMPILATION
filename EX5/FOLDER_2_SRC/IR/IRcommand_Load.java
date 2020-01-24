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
	String varName;

	public IRcommand_Load(TEMP dst,String varName)
	{
		this.dst      = dst;
		this.varName = varName;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().load(dst,varName);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Load - MIPS\n");
		//sir_MIPS_a_lot.getInstance().load(dst,var_name);
	}
}
