/***********/
/* PACKAGE */
/***********/
package IR;

/*******************/
/* GENERAL IMPORTS */
/*******************/
import java.io.*;
import java.io.PrintWriter;
import java.util.*;
import javafx.util.Pair;
/*******************/
/* PROJECT IMPORTS */
/*******************/
import TEMP.*;
import AST_EXCEPTION.*;
import AST.*;

public class IR
{
	private IRcommand head=null;
	private IRcommandList tail=null;

	/******************/
	/* 	IT Scoping 		*/
	/******************/
	public boolean auto_exec_mode = false;


	/******************/
	/* Add IR command */
	/******************/
	public void Add_IRcommand(IRcommand cmd) {
		if (auto_exec_mode) {
			cmd.LLVM_bitcode_me();
			return;
		}


		if ((head == null) && (tail == null))
		{
			// new , first head
			this.head = cmd;
		}
		else if ((head != null) && (tail == null))
		{
			// we have haed, init tail!
			this.tail = new IRcommandList(cmd,null);
		}
		else
		{
			//appened to tail
			IRcommandList it = tail;
			while ((it != null) && (it.tail != null))
			{
				it = it.tail;
			}
			it.tail = new IRcommandList(cmd,null);
		}
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		if (head != null) head.LLVM_bitcode_me();
		if (tail != null) tail.LLVM_bitcode_me();
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		if (head != null) head.MIPSme();
		if (tail != null) tail.MIPSme();
	}

	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static IR instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	protected IR() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static IR getInstance()
	{
		if (instance == null)
		{
			/*******************************/
			/* [0] The instance itself ... */
			/*******************************/
			instance = new IR();
		}
		return instance;
	}
}
