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

public class IRcommand_Store_Local_String extends IRcommand
{
	int varIndex;
	String src;

	public IRcommand_Store_Local_String(int varIndex,String src)
	{
		this.src      = src;
		this.varIndex = varIndex;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().store_string_local(varIndex,src);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Store_Local_String - MIPS\n");
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
