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

public class IRcommandConstString extends IRcommand
{
	TEMP t;
	String value;

	public IRcommandConstString(TEMP t,String value)
	{
		this.t = t;
		this.value = value;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().ls(t,value);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommandConstString - MIPS\n");
		//sir_MIPS_a_lot.getInstance().li(t,value);
	}
}
