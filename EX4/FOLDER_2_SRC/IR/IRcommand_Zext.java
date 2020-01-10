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

public class IRcommand_Zext extends IRcommand
{
	TEMP dst;
	TEMP src;
	
	public IRcommand_Zext(TEMP dst, TEMP src)
	{
		this.dst = dst;
		this.src = src;
	}
	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().zext(dst,src);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
