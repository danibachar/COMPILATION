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

public class IRcommand_Assign_Global_Var_Const_Value extends IRcommand
{
	String name;
	String value;

	public IRcommand_Assign_Global_Var_Const_Value(String name, String value)
	{
		this.value = value;
		this.name = name;
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		LLVM.getInstance().assign_global_string_var_const_value(name, value);
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		// sir_MIPS_a_lot.getInstance().li(t,value);
	}
}
