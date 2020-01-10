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

public class IRcommand_Get_Element_Int extends IRcommand
{
	public TEMP dst;
	public TEMP src;
	public TYPE type;
	public int offset;
	
	public IRcommand_Get_Element_Int(TEMP dst, TEMP src, TYPE type, int offset)
	{
		this.dst = dst;
		this.src = src;
		this.type = type;
		this.offset = offset;
	}

	/*******************/
	/* LLVM_bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().getelement(dst,src,type, offset);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().add(dst,t1,t2);
	}
}
