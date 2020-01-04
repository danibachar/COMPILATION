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

public class IRcommandTempString extends IRcommand
{
	String name;
	String value;

	public IRcommandTempString(String name, String value)
	{
		this.value = value;
		this.name = name;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().stringify(name, value);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().li(t,value);
	}
}
