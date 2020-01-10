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

public class IRcommand_Allocate_Array extends IRcommand
{
	TEMP dst;
	TEMP size;
	TYPE type;
	
	public IRcommand_Allocate_Array(TEMP dst, TEMP size, TYPE type)
	{
		this.dst = dst;
		this.size = size;
		this.type = type;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().allocate_array(dst,size,type);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
