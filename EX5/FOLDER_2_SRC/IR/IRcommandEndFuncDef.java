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

public class IRcommandEndFuncDef extends IRcommand
{
	String funcName;
	TYPE returnType;
	TYPE_LIST args;

	public IRcommandEndFuncDef(String funcName,TYPE returnType, TYPE_LIST args)
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
		LLVM.getInstance().end_func();
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommandEndFuncDef - MIPS\n");
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
