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

public class IRcommand_Define_Func extends IRcommand
{
	String funcName;
	TYPE returnType;
	TYPE_LIST args;

	public IRcommand_Define_Func(String funcName,TYPE returnType, TYPE_LIST args)
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
		LLVM.getInstance().define_func(funcName, returnType, args);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		System.out.format("IRcommand_Define_Func - MIPS\n");
		sir_MIPS_a_lot.getInstance().define_func(funcName, returnType, args);
	}
}
