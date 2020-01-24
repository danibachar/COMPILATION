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
import TYPES.TYPE;
import LLVM.*;
import MIPS.*;

public class IRcommand_Bitcast_Malloc extends IRcommand
{
	TEMP dst;
	TEMP src;
	
	public IRcommand_Bitcast_Malloc(TEMP dst, TEMP src)
	{
		this.dst = dst;
		this.src = src;
	}
	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().bitcast_from_malloc(dst,src);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
