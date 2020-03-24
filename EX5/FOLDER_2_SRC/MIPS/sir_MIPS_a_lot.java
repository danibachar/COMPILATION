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

/* Some notes
	Got help from - https://courses.cs.washington.edu/courses/cse378/09wi/lectures/lec05.pdf
*/

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
	private static final int SIZE = 4;
	private static final int REGISTERS_COUNT = 8;
	private static final int COLORING_OFFSET = 8;
	private static final int REGISTERS_BACKUP_SIZE = REGISTERS_COUNT * SIZE;
	private static final int SKIP_SIZE = 2 * SIZE;

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

	private static final String FUNCTION_NAME_PREFIX = "FUNCTION_NAME_";
	private static final String MAIN_LABEL = "main";


	private Map<String, Integer> functionIds = new HashMap<>();
	private int functionIdCounter = 0;

	private int parametersCount;
	private int localsCount;
	private int boundedLabelCounter = 0;

	public static void setFileName(String fileName)
	{
		filename = fileName;
	}

	public void initRegisters() {
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

	// private void generateFunctionHeader(IRLabel label, int parameters, int locals, int functionId)
	public void define_func(String name, TYPE returnType, TYPE_LIST args)
	{


		int locals = 1;
		int parameters = 0;
		int functionId = 100;

		label(name);


    for (int i = 0; i < REGISTERS_COUNT; i++) {
        push(COLORING_OFFSET + i);
    }
    push($fp);
    push($ra);

		// FP
		move($fp, $sp);

		if (locals - localsAsReal.size() > 0) {
				for (int i = 0; i < locals - localsAsReal.size(); i++) {
						pushConst(0);
				}
		}

    pushConst(0);
    localsAsReal.forEach((local, realReg) -> constant(realReg, 0));

    // push function id and header size
    pushConst(functionId);
    pushConst((parameters + 2 + locals + 3 - localsAsReal.size()) * SIZE + REGISTERS_BACKUP_SIZE);
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
		syscall();
	}

	// Grrrrr

	private void push(int register) {
			selfAddConst($sp, -SIZE);
			storeToMemory($sp, register);
	}

	private void pushConst(int constant) {
			selfAddConst($sp, -SIZE);
			constant($t8, constant);
			storeToMemory($sp, $t8);
	}

	private void pop(int register) {
			loadFromMemory(register, $sp);
			selfAddConst($sp, SIZE);
	}

	private void syscall() {
		fileWriter.format("\tsyscall\n");
	}

	private void syscallPrintString(String label) {
			loadAddress($a0, label);
			constant($v0, SYSCALL_PRINT_STRING);
			syscall();
	}

	private void syscallExit() {
			constant($v0, SYSCALL_EXIT);
			syscall();
	}

	private void syscallPrintChar(char c) {
			constant($a0, (int) c);
			constant($v0, SYSCALL_PRINT_CHAR);
			syscall();
	}

	private void move(int to, int from) {
		fileWriter.format("\tmove %s, %s\n",name(to), name(from));
	}

	public void jump(String inlabel) {
		fileWriter.format("\tj %s\n",inlabel);
	}

	public void jumpRegister(int reg) {
		fileWriter.format("\tjr %s\n", name(reg));
	}

	public void jumpRegisterAndLink(int reg) {
		fileWriter.format("\tjalr %s\n", name(reg));
	}

	public void jumpAndLink(String label) {
		fileWriter.format("\tjal %s\n", label);
	}

	public void branchNotEqual(int reg1, int reg2, String label) {
		fileWriter.format("\tbne %s, %s, %s\n", name(reg1), name(reg2), label);
	}

	public void branchEqual(int reg1, int reg2, String label) {
		fileWriter.format("\tbeq %s, %s, %s\n", name(reg1), name(reg2), label);
	}

	private void selfAddConst(int reg, int constant) {
			addConst(reg, reg, constant);
	}

	private void addConst(int dest, int reg, int constant) {
			if (constant != 0) {
					fileWriter.format("\taddi %s, %s, %d\n", name(dest), name(reg), constant);
			} else if (dest != reg) {
					move(dest, reg);
			}

	}

	private void loadAddress(int dest, String label) {
		fileWriter.format("\tla %s, %s\n", name(dest), label);
	}

	private void loadByteFromMemory(int dest, int memRegister) {
		fileWriter.format("\tlb %s,(%s)\n", name(dest), name(memRegister));
	}

	private void storeByteToMemory(int memoryDest, int reg) {
		fileWriter.format("\tsb %s,(%s)\n", name(reg), name(memoryDest));
	}

	private void loadFromMemory(int dest, int memRegister) {
		fileWriter.format("\tlw %s,(%s)\n", name(dest), name(memRegister));
	}

	private void loadFromMemory(int dest, String label) {
		fileWriter.format("\tlw %s, %s\n", name(dest), label);
	}

	private void storeToMemory(int memoryDest, int reg) {
		fileWriter.format("\tsw %s,(%s)\n", name(reg), name(memoryDest));
	}

	private void storeToMemory(int memoryDest, String label) {
		fileWriter.format("\tlw %s, %s\n", name(memoryDest), label);
	}

	private void constant(int reg, int constant) {
		if (constant == 0) {
				move(reg, $0);
		} else {
			fileWriter.format("\taddi %s, %s, %d\n", name(reg), name($0), constant);
		}
}

	// Grrrrr

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
