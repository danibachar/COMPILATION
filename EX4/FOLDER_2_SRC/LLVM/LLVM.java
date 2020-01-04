/***********/
/* PACKAGE */
/***********/
package LLVM;

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
import IR.*;
import MIPS.*;
import AST.*;

/********/
/* LLVM */
/********/
public class LLVM
{
	private int WORD_SIZE=4;

	/***********************/
	/* The file writer ... */
	/***********************/
	public PrintWriter fileWriter;

	public void finalizeFile()
	{
		// fileWriter.format("  ret i32 0\n");
		// fileWriter.format("}\n");
		fileWriter.close();
	}

	// MARK: - Function
	public void print_open_func(
		String func_name,
		String params_string,
		String returnType
	) {
		//EXAMPLES:
		// define i32 @goo(i32, i32) #0 { // int
		// define i8* @goo(i32, i32) #0 { // string / char*
		if (func_name.equals("main")) {
			init_global_vars();
		}

		System.out.format("@@@@ LLVM - print_open_func %s(%s) -> %s \n",func_name, params_string, returnType);
		if (params_string == null || params_string.isEmpty()) {
			fileWriter.format("define %s @%s() #0 {\n", returnType, func_name);
		} else {
				fileWriter.format("define %s @%s(%s) #0 {\n", returnType, func_name, params_string);
		}
		if (func_name.equals("main")) {
			call_init_global_vars();
		}
	}

	public void print_close_func(
		TEMP t,
		String return_type,
		String return_label,
		String src_type,
		String dst_type,
		int align

	) {
		System.out.format("@@@@ LLVM - print_close_func(%s, %s), src_type = %s, dst_type = %s\n",t, return_type, src_type,dst_type);
		// We decalr the return label, anyone who whishes ot eraly return can jump here!
		if (return_label != null && !return_label.isEmpty()) {
				jump(return_label);
				label(return_label);
		}

		if (t == null || return_type.equals("void") || src_type.equals("void")) {
			fileWriter.format("  ret void\n");

		} else {
			System.out.format("$$#$$#$#$#$ LLVM - print_close_func(%s, %s), src_type = %s, dst_type = %s\n",t, return_type, src_type,dst_type);
			// Examples:
			// %19 = load i32, i32* %3, align 4
			TEMP ret_val = TEMP_FACTORY.getInstance().getFreshTEMP();
			// ERROR type to string
			load_from_temp(ret_val, t, src_type, dst_type, align);

			int idx=ret_val.getSerialNumber();
			fileWriter.format("  ret %s %%Temp_%d\n",return_type, idx);
		}

		fileWriter.format("}\n");
	}

	 public void call_func(
		 String func_name,
		 String params_string,
		 String return_type,
		 TEMP ret_ptr,
		 int scope
	 ) {
		 System.out.format("@@@@ LLVM - call_func(%s):%s\nParams:(%s)\n", func_name, return_type, params_string);
 		//EXAMPLES:
		// call void @foo(i32 %3, i32 %4)
		// %2 = call i8* @goo(i32 11, i32 12) //strings and classes
		// %2 = call i32 @goo(i32 11, i32 12) // int maybe arrays?
		// %2 = call i32* @goo(i32 11, i32 12) // maybe arrays?
		if (return_type == null || return_type.equals("void")) {
				fileWriter.format("  call void @%s(%s) \n", func_name, params_string);
				return;
		}
		int idx=ret_ptr.getSerialNumber();
		fileWriter.format("  %%Temp_%d = call %s @%s(%s) \n", idx, return_type, func_name, params_string);

	 }

	public void allocate_local(TEMP t, String ptr, String ptr_init_val, int align, int scope)
	{
		System.out.format("@@@@ LLVM - allocate_local \n");
		int idx = t.getSerialNumber();
		fileWriter.format("  %%Temp_%d = alloca %s, align %d\n",idx, ptr, align);
	}

	public void allocate_global(String var_name, String ptr, String ptr_init_val, int align, int scope)
	{
		System.out.format("@@@@ LLVM - allocate_global(%s):\n",var_name);
		fileWriter.format("@%s = global %s %s, align %s\n",var_name, ptr, ptr_init_val, align);
	}

	public void load_from_temp(TEMP dst, TEMP src, String src_type, String dst_type, int align)
	{
		int idxdst = dst.getSerialNumber();
		int idxsrc = src.getSerialNumber();
		System.out.format("@@@@ LLVM - load_from_temp -> %%Temp_%d to -> %%Temp_%d\n",idxsrc, idxdst);
		fileWriter.format("  %%Temp_%d = load %s, %s %%Temp_%d, align %d\n",idxdst, src_type, dst_type, idxsrc, align);
	}

	public void load_from_var(TEMP dst, String var_name, String src_type, String dst_type, int align)
	{
		// Load Examples:
	 	// 	%1 = load i8*, i8** @y, align 8 // global
		//	%14 = load i8*, i8** %4, align 8 // local/temp
		System.out.format("@@@@ LLVM - load_from_var  -> %s to -> %%Temp_%d\n",var_name, dst.getSerialNumber());
		int idxdst=dst.getSerialNumber();
		fileWriter.format("  %%Temp_%d = load %s, %s @%s, align %d\n",idxdst, src_type, dst_type, var_name, align);
	}

	public void store_to_temp(TEMP dst, TEMP src, String src_type, String dst_type, int align)
	{
		int idxdst = dst.getSerialNumber();
		int idxsrc = src.getSerialNumber();
		System.out.format("@@@@ LLVM - store_to_temp %%Temp_%d to -> %%Temp_%d\n",idxsrc, idxdst);
		fileWriter.format("  store %s %%Temp_%d, %s %%Temp_%d, align %d\n",src_type,idxsrc, dst_type,idxdst, align);

		// fileWriter.format("  %%Temp_%d = load i32, i32* %%Temp_%d, align 4\n",idxdst, idxsrc);
	}
	public void store_to_var_string(String var_name,TEMP src, String value, String src_type, String dst_type, int align)
	{
		int idxsrc=src.getSerialNumber();
		System.out.format("@@@@ LLVM - store_to_var_string %s to -> %%Temp_%d\n",var_name, idxsrc);
		int size = value.length()+1;
		fileWriter.format("  store %s getelementptr inbounds ([%d x i8], [%d x i8]* @%s, i32 0, i32 0), i8** %%Temp_%d, align %d\n",src_type, size, size, var_name, idxsrc ,align);
	}
	public void store_to_var(String var_name,TEMP src, String src_type, String dst_type, int align)
	{
		// Exmpales;
		// Store from global var init
		// store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0), i8** %1, align 8
		// store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @STR.AAA, i32 0, i32 0), i8** @STR.AAA.VAR, align 8
		// store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.VAR, i32 0, i32 0), i8** %Temp_0, align 8
		int idxsrc=src.getSerialNumber();
		System.out.format("@@@@ LLVM - store_to_var %s to -> %%Temp_%d\n",var_name, idxsrc);
		fileWriter.format("  store %s %%Temp_%d, %s @%s, align %d\n",src_type, idxsrc,dst_type, var_name,align);
	}

	public void store(String var_name,TEMP src, int scope)
	{
		System.out.format("@@@@ LLVM - store from -> %%Temp_%d to -> %s \n", src.getSerialNumber(), var_name);
		// global
		int idxsrc=src.getSerialNumber();
		TEMP t = TEMP_FACTORY.getInstance().findVarRecursive(var_name, scope);

		if (scope == 0 || t == null) {
			fileWriter.format("  store i32 %%Temp_%d, i32* @%s, align 4\n",idxsrc, var_name);
			return;
		}
		// Local
		int idxdst = t.getSerialNumber();
		fileWriter.format("  store i32 %%Temp_%d, i32* %%Temp_%d, align 4\n",idxsrc, idxdst);
	}

	public void store_func_param(TEMP dst, Integer src)
	{
		int idxdst = dst.getSerialNumber();
		System.out.format("@@@@ LLVM - store_func_param:(%s) -> (%s)\n",src,idxdst);
		fileWriter.format("  store i32 %%%d, i32* %%Temp_%d, align 4\n",src, idxdst);
	}


	static int x=0;
	public void li(TEMP t,int value)
	{
		System.out.format("@@@@ LLVM - li\n");
		int idx=t.getSerialNumber();

		fileWriter.format("  %%zero_%d = load i32, i32* @my_zero, align 4\n",x);
		fileWriter.format("  %%Temp_%d = add nsw i32 %%zero_%d, %d\n",idx,x++,value);
	}

	public void constify(String name, String value) {
		value = value.replace("\"", "");
		System.out.format("@@@@ LLVM - constify - %s = %s\n",name,value);
		// Example:
		// @STR.AAA = constant [4 x i8] c"AAA\00", align 1

		int len = value.length()+1;

		fileWriter.format("@%s = constant [%d x i8] c\"%s\\00\", align 1\n", name+".VAR",len,value);
	}

	public void stringify(String name, String value)
	{
		value = value.replace("\"", "");
		System.out.format("@@@@ LLVM - stringify- %s = %s\n",name,value);
		// int idx=dst.getSerialNumber();
		// Examples:
		// store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @STR.BBB, i32 0, i32 0), i8** @STR.BBB.VAR, align 8
		// VARIABLES
		// 1) @STR.BBB
		// 2) @STR.BBB.VAR

		// 3) len
		int len = value.length()+1;
		fileWriter.format("  store i8* getelementptr inbounds ([%d x i8], [%d x i8]* @%s, i32 0, i32 0), i8** @%s, align 8\n", len, len, name+".VAR",name );
	}

	public void add(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		System.out.format("@@@@ LLVM - add\n");
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("  %%Temp_%d = add nsw i32 %%Temp_%d, %%Temp_%d\n",dstidx,i1,i2);
	}
	public void sub(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		System.out.format("@@@@ LLVM - sub\n");
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("  %%Temp_%d = sub nsw i32 %%Temp_%d, %%Temp_%d\n",dstidx,i1,i2);
	}
	public void mul(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		System.out.format("@@@@ LLVM - mul\n");
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("  %%Temp_%d = mul nsw i32 %%Temp_%d, %%Temp_%d\n", dstidx,i1,i2);
	}
	public void div(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		System.out.format("@@@@ LLVM - div\n");
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("  %%Temp_%d = sdiv i32 %%Temp_%d, %%Temp_%d\n",dstidx,i1,i2);
	}
	public void icmp_lt(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		System.out.format("@@@@ LLVM - icmp_lt\n");
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("  %%oren_%d = icmp slt i32 %%Temp_%d, %%Temp_%d\n",dstidx,i1,i2);
		fileWriter.format("  %%Temp_%d = zext i1 %%oren_%d to i32\n",dstidx,dstidx);
	}
	public void icmp_eq(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		System.out.format("@@@@ LLVM - icmp_eq\n");
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("  %%oren_%d = icmp eq i32 %%Temp_%d, %%Temp_%d\n",dstidx,i1,i2);
		fileWriter.format("  %%Temp_%d = zext i1 %%oren_%d to i32\n",dstidx,dstidx);
		// fileWriter.format("  %%Temp_%d = icmp eq i32 %%Temp_%d, %%Temp_%d\n",dstidx,i1,i2);
	}
	private void bit_code_globals(Pair<String, AST_EXP> pair) {
		System.out.format("@@@@ LLVM - globalVarsInitCommands\n");
		AST_EXP exp = pair.getValue();
		if (exp instanceof AST_EXP_STRING) {
			AST_EXP_STRING e = (AST_EXP_STRING)exp;
			stringify(pair.getKey(), e.value);
		} else {
			try {
				IR.getInstance().auto_exec_mode = true;
				store(pair.getKey(), pair.getValue().IRme(), 0);// 0 as we are in global scope
				IR.getInstance().auto_exec_mode = false;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.format("!!!! ERROR LLVM - bit_code_globals\n");
			}
		}

	}
	private boolean is_string_exp(AST_EXP e) {
		return (e instanceof AST_EXP_STRING);
	}

	// private void print_copy_const_str_to_var_str(Pair<String, AST_EXP> pair) {
	// 	if (!is_string_exp(pair.getValue())) {
	// 		return;
	// 	}
	// 	AST_EXP_STRING e = (AST_EXP_STRING)pair.getValue();
	// 	stringify(pair.getKey(), e.value);
	// }

	private void init_global_vars() {
			// Declare func
		print_open_func("init_globals", "", "void");
		// init all globals (int, string, array, class)
		// STRINGS
		// IR.getInstance()
		// 	.globalVarsInitCommands
		// 	.forEach((nameExpTuple) -> print_copy_const_str_to_var_str(nameExpTuple));
		// REST
		IR.getInstance()
			.globalVarsInitCommands
			.forEach((nameExpTuple) -> bit_code_globals(nameExpTuple));
		print_close_func(null, "void", null, null, null, 4);
	}

	private void call_init_global_vars() {
		fileWriter.format("  call void @init_globals()\n");
	}

	private void init_main() {
		System.out.format("@@@@ LLVM - label(main):\n");
		fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;\n");
		fileWriter.format(";                     ;\n");
		fileWriter.format("; ENTRY POINT :: main ;\n");
		fileWriter.format(";                     ;\n");
		fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;\n");
		fileWriter.format("define dso_local i32 @main(i32 %%argc, i8** %%argv) {\n");
		fileWriter.format("entry:\n");
		fileWriter.format("  %%retval = alloca i32, align 4\n");
		fileWriter.format("  %%argc.addr = alloca i32, align 4\n");
		fileWriter.format("  %%argv.addr = alloca i8**, align 8\n");
		fileWriter.format("  store i32 0, i32* %%retval, align 4\n");
		fileWriter.format("  store i32 %%argc, i32* %%argc.addr, align 4\n");
		fileWriter.format("  store i8** %%argv, i8*** %%argv.addr, align 8\n");
		// Init Global Vars
		call_init_global_vars();
		// %Temp_13 = call i32 @init_strings()
		fileWriter.format("  br label %%main_body\n");
		fileWriter.format("\nmain_body:\n\n");
	}

	public void label(String inlabel)
	{
		if (inlabel.equals("main")) {
			init_main();
		} else {
			fileWriter.format("\n%s:\n\n",inlabel);
		}
	}
	public void jump(String inlabel)
	{
		fileWriter.format("  br label %%%s\n",inlabel);
	}
	public void blt(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		fileWriter.format("  %%oren = icmp slt i32 %%Temp_%d, 0\n",i1);
		// %Temp_33 = zext i1 %Temp_14 to i32
		// fileWriter.format("  %%oren = zext i1 %%temp_oren to i32\n",i1);
		fileWriter.format("  br i1 %%oren, label %%%s, label %%any.label_%d\n",label,x);
		fileWriter.format("  \nany.label_%d:\n\n",x++);
	}
	public void bge(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("  %%oren = icmp sge i32 %%Temp_%d, 0\n",i1);
		fileWriter.format("  br i1 %%oren, label %%%s, label %%any.label_%d\n",label,x);
		fileWriter.format("  \nany.label_%d:\n\n",x++);
	}
	public void bne(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("  %%oren = icmp ne i32 %%Temp_%d, 0\n",i1);
		fileWriter.format("  br i1 %%oren, label %%%s, label %%any.label_%d\n",label,x);
		fileWriter.format("  \nany.label_%d:\n\n",x++);
	}
	public void beq(TEMP oprnd1,TEMP oprnd2,String label)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();

		fileWriter.format("  %%oren = icmp eq i32 %%Temp_%d, 0\n",i1);
		fileWriter.format("  br i1 %%oren, label %%%s, label %%any.label_%d\n",label,x);
		fileWriter.format("  \nany.label_%d:\n\n",x++);
	}
	public void beqz(TEMP oprnd1,String label1,String label2)
	{
		int i1 = oprnd1.getSerialNumber();

		fileWriter.format("  %%equal_zero_%d = icmp eq i32 %%Temp_%d, 0\n",x,i1);
		fileWriter.format("  br i1 %%equal_zero_%d, label %%%s, label %%%s\n",x,label1,label2);
		fileWriter.format("  \n%s:\n\n",label2);
		x++;
	}

	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static LLVM instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	private LLVM() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static LLVM getInstance()
	{
		if (instance == null)
		{
			instance = new LLVM();

			/****************************/
			/* Initialize a file writer */
			/****************************/
			// try
			// {
			// 	String dirname="./FOLDER_5_OUTPUT/";
			// 	String filename="LLVM_bitcode.ll";
			// 	assert(false);
			// 	instance.fileWriter = new PrintWriter(dirname+filename);
			// }
			// catch (Exception e)
			// {
			// 	e.printStackTrace();
			// }

		}
		return instance;
	}

	public void bootStrapProgram() {
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format(";                         ;\n");
		instance.fileWriter.format("; GLOBAL VARIABLE :: zero ;\n");
		instance.fileWriter.format(";                         ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format("@my_zero = global i32 0, align 4\n\n");

		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format(";                         ;\n");
		instance.fileWriter.format("; EXTERNAL LIBRARY FUNCS ;\n");
		instance.fileWriter.format(";                         ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format("declare i32* @malloc(i32)\n");
		instance.fileWriter.format("declare i32 @strcmp(i8*, i8*)\n");
		// instance.fileWriter.format("declare i32 @printf(i8*, ...)\n");
		instance.fileWriter.format("declare void @exit(i32)\n");

		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format(";                         ;\n");
		instance.fileWriter.format("; printf parameters       ;\n");
		instance.fileWriter.format(";                         ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format("@INT_FORMAT = constant [4 x i8] c\"%%d\\0A\\00\", align 1\n");
		instance.fileWriter.format("@STR_FORMAT = constant [4 x i8] c\"%%s\\0A\\00\", align 1\n");

		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format(";                                 ;\n");
		instance.fileWriter.format("; LIBRARY FUNCTION :: PrintString ;\n");
		instance.fileWriter.format(";                                 ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format("define void @PrintString(i8* %%s) {\n");
		instance.fileWriter.format("entry:\n");
		instance.fileWriter.format("  %%s.addr = alloca i8*, align 4\n");
		instance.fileWriter.format("  store i8* %%s, i8** %%s.addr, align 4\n");
		instance.fileWriter.format("  %%0 = load i8*, i8** %%s.addr, align 4\n");
		instance.fileWriter.format("  %%call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @STR_FORMAT, i32 0, i32 0), i8* %%0)\n");
		instance.fileWriter.format("  ret void\n");
		instance.fileWriter.format("}\n");
		instance.fileWriter.format("\n");

		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format(";                              ;\n");
		instance.fileWriter.format("; LIBRARY FUNCTION :: PrintInt ;\n");
		instance.fileWriter.format(";                              ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format("define dso_local void @PrintInt(i32 %%i) {\n");
		instance.fileWriter.format("entry:\n");
		instance.fileWriter.format("  %%i.addr = alloca i32, align 4\n");
		instance.fileWriter.format("  store i32 %%i, i32* %%i.addr, align 4\n");
		instance.fileWriter.format("  %%0 = load i32, i32* %%i.addr, align 4\n");
		instance.fileWriter.format("  %%call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %%0)\n");
		instance.fileWriter.format("  ret void\n");
		instance.fileWriter.format("}\n");
		instance.fileWriter.format("\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		instance.fileWriter.format(";                            ;\n");
		instance.fileWriter.format("; STDANDRD LIBRARY :: printf ;\n");
		instance.fileWriter.format(";                            ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
		//instance.fileWriter.format("@.str = private unnamed_addr constant [4 x i8] c\"%d \00\", align 1\n");
		instance.fileWriter.format("@.str = private unnamed_addr constant [4 x i8] c\"%%d \\00\", align 1\n");
		instance.fileWriter.format("declare dso_local i32 @printf(i8*, ...)\n\n");

		// Descirbing of new global variables that are configured within the program
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;:;\n");
		instance.fileWriter.format(";                  ;\n");
		instance.fileWriter.format("; GLOBAL VARIABLES ;\n");
		instance.fileWriter.format(";                  ;\n");
		instance.fileWriter.format(";;;;;;;;;;;;;;;;;;:;\n");

		// ;;;;;;;;;;;;;;;;;;
		// ;                ;
		// ; ACTUAL STRINGS ;
		// ;                ;
		// ;;;;;;;;;;;;;;;;;;
		// @STR.ACCESS.VIOLATION = constant [17 x i8] c"access violation\00", align 1
		//
		// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		// ;                                 ;
		// ; i8* wrappers for actual strings ;
		// ;                                 ;
		// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		// @STR.ACCESS.VIOLATION.VAR = global i8* null, align 8

		// define void @access_violation () {
		// entry:
		//   %Temp_91 = load i8*, i8** @STR.ACCESS.VIOLATION.VAR, align 8
		//   call void @PrintString(i8* %Temp_91)
		//   call void @exit(i32 0)
		//   ret void
		// }
		//
		// ;;;;;;;;;;;;;;;;
		// ;              ;
		// ; init strings ;
		// ;              ;
		// ;;;;;;;;;;;;;;;;
		// define i32 @init_strings() {
		//   store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @STR.ACCESS.VIOLATION, i32 0, i32 0), i8** @STR.ACCESS.VIOLATION.VAR, align 8
		//   ret i32 0
		// }
	}
}
