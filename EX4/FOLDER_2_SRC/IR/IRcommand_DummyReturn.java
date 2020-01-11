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

public class IRcommand_DummyReturn extends IRcommand
{

	TYPE type;
	
	public IRcommand_DummyReturn(TYPE type)
	{
		this.type = type;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().dummyRet(type);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
