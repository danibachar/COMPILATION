/***********/
/* PACKAGE */
/***********/
package MIPS;

import java.io.*;
import java.util.*;
import Pair.*;
import java.util.Iterator;
import java.util.Hashtable;
import java.util.HashMap;
import java.util.Set;
import java.io.PrintWriter;


/*******************/
/* PROJECT IMPORTS */
/*******************/
import TEMP.*;
import AST.*;
import TYPES.*;

public class sir_MIPS_a_lot
{
	private int WORD_SIZE=4;
	/***********************/
	/* The file writer ... */
	/***********************/
	private PrintWriter fileWriter;
	private static String filename = "";
	public static HashSet<String> strings = new HashSet<String>();
	public static HashMap<String, AST_EXP> _globals = new HashMap<>();
	public static ArrayList<Pair<String, AST_EXP>> globals = new ArrayList<Pair<String, AST_EXP>>();

	private static final String INDENTATION = "\t";
	private static final String NEWLINE = "\n";
	// private static final int SIZE = IRContext.PRIMITIVE_DATA_SIZE;
	private static final int REGISTERS_COUNT = 8;
	private static final int COLORING_OFFSET = 8;
	// private static final int REGISTERS_BACKUP_SIZE = REGISTERS_COUNT * SIZE;
	// private static final int SKIP_SIZE = 2 * SIZE;
	// registers
	private static final int $0 = 0;
	private static final int $v0 = 2;
	private static final int $a0 = 4;
	private static final int $a3 = 7;
	private static final int $t0 = 8;
	private static final int $t1 = 9;
	private static final int $t2 = 10;
	private static final int $t8 = 24;
	private static final int $t9 = 25;
	private static final int $sp = 29;
	private static final int $fp = 30;
	private static final int $ra = 31;
	// syscalls
	private static final int SYSCALL_PRINT_INT = 1;
	private static final int SYSCALL_PRINT_STRING = 4;
	private static final int SYSCALL_SBRK = 9;
	private static final int SYSCALL_EXIT = 10;
	private static final int SYSCALL_PRINT_CHAR = 11;
	private static final Map<Integer, String> registerNames = new HashMap<>();
	// private static final IRLabel STRING_EQUALS_LABEL = new IRLabel("__string_equality__");
	// private static final IRLabel STRING_CONCAT_LABEL = new IRLabel("__string_concat__");
	// private static final IRLabel FUNCTION_NAMES = new IRLabel("FUNCTION_NAMES");
	private static final String FUNCTION_NAME_PREFIX = "FUNCTION_NAME_";
	private static final String MAIN_LABEL = "main";

	private StringBuilder dataSection = new StringBuilder();
	private StringBuilder codeSection = new StringBuilder();
	// private Map<Register, IRLabel> globals = new HashMap<>();
	private Map<String, Integer> functionIds = new HashMap<>();
	private int functionIdCounter = 0;
	// private Map<Register, Integer> realRegMapsRegisters;
	// private Map<LocalRegister, Integer> localsAsReal;
	private int parametersCount;
	private int localsCount;
	private int boundedLabelCounter = 0;

	public static void setFileName(String fileName)
	{
		filename = fileName;
	}

	public void initRegisters() {
		registerNames.put($0, "$0");
		registerNames.put($a0, "$a0");
		registerNames.put($a3, "$a3");
		registerNames.put($v0, "$v0");
		registerNames.put($t0, "$t0");
		registerNames.put($t1, "$t1");
		registerNames.put($t2, "$t2");
		registerNames.put($t8, "$t8");
		registerNames.put($t9, "$t9");
		registerNames.put($sp, "$sp");
		registerNames.put($fp, "$fp");
		registerNames.put($ra, "$ra");
		for (int i = 0; i < REGISTERS_COUNT; i++) {
				registerNames.put(COLORING_OFFSET + i, "$t" + i);
		}
	}

	public static void addString(String value)
	{
		strings.add(value);
	}

	public static void addGlobal(String name, AST_EXP exp)
	{
		if (_globals.get(name) != null) {
			return;
		}
		Pair<String, AST_EXP> p = new Pair(name, exp);
		globals.add(p);
	}

	private String name(int reg) {
			return registerNames.get(reg);
	}

	/***********************/
	/* The file writer ... */
	/***********************/
	public void finalizeFile()
	{
		fileWriter.print("\tli $v0,10\n");
		fileWriter.print("\tsyscall\n");
		fileWriter.close();
	}
	public void print_int(TEMP t)
	{
		int idx=t.getSerialNumber();
		// fileWriter.format("\taddi $a0,Temp_%d,0\n",idx);
		fileWriter.format("\tmove $a0,Temp_%d\n",idx);
		fileWriter.format("\tli $v0,1\n");
		fileWriter.format("\tsyscall\n");
		fileWriter.format("\tli $a0,32\n");
		fileWriter.format("\tli $v0,11\n");
		fileWriter.format("\tsyscall\n");
	}
	//public TEMP addressLocalVar(int serialLocalVarNum)
	//{
	//	TEMP t  = TEMP_FACTORY.getInstance().getFreshTEMP();
	//	int idx = t.getSerialNumber();
	//
	//	fileWriter.format("\taddi Temp_%d,$fp,%d\n",idx,-serialLocalVarNum*WORD_SIZE);
	//
	//	return t;
	//}
	public void allocate(String var_name)
	{
		fileWriter.format(".data\n");
		fileWriter.format("\tglobal_%s: .word 721\n",var_name);
	}
	public void load(TEMP dst,String var_name)
	{
		int idxdst=dst.getSerialNumber();
		fileWriter.format("\tlw Temp_%d,global_%s\n",idxdst,var_name);
	}
	public void store(String var_name,TEMP src)
	{
		int idxsrc=src.getSerialNumber();
		fileWriter.format("\tsw Temp_%d,global_%s\n",idxsrc,var_name);
	}
	public void li(TEMP t,int value)
	{
		int idx=t.getSerialNumber();
		fileWriter.format("\tli Temp_%d,%d\n",idx,value);
	}
	public void add(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("\tadd Temp_%d,Temp_%d,Temp_%d\n",dstidx,i1,i2);
	}
	public void mul(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("\tmul Temp_%d,Temp_%d,Temp_%d\n",dstidx,i1,i2);
	}
	public void label(String inlabel)
	{
		if (inlabel.equals("main"))
		{
			fileWriter.format(".text\n");
			fileWriter.format("%s:\n",inlabel);
		}
		else
		{
			fileWriter.format("%s:\n",inlabel);
		}
	}
	public void jump(String inlabel)
	{
		fileWriter.format("\tj %s\n",inlabel);
	}
	public void blt(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("\tblt Temp_%d,Temp_%d,%s\n",i1,i2,label);
	}
	public void bge(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("\tbge Temp_%d,Temp_%d,%s\n",i1,i2,label);
	}
	public void bne(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("\tbne Temp_%d,Temp_%d,%s\n",i1,i2,label);
	}
	public void beq(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("\tbeq Temp_%d,Temp_%d,%s\n",i1,i2,label);
	}
	public void beqz(TEMP oprnd1,String label)
	{
		int i1 =oprnd1.getSerialNumber();

		fileWriter.format("\tbeq Temp_%d,$zero,%s\n",i1,label);
	}

	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static sir_MIPS_a_lot instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	protected sir_MIPS_a_lot() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static sir_MIPS_a_lot getInstance()
	{
		if (instance == null)
		{
			/*******************************/
			/* [0] The instance itself ... */
			/*******************************/
			instance = new sir_MIPS_a_lot();

			try
			{
				/*********************************************************************************/
				/* [1] Open the MIPS text file and write data section with error message strings */
				/*********************************************************************************/
				// String dirname="./FOLDER_5_OUTPUT/";
				// String filename=String.format("MIPS.txt");

				/***************************************/
				/* [2] Open MIPS text file for writing */
				/***************************************/
				instance.fileWriter = new PrintWriter(filename);
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}

			// Init registers
			instance.initRegisters();

			/*****************************************************/
			/* [3] Print data section with error message strings */
			/*****************************************************/
			instance.fileWriter.print(".data\n");
			instance.fileWriter.print("string_access_violation: .asciiz \"Access Violation\"\n");
			instance.fileWriter.print("string_illegal_div_by_0: .asciiz \"Illegal Division By Zero\"\n");
			instance.fileWriter.print("string_invalid_ptr_dref: .asciiz \"Invalid Pointer Dereference\"\n");
		}
		return instance;
	}
}
