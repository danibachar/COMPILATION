/***********/
/* PACKAGE */
/***********/
package LLVM;

/*******************/
/* GENERAL IMPORTS */
/*******************/
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

	public static HashSet<String> strings = new HashSet<String>();
	public static HashMap<String, AST_EXP> _globals = new HashMap<>();
	public static ArrayList<Pair<String, AST_EXP>> globals = new ArrayList<Pair<String, AST_EXP>>();

	/***********************/
	/* The file writer ... */
	/***********************/
	public void finalizeFile()
	{
		fileWriter.close();
	}

	public void zext(TEMP dst, TEMP src)
	{
		int idxdst=dst.getSerialNumber();
		int idxsrc=src.getSerialNumber();
		fileWriter.format("  %%Temp_%d = zext i1 %%Temp_%d to i32\n", idxdst, idxsrc);
	}

	public void call_func(TEMP dst, String name, TYPE returnType, TEMP_LIST args, TYPE_LIST types)
	{

		fileWriter.format("%%Temp_%d =call %s @%s(",dst.getSerialNumber(), typeToString(returnType), name);
		while(types!= null){
			System.out.format("calling maybe void? function name=(%s), retType=(%s), argtype=(%s)",name,returnType,typeToString(args.head.type));
			fileWriter.format("%s %%Temp_%d ",typeToString(args.head.type), args.head.getSerialNumber());
			types = types.tail;
			args = args.tail;
			if (types != null) fileWriter.format(",");
		}

		fileWriter.format(")\n");
	}

	public void call_func_void(String name, TYPE returnType, TEMP_LIST args, TYPE_LIST types)
	{

		fileWriter.format("  call %s @%s(",typeToString(returnType), name);
		while(types!= null){
			System.out.format("calling void function name=(%s), retType=(%s), argtype=(%s)",name,returnType,typeToString(args.head.type));
			fileWriter.format("%s %%Temp_%d ",typeToString(args.head.type), args.head.getSerialNumber());
			types = types.tail;
			args = args.tail;
			if (types != null) fileWriter.format(",");
		}

		fileWriter.format(")\n");
	}

	public void define_func(String name, TYPE returnType, TYPE_LIST args)
	{
		fileWriter.format("define %s @%s(",typeToString(returnType), name);
		while(args!= null){
			fileWriter.format("%s",typeToString(args.head));
			args = args.tail;
			if (args != null) fileWriter.format(",");
		}

		fileWriter.format(")\n { \n");

	}

	public void end_func()
	{
		fileWriter.format("}\n");
	}

	public void returnFunc(TEMP retVal)
	{

		if (retVal == null){
			fileWriter.format("  ret void\n");
		}
		else {
			fileWriter.format("  ret %s %%Temp_%d\n", typeToString(retVal.getType()), retVal.getSerialNumber());
		}
	}

	public void dummyRet(TYPE type)
	{
		String ret = "0";
		if (typeToString(type).endsWith("*"))
		{
			ret = "null";
		}
		fileWriter.format("  ret %s %s\n", typeToString(type), ret);

	}

	public void allocate_global(String var_name, TYPE type)
	{
		String typeDefault = "0";
		if (typeToString(type).endsWith("*"))
		{
			typeDefault = "null";
		}
		fileWriter.format(";;;;;;;;;;;;;;;;;;;\n");
		fileWriter.format(";                 ;\n");
		fileWriter.format("; GLOBAL VARIABLE ;\n");
		fileWriter.format(";                 ;\n");
		fileWriter.format(";;;;;;;;;;;;;;;;;;;\n");
		fileWriter.format("@%s = global %s %s, align %d\n\n",var_name, typeToString(type), typeDefault, typeToAlignment(typeToString(type)));
	}
	public void allocate_local(String var_name, TYPE type)
	{
		fileWriter.format("  %%local_%s = alloca %s, align %d\n",var_name, typeToString(type), typeToAlignment(typeToString(type)));
	}
	public void allocate_param(String var_name, TYPE type)
	{
		fileWriter.format("  %%%s = alloca %s, align %d\n",var_name, typeToString(type), typeToAlignment(typeToString(type)));
	}

	public void allocate_array(TEMP dst, TEMP size, TYPE type)
	{
		fileWriter.format("  %%Temp_%d = call i32* @malloc(i32 %%Temp_%d)\n",dst.getSerialNumber(),  size.getSerialNumber());

	}

	public void bitcast_from_malloc(TEMP dst, TEMP src)
	{
		fileWriter.format("  %%Temp_%d = bitcast i32* %%Temp_%d to %s\n",
		 dst.getSerialNumber(),
		 src.getSerialNumber(),
		 typeToString(dst.getType()));

	}

	public void bitcast(TEMP dst, TEMP src)
	{
		fileWriter.format("  %%Temp_%d = bitcast %s* %%Temp_%d to %s\n",
		 dst.getSerialNumber(),
		 typeToString(src.getType()),
		 src.getSerialNumber(),
		 typeToString(dst.getType()));

	}
	public void bitcast_local(TEMP dst, int index, TYPE type)
	{
		fileWriter.format("  %%Temp_%d = bitcast %s* %%local_%d to %s*\n",
		 dst.getSerialNumber(),
		 typeToString(type),
		 index,
		 typeToString(dst.getType()));

	}
	public void bitcast_to_pointer(TEMP dst, TEMP src)
	{
		String srcType =  typeToString(src.getType());
		if (src.isaddr)
		{
			srcType = srcType + "*";
		}
		fileWriter.format("  %%Temp_%d = bitcast %s %%Temp_%d to %s*\n",
		 dst.getSerialNumber(),
		 srcType,
		 src.getSerialNumber(),
		 typeToString(dst.getType()));

	}

	public void bitcast_to_null(TEMP dst, TEMP src)
	{
		fileWriter.format("  %%Temp_%d = bitcast %s %%Temp_%d to i32*\n",
		 dst.getSerialNumber(),
		 typeToString(src.getType()),
		 src.getSerialNumber());

	}
	public void load(TEMP dst,String varName)
	{
		int idxdst=dst.getSerialNumber();
		String typeString = typeToString(dst.getType());

		fileWriter.format("  %%Temp_%d = load %s, %s* %%%s, align %d\n",
		idxdst,
		typeString,
		typeString,
		varName,
		typeToAlignment(typeString));
	}
	public void load_local(TEMP dst,int varIndex)
	{
		int idxdst=dst.getSerialNumber();
		String typeString = typeToString(dst.getType());

		fileWriter.format("  %%Temp_%d = load %s, %s* %%local_%s, align %d\n",
		idxdst,
		typeString,
		typeString,
		varIndex,
		typeToAlignment(typeString));
	}
	public void load_global(TEMP dst,String name)
	{
		int idxdst=dst.getSerialNumber();
		String typeString = typeToString(dst.getType());

		fileWriter.format("  %%Temp_%d = load %s, %s* @%s, align %d\n",
		idxdst,
		typeString,
		typeString,
		name,
		typeToAlignment(typeString));
	}
	public void load(TEMP dst,TEMP src)
	{
		fileWriter.format(";load temp temp;\n");
		if (src.checkInit)
		{
			check_init_load(dst, src);
			return;
		}

		int idxdst=dst.getSerialNumber();
		String typeString = typeToString(dst.getType());

		fileWriter.format("  %%Temp_%d = load %s, %s* %%Temp_%d, align %d\n",
		idxdst,
		typeString,
		typeString,
		src.getSerialNumber(),
		typeToAlignment(typeString));
	}
	public void store_global(String var_name,TEMP src)
	{
		int idxsrc=src.getSerialNumber();
		String typeString = typeToString(src.getType());
		fileWriter.format("  store %s %%Temp_%d, %s* @%s, align %d\n",typeString, idxsrc, typeString,var_name, typeToAlignment(typeString));
	}
	public void store(TEMP dst,TEMP src)
	{
		fileWriter.format(";store %s dst src;\n", dst.getType());

		if (dst.checkInit)
		{
			check_init_store(dst, src);
			return;
		}
		int idxsrc=src.getSerialNumber();
		String typeString = typeToString(dst.getType());
		fileWriter.format("  store %s %%Temp_%d, %s* %%Temp_%d, align %d\n",
		typeToString(src.getType()),
		idxsrc,
		typeToString(dst.getType()),
		dst.getSerialNumber(),
		typeToAlignment(typeString));
	}
	public void store_local(int varIndex,TEMP src)
	{
		if (src == null) { return;}
		String typeString = typeToString(src.getType());
		int idxsrc=src.getSerialNumber();
		fileWriter.format("  store %s %%Temp_%d, %s* %%local_%s, align %d\n",typeString, idxsrc,typeString, varIndex,typeToAlignment(typeString));
	}
	public void store_param(String paramName,TEMP src)
	{
		if (src == null) { return;}
		String typeString = typeToString(src.getType());
		int idxsrc=src.getSerialNumber();
		fileWriter.format("  store %s %%Temp_%d, %s* %%%s, align %d\n",typeString, idxsrc,typeString, paramName,typeToAlignment(typeString));
	}
	public void store_paramter(String var_name,TYPE type, int index)
	{
		String typeString = typeToString(type);
		// System.out.format("storing param  store %s %%%d, %s* %%%s, align %d\n",typeString,index, typeString, var_name, typeToAlignment(typeString));

		fileWriter.format("  store %s %%%d, %s* %%%s, align %d\n",typeString,index, typeString, var_name, typeToAlignment(typeString));
	}
	static int x=0;
	public void li(TEMP t,int value)
	{
		int idx=t.getSerialNumber();
		// System.out.format("li value,  %%Temp_%d = %d\n",idx,value);
		fileWriter.format("  %%zero_%d = load i32, i32* @my_zero, align 4\n",x);
		fileWriter.format("  %%Temp_%d = add nsw i32 %%zero_%d, %d\n",idx,x++,value);
	}

	static int y=0;
	public void ls(TEMP t,String value)
	{
		int idx=t.getSerialNumber();
		int stringLength = value.length() + 1;

		fileWriter.format("  %%str_%d = alloca i8*\n",y);
		fileWriter.format("  store i8* getelementptr inbounds ([%d x i8], [%d x i8]* @STR.%s, i32 0, i32 0), i8** %%str_%d, align 8\n",stringLength, stringLength, value, y);
		fileWriter.format("  %%Temp_%d = load i8*, i8** %%str_%d, align 8\n",idx, y++);


	}

	static int z=0;
	public void add_strings(TEMP dst, TEMP oprnd1,TEMP oprnd2)
	{
		int oprnd1S = oprnd1.getSerialNumber();
		int oprnd2S = oprnd2.getSerialNumber();
		fileWriter.format("%%oprnd1_size_%d = call i32 @strlen(i8* %%Temp_%d)\n",z, oprnd1S);
		fileWriter.format("%%oprnd2_size_%d = call i32 @strlen(i8* %%Temp_%d)\n",z, oprnd2S);
		fileWriter.format("%%new_size_%d = add nsw i32 %%oprnd1_size_%d, %%oprnd2_size_%d\n",z, z, z);
		fileWriter.format("%%allocated_i32_%d = call i32* @malloc(i32 %%new_size_%d)\n",z, z);
		fileWriter.format("%%allocated_%d = bitcast i32* %%allocated_i32_%d to i8*\n",z, z);
		fileWriter.format("%%new_%d = call i8* @strcpy(i8* %%allocated_%d, i8* %%Temp_%d)\n",z, z, oprnd1S);

		fileWriter.format("%%Temp_%d = call i8* @strcat(i8* %%new_%d, i8* %%Temp_%d)\n",dst.getSerialNumber(), z++, oprnd2S);


	}

	static int a=0;
	public void check_null_deref(TEMP var, boolean shouldReverse)
	{
		fileWriter.format("%%Temp_null_%d = bitcast %s %%Temp_%d to i32*\n",a,typeToString(var.getType()) ,var.getSerialNumber());
		fileWriter.format("%%equal_null_%d = icmp eq i32* %%Temp_null_%d, null\n",a, a);
		// if (shouldReverse) {
		// 	fileWriter.format("br i1 %%equal_null_%d, label %%continue_%d, label %%null_deref_%d\n",a, a, a);
		// } else {
		//  fileWriter.format("br i1 %%equal_null_%d, label %%null_deref_%d, label %%continue_%d\n",a, a, a);
		// }
		fileWriter.format("br i1 %%equal_null_%d, label %%null_deref_%d, label %%continue_%d\n",a, a, a);

		fileWriter.format("null_deref_%d:\n",a);

		if (var.getType().isClass() || var.getType().isArray())
		{
			fileWriter.format("call void @InvalidPointer()\n");
		} else{
			fileWriter.format("call void @AccessViolation()\n");
		}
		fileWriter.format("br label %%continue_%d\n",a);

		fileWriter.format("continue_%d:\n",a++);
	}

	public void check_subscript(TEMP var, TEMP subscript)
	{
		fileWriter.format("%%Temp_i32_%d = bitcast %s %%Temp_%d to i32*\n",a,typeToString(var.getType()), var.getSerialNumber());
		fileWriter.format("%%Temp_size_ptr_%d = getelementptr inbounds i32, i32* %%Temp_i32_%d, i32 0\n", a, a);
		fileWriter.format("%%arr_size_%d = load i32, i32* %%Temp_size_ptr_%d,align 4\n", a, a);
		fileWriter.format("%%sub_negative_%d = icmp slt i32  %%Temp_%d, 0\n",a, subscript.getSerialNumber());
		fileWriter.format("br i1 %%sub_negative_%d , label %%error_idx_%d, label %%positive_idx_%d\n",a, a, a);

		fileWriter.format("positive_idx_%d:\n",a);
		fileWriter.format("%%out_of_bounds_%d = icmp sge i32 %%Temp_%d, %%arr_size_%d\n",a,subscript.getSerialNumber(), a);
		fileWriter.format("br i1 %%out_of_bounds_%d , label %%error_idx_%d, label %%continue_idx_%d\n",a, a, a);



		fileWriter.format("error_idx_%d:\n",a);

		fileWriter.format("call void @AccessViolation()\n");
		fileWriter.format("br label %%continue_idx_%d\n",a);

		fileWriter.format("continue_idx_%d:\n",a++);
	}

	public void check_init_load(TEMP dst, TEMP src)
	{
		String typeString = typeToString(dst.getType());

		fileWriter.format("%%Temp_init_ptr_%d = bitcast %s* %%Temp_%d to i32*\n",a,typeToString(src.getType()), src.getSerialNumber());
		fileWriter.format("%%init_state_%d = load i32, i32* %%Temp_init_ptr_%d,align 4\n", a, a);
		fileWriter.format("%%is_init_%d = icmp eq i32  %%init_state_%d, 0\n",a, a);
		fileWriter.format("br i1 %%is_init_%d , label %%error_init_%d, label %%good_init_%d\n",a, a, a);

		fileWriter.format("error_init_%d:\n",a);

		fileWriter.format("call void @InvalidPointer()\n");
		fileWriter.format("br label %%good_init_%d\n",a);

		fileWriter.format("good_init_%d:\n",a);
		fileWriter.format("%%Temp_actual_ptr_%d = getelementptr inbounds i32, i32* %%Temp_init_ptr_%d, i32 1\n", a, a);
		fileWriter.format("%%Temp_actual_%d = bitcast i32* %%Temp_actual_ptr_%d to %s*\n",a,a , typeString);
		fileWriter.format("  %%Temp_%d = load %s, %s* %%Temp_actual_%d , align %d\n",
		dst.getSerialNumber(),
		typeString,
		typeString,
		a++,
		typeToAlignment(typeString));
	}

	public void check_init_store(TEMP dst, TEMP src)
	{
		String typeString = typeToString(dst.getType());

		fileWriter.format("%%Temp_init_ptr_%d = bitcast %s* %%Temp_%d to i32*\n",a,typeString, dst.getSerialNumber());
		fileWriter.format("store i32 1, i32* %%Temp_init_ptr_%d,align 4\n", a, a);
		fileWriter.format("%%Temp_actual_ptr_%d = getelementptr inbounds i32, i32* %%Temp_init_ptr_%d, i32 1\n", a, a);
		fileWriter.format("%%Temp_actual_%d = bitcast i32* %%Temp_actual_ptr_%d to %s*\n",a,a , typeToString(src.getType()));

		int idxsrc=src.getSerialNumber();
		fileWriter.format("  store %s %%Temp_%d, %s* %%Temp_actual_%d, align %d\n",
		typeToString(src.getType()),
		idxsrc,
		typeToString(src.getType()),
		a++,
		typeToAlignment(typeString));
	}

	public void store_string(TEMP t,String value)
	{
		int idx=t.getSerialNumber();

		int stringLength = value.length() + 1;
		String stringName = value.replace(' ', '.');
		fileWriter.format("  store i8* getelementptr inbounds ([%d x i8], [%d x i8]* @STR.%s, i32 0, i32 0), i8** %%Temp_%d, align 8\n",stringLength, stringLength, stringName, idx);
	}

	public void store_string_local(int local,String value)
	{
		String stringName = value.replace(' ', '.');
		int stringLength = value.length() + 1;
		fileWriter.format("  store i8* getelementptr inbounds ([%d x i8], [%d x i8]* @STR.%s, i32 0, i32 0), i8** %%local_%d, align 8\n",stringLength, stringLength, stringName, local);
	}

	public void store_null(TEMP t)
	{
		int idx=t.getSerialNumber();

		fileWriter.format("  %%Temp_%d = load i32*, i32** @my_null, align 8\n",idx);
	}

	public void add(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format(
			"  %%Temp_%d = add nsw i32 %%Temp_%d, %%Temp_%d\n",
			dstidx,
			i1,
			i2);
	}

	public void dec(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format(
			"  %%Temp_%d = sub nsw i32 %%Temp_%d, %%Temp_%d\n",
			dstidx,
			i1,
			i2);
	}
	public void add(TEMP dst,TEMP oprnd1,int value)
	{
		int i1 =oprnd1.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format(
			"  %%Temp_%d = add nsw i32 %%Temp_%d,%d\n",
			dstidx,
			i1,
			value);
	}

	public void mul(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format(
			"  %%Temp_%d = mul nsw i32 %%Temp_%d, %%Temp_%d\n",
			dstidx,
			i1,
			i2);
	}

	private static int c=0;
	public void div(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();


		fileWriter.format("%%is_div_zero_%d = icmp eq i32  %%Temp_%d, 0\n",c, i2);
		fileWriter.format("br i1 %%is_div_zero_%d , label %%div_by_zero_%d, label %%good_div_%d\n",c, c, c);

		fileWriter.format("div_by_zero_%d:\n",c);

		fileWriter.format("call void @DivideByZero()\n");
		fileWriter.format("br label %%good_div_%d\n",c);

		fileWriter.format("good_div_%d:\n",c++);

		fileWriter.format(
			"  %%Temp_%d = sdiv i32 %%Temp_%d, %%Temp_%d\n",
			dstidx,
			i1,
			i2);
	}

	public void handle_overflow(TEMP dst, TEMP val)
	{
		fileWriter.format("%%Temp_%d = call i32 @CheckOverflow(i32 %%Temp_%d)\n",dst.getSerialNumber(),val.getSerialNumber());

	}
	public void icmp_lt(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format(
			"  %%Temp_%d = icmp slt i32 %%Temp_%d, %%Temp_%d\n",
			dstidx,
			i1,
			i2);
	}
	public void icmp_eq(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format(
			"  %%Temp_%d = icmp eq %s %%Temp_%d, %%Temp_%d\n",
			dstidx,
			typeToString(oprnd1.getType()),
			i1,
			i2);
	}
	private static int b=0;
	public void icmp_eq_str(TEMP dst,TEMP oprnd1,TEMP oprnd2)
	{
		int i1 =oprnd1.getSerialNumber();
		int i2 =oprnd2.getSerialNumber();
		int dstidx=dst.getSerialNumber();

		fileWriter.format("%%str_cmp_%d = call i32 @strcmp(i8* %%Temp_%d, i8* %%Temp_%d)\n", b, i1, i2);
		fileWriter.format(
			"  %%Temp_%d = icmp eq i32 %%str_cmp_%d, 0\n",
			dstidx,
			b++);
	}
	public void label(String inlabel)
	{
		if (inlabel.equals("main"))
		{
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
			fileWriter.format("  br label %%main_body\n");
			fileWriter.format("\nmain_body:\n\n");
		}
		else
		{
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
		int i1 =oprnd1.getSerialNumber();

		fileWriter.format("  %%equal_zero_%d = icmp eq %s %%Temp_%d, 0\n",x, typeToString(oprnd1.getType()), i1);
		fileWriter.format("  br i1 %%equal_zero_%d, label %%%s, label %%%s\n",x,label1,label2);
		fileWriter.format("  \n%s:\n\n",label2);
		x++;
	}

	public void getelement(TEMP dst, TEMP src, TYPE type, int offset)
	{
		String typeString = typeToString(type);
		if (src.getType().isClass())
		{
			typeString = "i8";
		}
		fileWriter.format("  %%Temp_%d = getelementptr inbounds %s, %s* %%Temp_%d, i32 %d\n",
		dst.getSerialNumber(),
		typeString,
		typeString,
		src.getSerialNumber(),
		offset);
	}

	public void getelement(TEMP dst, TEMP src, TYPE type, TEMP offset)
	{
		fileWriter.format(";getlement temp temp temp;\n");
		String typeString = typeToString(type);
		if (src.getType().isClass())
		{
			typeString = "i8";
		}
		fileWriter.format("  %%Temp_%d = getelementptr inbounds %s, %s* %%Temp_%d, i32 %%Temp_%d\n",
		dst.getSerialNumber(),
		typeString,
		typeString,
		src.getSerialNumber(),
		offset.getSerialNumber());
	}

	public void get_data_member_by_ptr(TEMP dst, TYPE type, int offset)
	{
		fileWriter.format("  %%Temp_%d = getelementptr inbounds i8, i8* %%0, i32 %d\n",
		dst.getSerialNumber(),
		offset);
	}

	public void defineStrings()
	{
		for(String str : strings)
		{
			String stringName = str.replace(' ', '.');
			// System.out.format("@STR.%s = constant [%d x i8] c\"%s\\00\", align 1\n", stringName, str.length() + 1, str);
			fileWriter.format("@STR.%s = constant [%d x i8] c\"%s\\00\", align 1\n", stringName, str.length() + 1, str);
		}
	}


	public String typeToString(TYPE type){
		if (type == null){
			return "i1";
		}
		if (type instanceof TYPE_NIL){
			return "i32*";
		}
		if (type.isClass())
		{
			return "i8*";
		}
		if(type.isArray()){
			String typeString = typeToString(((TYPE_ARRAY)type).type) + "*";
			return typeString;
		}
		if(type.isInt())
		{
			return "i32";
		}
		if (type.isVoid())
		{
			return "void";
		}
		return "i8*";
	}

	private int typeToAlignment(String typeString){
		if (typeString.endsWith("*"))
		{
			return 8;
		}
		return 4;
	}
	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static LLVM instance = null;
	private static String filename = "";

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	private LLVM() {}

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

	public static void setFileName(String fileName)
	{
		filename = fileName;
	}
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
			try
			{
				instance.fileWriter = new PrintWriter(filename);
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}


			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format(";                         ;\n");
			instance.fileWriter.format("; EXTERNAL LIBRARY FUNCS ;\n");
			instance.fileWriter.format(";                         ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("declare i32* @malloc(i32)\n");
			instance.fileWriter.format("declare i32 @strcmp(i8*, i8*)\n");
			instance.fileWriter.format("declare i32 @strlen(i8*)\n");
			instance.fileWriter.format("declare i8* @strcat(i8*, i8*)\n");
			instance.fileWriter.format("declare i8* @strcpy(i8*, i8*)\n");
			instance.fileWriter.format("declare void @exit(i32)\n\n");


			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format(";                         ;\n");
			instance.fileWriter.format("; GLOBAL VARIABLE :: zero ;\n");
			instance.fileWriter.format(";                         ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("@my_zero = global i32 0, align 4\n\n");
			instance.fileWriter.format("@my_null = global i32* null, align 4\n");
			instance.fileWriter.format("@STR.EXECUTION.FALLS = constant [16 x i8] c\"execution falls\00\", align 1\n\n");
			instance.fileWriter.format("@STR.ACCESS.VIOLATION = constant [17 x i8] c\"Access Violation\00\", align 1\n\n");
			instance.fileWriter.format("@STR.INVALID.POINTER = constant [28 x i8] c\"Invalid Pointer Dereference\00\", align 1\n\n");
			instance.fileWriter.format("@STR.DIVISION.BY.ZERO = constant [17 x i8] c\"Division By Zero\00\", align 1\n\n");
			// instance.defineStrings();

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
			instance.fileWriter.format("\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format(";                              ;\n");
			instance.fileWriter.format("; LIBRARY FUNCTION :: PrintInt ;\n");
			instance.fileWriter.format("; LIBRARY FUNCTION :: PrintPtr ;\n");
			instance.fileWriter.format(";                              ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @PrintPtr(i32* %%p)\n");
			instance.fileWriter.format("{\n");
			instance.fileWriter.format("  %%Temp1_66  = ptrtoint i32* %%p to i32\n");
			instance.fileWriter.format("  call void @PrintInt(i32 %%Temp1_66 )\n");
			instance.fileWriter.format("  ret void\n}\n\n");
			instance.fileWriter.format("@.str1 = private unnamed_addr constant [4 x i8] c\"%%s\\0A\\00\", align 1\n");
			instance.fileWriter.format("\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format("; LIBRARY FUNCTION :: PrintString ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @PrintString(i8* %%s) {\n");
			instance.fileWriter.format("entry:\n");
			instance.fileWriter.format("%%s.addr = alloca i8*, align 4\n");
			instance.fileWriter.format("store i8* %%s, i8** %%s.addr, align 4\n");
			instance.fileWriter.format("%%Temp1_55 = load i8*, i8** %%s.addr, align 4\n");
			instance.fileWriter.format("%%call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str1, i32 0, i32 0), i8* %%Temp1_55)\n");
			instance.fileWriter.format("ret void\n");
			instance.fileWriter.format("}\n\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";  ExitWithError ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @ExitWithError(i8* %%s) {\n");
			instance.fileWriter.format("call void @PrintString(i8* %%s)\n");
			instance.fileWriter.format("call void @exit(i32 0)\n");
			instance.fileWriter.format("ret void\n");
			instance.fileWriter.format("}\n\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";  ExecutionFalls ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @ExecutionFalls() {\n");
			instance.fileWriter.format("%%err_0 = alloca i8*, align 8\n");
			instance.fileWriter.format("store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @STR.EXECUTION.FALLS, i32 0, i32 0), i8** %%err_0, align 8\n");
			instance.fileWriter.format("%%err_Temp_0 = load i8*, i8** %%err_0, align 8\n");
			instance.fileWriter.format("call void @ExitWithError(i8* %%err_Temp_0)\n");
			instance.fileWriter.format("ret void\n");
			instance.fileWriter.format("}\n\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";  AccessViolation ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @AccessViolation() {\n");
			instance.fileWriter.format("%%err_1 = alloca i8*, align 8\n");
			instance.fileWriter.format("store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @STR.ACCESS.VIOLATION, i32 0, i32 0), i8** %%err_1, align 8\n");
			instance.fileWriter.format("%%err_Temp_1 = load i8*, i8** %%err_1, align 8\n");
			instance.fileWriter.format("call void @ExitWithError(i8* %%err_Temp_1)\n");
			instance.fileWriter.format("ret void\n");
			instance.fileWriter.format("}\n\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";  InvalidPointer ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @InvalidPointer() {\n");
			instance.fileWriter.format("%%err_2 = alloca i8*, align 8\n");
			instance.fileWriter.format("store i8* getelementptr inbounds ([28 x i8], [28 x i8]* @STR.INVALID.POINTER, i32 0, i32 0), i8** %%err_2, align 8\n");
			instance.fileWriter.format("%%err_Temp_2 = load i8*, i8** %%err_2, align 8\n");
			instance.fileWriter.format("call void @ExitWithError(i8* %%err_Temp_2)\n");
			instance.fileWriter.format("ret void\n");
			instance.fileWriter.format("}\n\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";  DivideByZero ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define void @DivideByZero() {\n");
			instance.fileWriter.format("%%err_3 = alloca i8*, align 8\n");
			instance.fileWriter.format("store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @STR.DIVISION.BY.ZERO, i32 0, i32 0), i8** %%err_3, align 8\n");
			instance.fileWriter.format("%%err_Temp_3 = load i8*, i8** %%err_3, align 8\n");
			instance.fileWriter.format("call void @ExitWithError(i8* %%err_Temp_3)\n");
			instance.fileWriter.format("ret void\n");
			instance.fileWriter.format("}\n\n");

			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";  CheckOverflow ;\n");
			instance.fileWriter.format(";                                 ;\n");
			instance.fileWriter.format(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
			instance.fileWriter.format("define i32 @CheckOverflow(i32 %%val) {\n");
			instance.fileWriter.format("%%Temp_val = alloca i32\n");
			instance.fileWriter.format("%%is_overflow = icmp sge i32  %%val, 32767\n");
			instance.fileWriter.format("br i1 %%is_overflow , label %%label_overflow, label %%label_is_underflow\n");

			instance.fileWriter.format("label_overflow:\n");
			instance.fileWriter.format("store i32 32767,i32* %%Temp_val\n");
			instance.fileWriter.format("br label %%label_handeled_overflow\n");

			instance.fileWriter.format("label_is_underflow:\n");
			instance.fileWriter.format("%%is_underflow = icmp slt i32  %%val, -32767\n");
			instance.fileWriter.format("br i1 %%is_underflow , label %%label_underflow, label %%label_no_overflow\n");

			instance.fileWriter.format("label_underflow:\n");
			instance.fileWriter.format("store i32 -32768,i32* %%Temp_val\n");
			instance.fileWriter.format("br label %%label_handeled_overflow\n");

			instance.fileWriter.format("label_no_overflow:\n");
			instance.fileWriter.format("store i32 %%val,i32* %%Temp_val\n");
			instance.fileWriter.format("br label %%label_handeled_overflow\n");

			instance.fileWriter.format("label_handeled_overflow:\n");
			instance.fileWriter.format("%%Temp_res = load i32,i32* %%Temp_val\n");
			instance.fileWriter.format("ret i32 %%Temp_res\n}\n\n");


		}
		return instance;
	}
}
