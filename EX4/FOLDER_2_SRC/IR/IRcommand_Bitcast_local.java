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

public class IRcommand_Bitcast_local extends IRcommand
{
	TEMP dst;
	int index;
	TYPE type;
	
	public IRcommand_Bitcast_local(TEMP dst, int index, TYPE type)
	{
		this.dst = dst;
		this.index = index;
		this.type = type;
	}
	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().bitcast_local(dst,index,type);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().allocate(var_name);
	}
}
