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

public class IRcommand_Define_Func_end extends IRcommand
{
	String funcName;
	TYPE returnType;
	TYPE_LIST args;
	
	public IRcommand_Define_Func_end(String funcName,TYPE returnType, TYPE_LIST args)
	{
		this.funcName      = funcName;
		this.returnType = returnType;
		this.args = args;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().define_func_end();
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
