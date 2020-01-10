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

public class IRcommand_Load_Local extends IRcommand
{
	TEMP dst;
	int varIndex;
	
	public IRcommand_Load_Local(TEMP dst,int varIndex)
	{
		this.dst      = dst;
		this.varIndex = varIndex;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().load_local(dst,varIndex);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().load(dst,var_name);
	}
}
