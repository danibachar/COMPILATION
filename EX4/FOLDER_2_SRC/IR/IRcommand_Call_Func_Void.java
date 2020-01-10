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

public class IRcommand_Call_Func_Void extends IRcommand
{
	String funcName;
	TYPE returnType;
	TEMP_LIST args;
	TYPE_LIST types;
	
	public IRcommand_Call_Func_Void(String funcName,TYPE returnType, TEMP_LIST args, TYPE_LIST types)
	{
		this.funcName      = funcName;
		this.returnType = returnType;
		this.args = args;
		this.types = types;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().call_func_void(funcName, returnType, args, types);
	}
	
	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		//sir_MIPS_a_lot.getInstance().store(var_name,src);
	}
}
