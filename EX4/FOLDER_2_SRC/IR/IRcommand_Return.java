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
import TYPES.*;
import LLVM.*;
import MIPS.*;

public class IRcommand_Return extends IRcommand
{

	TEMP retVal;
	
	public IRcommand_Return(TEMP retVal)
	{
		this.retVal = retVal;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().returnFunc(retVal);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
