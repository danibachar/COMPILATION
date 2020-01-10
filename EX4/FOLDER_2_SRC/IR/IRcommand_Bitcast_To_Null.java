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

public class IRcommand_Bitcast_To_Null extends IRcommand
{
	TEMP dst;
	TEMP src;
	
	public IRcommand_Bitcast_To_Null(TEMP dst, TEMP src)
	{
		this.dst = dst;
		this.src = src;
	}
	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().bitcast_to_null(dst,src);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
