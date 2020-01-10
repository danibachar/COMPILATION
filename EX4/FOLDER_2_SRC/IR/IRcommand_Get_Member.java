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
import TYPES.*;
import TEMP.*;
import LLVM.*;
import MIPS.*;

public class IRcommand_Get_Member extends IRcommand
{
	public TEMP dst;
	public TYPE type;
	public int offset;
	
	public IRcommand_Get_Member(TEMP dst, TYPE type, int offset)
	{
		this.dst = dst;
		this.type = type;
		this.offset = offset;
	}

	/*******************/
	/* LLVM_bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().get_member(dst,type, offset);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().add(dst,t1,t2);
	}
}
