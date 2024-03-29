;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         ;
; EXTERNAL LIBRARY FUNCS ;
;                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
declare i32* @malloc(i32)
declare i32 @strcmp(i8*, i8*)
declare i32 @strlen(i8*)
declare i8* @strcat(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare void @exit(i32)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         ;
; GLOBAL VARIABLE :: zero ;
;                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
@my_zero = global i32 0, align 4

@my_null = global i32* null, align 4
@STR.EXECUTION.FALLS = constant [16 x i8] c"execution falls ", align 1

@STR.ACCESS.VIOLATION = constant [17 x i8] c"Access Violation ", align 1

@STR.INVALID.POINTER = constant [28 x i8] c"Invalid Pointer Dereference ", align 1

@STR.DIVISION.BY.ZERO = constant [17 x i8] c"Division By Zero ", align 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              ;
; LIBRARY FUNCTION :: PrintPtr ;
;                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @PrintPtr(i32* %p)
{
  %Temp1_66  = ptrtoint i32* %p to i32
  call void @PrintInt(i32 %Temp1_66 )
  ret void
}

@.str1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              ;
; LIBRARY FUNCTION :: PrintInt ;
;                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define dso_local void @PrintInt(i32 %i) {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32, i32* %i.addr, align 4
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %0)
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                            ;
; STDANDRD LIBRARY :: printf ;
;                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
declare dso_local i32 @printf(i8*, ...)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
; LIBRARY FUNCTION :: PrintString ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @PrintString(i8* %s) {
entry:
%s.addr = alloca i8*, align 4
store i8* %s, i8** %s.addr, align 4
%Temp1_55 = load i8*, i8** %s.addr, align 4
%call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str1, i32 0, i32 0), i8* %Temp1_55)
ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
;  ExitWithError ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @ExitWithError(i8* %s) {
call void @PrintString(i8* %s)
call void @exit(i32 0)
ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
;  ExecutionFalls ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @ExecutionFalls() {
%err_0 = alloca i8*, align 8
store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @STR.EXECUTION.FALLS, i32 0, i32 0), i8** %err_0, align 8
%err_Temp_0 = load i8*, i8** %err_0, align 8
call void @ExitWithError(i8* %err_Temp_0)
ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
;  AccessViolation ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @AccessViolation() {
%err_1 = alloca i8*, align 8
store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @STR.ACCESS.VIOLATION, i32 0, i32 0), i8** %err_1, align 8
%err_Temp_1 = load i8*, i8** %err_1, align 8
call void @ExitWithError(i8* %err_Temp_1)
ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
;  InvalidPointer ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @InvalidPointer() {
%err_2 = alloca i8*, align 8
store i8* getelementptr inbounds ([28 x i8], [28 x i8]* @STR.INVALID.POINTER, i32 0, i32 0), i8** %err_2, align 8
%err_Temp_2 = load i8*, i8** %err_2, align 8
call void @ExitWithError(i8* %err_Temp_2)
ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
;  DivideByZero ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @DivideByZero() {
%err_3 = alloca i8*, align 8
store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @STR.DIVISION.BY.ZERO, i32 0, i32 0), i8** %err_3, align 8
%err_Temp_3 = load i8*, i8** %err_3, align 8
call void @ExitWithError(i8* %err_Temp_3)
ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;n;                                 ;
;  CheckOverflow ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define i32 @CheckOverflow(i32 %val) {
%Temp_val = alloca i32
%is_overflow = icmp sge i32  %val, 32767
br i1 %is_overflow , label %label_overflow, label %label_is_underflow
label_overflow:
store i32 32767,i32* %Temp_val
br label %label_handeled_overflow
label_is_underflow:
%is_underflow = icmp slt i32  %val, -32767
br i1 %is_underflow , label %label_underflow, label %label_no_overflow
label_underflow:
store i32 -32768,i32* %Temp_val
br label %label_handeled_overflow
label_no_overflow:
store i32 %val,i32* %Temp_val
br label %label_handeled_overflow
label_handeled_overflow:
%Temp_res = load i32,i32* %Temp_val
ret i32 %Temp_res
}

@STR.a = constant [2 x i8] c"a\00", align 1
@STR.NumberOfVowelsFoundIs = constant [22 x i8] c"NumberOfVowelsFoundIs\00", align 1
@STR.c = constant [2 x i8] c"c\00", align 1
@STR.e = constant [2 x i8] c"e\00", align 1
@STR.i = constant [2 x i8] c"i\00", align 1
@STR.l = constant [2 x i8] c"l\00", align 1
@STR.m = constant [2 x i8] c"m\00", align 1
@STR.n = constant [2 x i8] c"n\00", align 1
@STR.o = constant [2 x i8] c"o\00", align 1
@STR.p = constant [2 x i8] c"p\00", align 1
@STR.t = constant [2 x i8] c"t\00", align 1
@STR.u = constant [2 x i8] c"u\00", align 1
@STR.terminate = constant [10 x i8] c"terminate\00", align 1
define i32 @inc(i32)
 { 
  %num = alloca i32, align 4
  store i32 %0, i32* %num, align 4
  %Temp_1 = load i32, i32* %num, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_0, 1
  %Temp_0 = add nsw i32 %Temp_1, %Temp_2
%Temp_3 = call i32 @CheckOverflow(i32 %Temp_0)
  ret i32 %Temp_3
}
define i32 @stringNeq(i8*,i8*)
 { 
  %a = alloca i8*, align 8
  %b = alloca i8*, align 8
  store i8* %0, i8** %a, align 8
  store i8* %1, i8** %b, align 8
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_5 = load i8*, i8** %a, align 8
  %Temp_6 = load i8*, i8** %b, align 8
%str_cmp_0 = call i32 @strcmp(i8* %Temp_5, i8* %Temp_6)
  %Temp_4 = icmp eq i32 %str_cmp_0, 0
  %Temp_7 = zext i1 %Temp_4 to i32
  %equal_zero_1 = icmp eq i32 %Temp_7, 0
  br i1 %equal_zero_1, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_2, 1
  ret i32 %Temp_8
  br label %Label_2_if.exit

Label_2_if.exit:

  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_3, 0
  ret i32 %Temp_9
}
define i32 @strLen(i8**)
 { 
  %str = alloca i8**, align 8
  %local_1 = alloca i8*, align 8
  %local_0 = alloca i32, align 4
  store i8** %0, i8*** %str, align 8
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_4, 0
  store i32 %Temp_10, i32* %local_0, align 4
  %Temp_11 = load i8**, i8*** %str, align 8
%Temp_null_0 = bitcast i8** %Temp_11 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_5, 0
%Temp_i32_1 = bitcast i8** %Temp_11 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_12, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_12, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_13 = add nsw i32 %Temp_12,1
;getlement temp temp temp;
  %Temp_14 = getelementptr inbounds i8*, i8** %Temp_11, i32 %Temp_13
;load temp temp;
  %Temp_15 = load i8*, i8** %Temp_14, align 8
  store i8* %Temp_15, i8** %local_1, align 8
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_16 = load i8*, i8** %local_1, align 8
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @STR.terminate, i32 0, i32 0), i8** %str_0, align 8
  %Temp_17 = load i8*, i8** %str_0, align 8
%Temp_18 =call i32 @stringNeq(i8* %Temp_16 ,i8* %Temp_17 )
  %equal_zero_6 = icmp eq i32 %Temp_18, 0
  br i1 %equal_zero_6, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  %Temp_19 = load i32, i32* %local_0, align 4
%Temp_20 =call i32 @inc(i32 %Temp_19 )
  store i32 %Temp_20, i32* %local_0, align 4
  %Temp_21 = load i8**, i8*** %str, align 8
%Temp_null_2 = bitcast i8** %Temp_21 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %Temp_22 = load i32, i32* %local_0, align 4
%Temp_i32_3 = bitcast i8** %Temp_21 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_22, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_22, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_23 = add nsw i32 %Temp_22,1
;getlement temp temp temp;
  %Temp_24 = getelementptr inbounds i8*, i8** %Temp_21, i32 %Temp_23
;load temp temp;
  %Temp_25 = load i8*, i8** %Temp_24, align 8
  store i8* %Temp_25, i8** %local_1, align 8
  br label %Label_5_while.cond

Label_3_while.end:

  %Temp_26 = load i32, i32* %local_0, align 4
  ret i32 %Temp_26
}
define i32 @stringsEqual(i8*,i8*)
 { 
  %a = alloca i8*, align 8
  %b = alloca i8*, align 8
  store i8* %0, i8** %a, align 8
  store i8* %1, i8** %b, align 8
  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_28 = load i8*, i8** %a, align 8
  %Temp_29 = load i8*, i8** %b, align 8
%str_cmp_1 = call i32 @strcmp(i8* %Temp_28, i8* %Temp_29)
  %Temp_27 = icmp eq i32 %str_cmp_1, 0
  %Temp_30 = zext i1 %Temp_27 to i32
  %equal_zero_7 = icmp eq i32 %Temp_30, 0
  br i1 %equal_zero_7, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_8, 0
  ret i32 %Temp_31
  br label %Label_8_if.exit

Label_8_if.exit:

  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_9, 1
  ret i32 %Temp_32
}
define i32 @belongsToCharset(i8*,i8**,i32)
 { 
  %char = alloca i8*, align 8
  %charset = alloca i8**, align 8
  %size = alloca i32, align 4
  %local_0 = alloca i8*, align 8
  %local_1 = alloca i32, align 4
  store i8* %0, i8** %char, align 8
  store i8** %1, i8*** %charset, align 8
  store i32 %2, i32* %size, align 4
  %Temp_33 = load i8**, i8*** %charset, align 8
%Temp_null_4 = bitcast i8** %Temp_33 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_10, 0
%Temp_i32_5 = bitcast i8** %Temp_33 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_34, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_34, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_35 = add nsw i32 %Temp_34,1
;getlement temp temp temp;
  %Temp_36 = getelementptr inbounds i8*, i8** %Temp_33, i32 %Temp_35
;load temp temp;
  %Temp_37 = load i8*, i8** %Temp_36, align 8
  store i8* %Temp_37, i8** %local_0, align 8
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_11, 0
  store i32 %Temp_38, i32* %local_1, align 4
  br label %Label_11_while.cond

Label_11_while.cond:

  %Temp_40 = load i32, i32* %local_1, align 4
  %Temp_41 = load i32, i32* %size, align 4
  %Temp_39 = icmp slt i32 %Temp_40, %Temp_41
  %Temp_42 = zext i1 %Temp_39 to i32
  %equal_zero_12 = icmp eq i32 %Temp_42, 0
  br i1 %equal_zero_12, label %Label_9_while.end, label %Label_10_while.body
  
Label_10_while.body:

  br label %Label_12_if.cond

Label_12_if.cond:

  %Temp_43 = load i8*, i8** %local_0, align 8
  %Temp_44 = load i8*, i8** %char, align 8
%Temp_45 =call i32 @stringsEqual(i8* %Temp_43 ,i8* %Temp_44 )
  %equal_zero_13 = icmp eq i32 %Temp_45, 0
  br i1 %equal_zero_13, label %Label_14_if.exit, label %Label_13_if.body
  
Label_13_if.body:

  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_14, 1
  ret i32 %Temp_46
  br label %Label_14_if.exit

Label_14_if.exit:

  %Temp_47 = load i32, i32* %local_1, align 4
%Temp_48 =call i32 @inc(i32 %Temp_47 )
  store i32 %Temp_48, i32* %local_1, align 4
  %Temp_49 = load i8**, i8*** %charset, align 8
%Temp_null_6 = bitcast i8** %Temp_49 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %Temp_50 = load i32, i32* %local_1, align 4
%Temp_i32_7 = bitcast i8** %Temp_49 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_50, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_50, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_51 = add nsw i32 %Temp_50,1
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8*, i8** %Temp_49, i32 %Temp_51
;load temp temp;
  %Temp_53 = load i8*, i8** %Temp_52, align 8
  store i8* %Temp_53, i8** %local_0, align 8
  br label %Label_11_while.cond

Label_9_while.end:

  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_15, 0
  ret i32 %Temp_54
}
define void @PrintCharArr(i8**)
 { 
  %str = alloca i8**, align 8
  %local_2 = alloca i8*, align 8
  %local_0 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  store i8** %0, i8*** %str, align 8
  %Temp_55 = load i8**, i8*** %str, align 8
%Temp_56 =call i32 @strLen(i8** %Temp_55 )
  store i32 %Temp_56, i32* %local_0, align 4
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_57 = add nsw i32 %zero_16, 0
  store i32 %Temp_57, i32* %local_1, align 4
  br label %Label_17_while.cond

Label_17_while.cond:

  %Temp_59 = load i32, i32* %local_1, align 4
  %Temp_60 = load i32, i32* %local_0, align 4
  %Temp_58 = icmp slt i32 %Temp_59, %Temp_60
  %Temp_61 = zext i1 %Temp_58 to i32
  %equal_zero_17 = icmp eq i32 %Temp_61, 0
  br i1 %equal_zero_17, label %Label_15_while.end, label %Label_16_while.body
  
Label_16_while.body:

  %Temp_62 = load i8**, i8*** %str, align 8
%Temp_null_8 = bitcast i8** %Temp_62 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %Temp_63 = load i32, i32* %local_1, align 4
%Temp_i32_9 = bitcast i8** %Temp_62 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_63, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_63, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_64 = add nsw i32 %Temp_63,1
;getlement temp temp temp;
  %Temp_65 = getelementptr inbounds i8*, i8** %Temp_62, i32 %Temp_64
;load temp temp;
  %Temp_66 = load i8*, i8** %Temp_65, align 8
  store i8* %Temp_66, i8** %local_2, align 8
  %Temp_67 = load i8*, i8** %local_2, align 8
  call void @PrintString(i8* %Temp_67 )
  %Temp_68 = load i32, i32* %local_1, align 4
%Temp_69 =call i32 @inc(i32 %Temp_68 )
  store i32 %Temp_69, i32* %local_1, align 4
  br label %Label_17_while.cond

Label_15_while.end:

  ret void
}
define i32 @getCount(i8**)
 { 
  %str = alloca i8**, align 8
  %local_0 = alloca i8**, align 8
  %local_2 = alloca i32, align 4
  %local_3 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_4 = alloca i32, align 4
  store i8** %0, i8*** %str, align 8
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_72 = add nsw i32 %zero_18, 5
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_73 = add nsw i32 %zero_19, 1
  %Temp_71 = add nsw i32 %Temp_72, %Temp_73
%Temp_74 = call i32 @CheckOverflow(i32 %Temp_71)
  %Temp_75 = add nsw i32 %Temp_74,1
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_76 = add nsw i32 %zero_20, 8
  %Temp_77 = mul nsw i32 %Temp_75, %Temp_76
  %Temp_78 = call i32* @malloc(i32 %Temp_77)
  %Temp_70 = bitcast i32* %Temp_78 to i8**
  %Temp_79 = getelementptr inbounds i32, i32* %Temp_78, i32 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
  store i32 %Temp_74, i32* %Temp_79, align 4
  store i8** %Temp_70, i8*** %local_0, align 8
  %Temp_80 = load i8**, i8*** %local_0, align 8
%Temp_null_10 = bitcast i8** %Temp_80 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_21, 0
%Temp_i32_11 = bitcast i8** %Temp_80 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_81, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_81, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_82 = add nsw i32 %Temp_81,1
;getlement temp temp temp;
  %Temp_83 = getelementptr inbounds i8*, i8** %Temp_80, i32 %Temp_82
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.a, i32 0, i32 0), i8** %str_1, align 8
  %Temp_84 = load i8*, i8** %str_1, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_84, i8** %Temp_83, align 8
  %Temp_85 = load i8**, i8*** %local_0, align 8
%Temp_null_12 = bitcast i8** %Temp_85 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_22, 1
%Temp_i32_13 = bitcast i8** %Temp_85 to i32*
%Temp_size_ptr_13 = getelementptr inbounds i32, i32* %Temp_i32_13, i32 0
%arr_size_13 = load i32, i32* %Temp_size_ptr_13,align 4
%sub_negative_13 = icmp slt i32  %Temp_86, 0
br i1 %sub_negative_13 , label %error_idx_13, label %positive_idx_13
positive_idx_13:
%out_of_bounds_13 = icmp sge i32 %Temp_86, %arr_size_13
br i1 %out_of_bounds_13 , label %error_idx_13, label %continue_idx_13
error_idx_13:
call void @AccessViolation()
br label %continue_idx_13
continue_idx_13:
  %Temp_87 = add nsw i32 %Temp_86,1
;getlement temp temp temp;
  %Temp_88 = getelementptr inbounds i8*, i8** %Temp_85, i32 %Temp_87
  %str_2 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.e, i32 0, i32 0), i8** %str_2, align 8
  %Temp_89 = load i8*, i8** %str_2, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_89, i8** %Temp_88, align 8
  %Temp_90 = load i8**, i8*** %local_0, align 8
%Temp_null_14 = bitcast i8** %Temp_90 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_23, 2
%Temp_i32_15 = bitcast i8** %Temp_90 to i32*
%Temp_size_ptr_15 = getelementptr inbounds i32, i32* %Temp_i32_15, i32 0
%arr_size_15 = load i32, i32* %Temp_size_ptr_15,align 4
%sub_negative_15 = icmp slt i32  %Temp_91, 0
br i1 %sub_negative_15 , label %error_idx_15, label %positive_idx_15
positive_idx_15:
%out_of_bounds_15 = icmp sge i32 %Temp_91, %arr_size_15
br i1 %out_of_bounds_15 , label %error_idx_15, label %continue_idx_15
error_idx_15:
call void @AccessViolation()
br label %continue_idx_15
continue_idx_15:
  %Temp_92 = add nsw i32 %Temp_91,1
;getlement temp temp temp;
  %Temp_93 = getelementptr inbounds i8*, i8** %Temp_90, i32 %Temp_92
  %str_3 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.i, i32 0, i32 0), i8** %str_3, align 8
  %Temp_94 = load i8*, i8** %str_3, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_94, i8** %Temp_93, align 8
  %Temp_95 = load i8**, i8*** %local_0, align 8
%Temp_null_16 = bitcast i8** %Temp_95 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_96 = add nsw i32 %zero_24, 3
%Temp_i32_17 = bitcast i8** %Temp_95 to i32*
%Temp_size_ptr_17 = getelementptr inbounds i32, i32* %Temp_i32_17, i32 0
%arr_size_17 = load i32, i32* %Temp_size_ptr_17,align 4
%sub_negative_17 = icmp slt i32  %Temp_96, 0
br i1 %sub_negative_17 , label %error_idx_17, label %positive_idx_17
positive_idx_17:
%out_of_bounds_17 = icmp sge i32 %Temp_96, %arr_size_17
br i1 %out_of_bounds_17 , label %error_idx_17, label %continue_idx_17
error_idx_17:
call void @AccessViolation()
br label %continue_idx_17
continue_idx_17:
  %Temp_97 = add nsw i32 %Temp_96,1
;getlement temp temp temp;
  %Temp_98 = getelementptr inbounds i8*, i8** %Temp_95, i32 %Temp_97
  %str_4 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.o, i32 0, i32 0), i8** %str_4, align 8
  %Temp_99 = load i8*, i8** %str_4, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_99, i8** %Temp_98, align 8
  %Temp_100 = load i8**, i8*** %local_0, align 8
%Temp_null_18 = bitcast i8** %Temp_100 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_101 = add nsw i32 %zero_25, 4
%Temp_i32_19 = bitcast i8** %Temp_100 to i32*
%Temp_size_ptr_19 = getelementptr inbounds i32, i32* %Temp_i32_19, i32 0
%arr_size_19 = load i32, i32* %Temp_size_ptr_19,align 4
%sub_negative_19 = icmp slt i32  %Temp_101, 0
br i1 %sub_negative_19 , label %error_idx_19, label %positive_idx_19
positive_idx_19:
%out_of_bounds_19 = icmp sge i32 %Temp_101, %arr_size_19
br i1 %out_of_bounds_19 , label %error_idx_19, label %continue_idx_19
error_idx_19:
call void @AccessViolation()
br label %continue_idx_19
continue_idx_19:
  %Temp_102 = add nsw i32 %Temp_101,1
;getlement temp temp temp;
  %Temp_103 = getelementptr inbounds i8*, i8** %Temp_100, i32 %Temp_102
  %str_5 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.u, i32 0, i32 0), i8** %str_5, align 8
  %Temp_104 = load i8*, i8** %str_5, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_104, i8** %Temp_103, align 8
  %Temp_105 = load i8**, i8*** %local_0, align 8
%Temp_null_20 = bitcast i8** %Temp_105 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_106 = add nsw i32 %zero_26, 5
%Temp_i32_21 = bitcast i8** %Temp_105 to i32*
%Temp_size_ptr_21 = getelementptr inbounds i32, i32* %Temp_i32_21, i32 0
%arr_size_21 = load i32, i32* %Temp_size_ptr_21,align 4
%sub_negative_21 = icmp slt i32  %Temp_106, 0
br i1 %sub_negative_21 , label %error_idx_21, label %positive_idx_21
positive_idx_21:
%out_of_bounds_21 = icmp sge i32 %Temp_106, %arr_size_21
br i1 %out_of_bounds_21 , label %error_idx_21, label %continue_idx_21
error_idx_21:
call void @AccessViolation()
br label %continue_idx_21
continue_idx_21:
  %Temp_107 = add nsw i32 %Temp_106,1
;getlement temp temp temp;
  %Temp_108 = getelementptr inbounds i8*, i8** %Temp_105, i32 %Temp_107
  %str_6 = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @STR.terminate, i32 0, i32 0), i8** %str_6, align 8
  %Temp_109 = load i8*, i8** %str_6, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_109, i8** %Temp_108, align 8
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_110 = add nsw i32 %zero_27, 0
  store i32 %Temp_110, i32* %local_1, align 4
  %Temp_111 = load i8**, i8*** %str, align 8
%Temp_112 =call i32 @strLen(i8** %Temp_111 )
  store i32 %Temp_112, i32* %local_2, align 4
  %Temp_113 = load i8**, i8*** %local_0, align 8
%Temp_114 =call i32 @strLen(i8** %Temp_113 )
  store i32 %Temp_114, i32* %local_3, align 4
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_115 = add nsw i32 %zero_28, 0
  store i32 %Temp_115, i32* %local_4, align 4
  br label %Label_20_while.cond

Label_20_while.cond:

  %Temp_117 = load i32, i32* %local_4, align 4
  %Temp_118 = load i32, i32* %local_2, align 4
  %Temp_116 = icmp slt i32 %Temp_117, %Temp_118
  %Temp_119 = zext i1 %Temp_116 to i32
  %equal_zero_29 = icmp eq i32 %Temp_119, 0
  br i1 %equal_zero_29, label %Label_18_while.end, label %Label_19_while.body
  
Label_19_while.body:

  br label %Label_21_if.cond

Label_21_if.cond:

  %Temp_120 = load i8**, i8*** %str, align 8
%Temp_null_22 = bitcast i8** %Temp_120 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %Temp_121 = load i32, i32* %local_4, align 4
%Temp_i32_23 = bitcast i8** %Temp_120 to i32*
%Temp_size_ptr_23 = getelementptr inbounds i32, i32* %Temp_i32_23, i32 0
%arr_size_23 = load i32, i32* %Temp_size_ptr_23,align 4
%sub_negative_23 = icmp slt i32  %Temp_121, 0
br i1 %sub_negative_23 , label %error_idx_23, label %positive_idx_23
positive_idx_23:
%out_of_bounds_23 = icmp sge i32 %Temp_121, %arr_size_23
br i1 %out_of_bounds_23 , label %error_idx_23, label %continue_idx_23
error_idx_23:
call void @AccessViolation()
br label %continue_idx_23
continue_idx_23:
  %Temp_122 = add nsw i32 %Temp_121,1
;getlement temp temp temp;
  %Temp_123 = getelementptr inbounds i8*, i8** %Temp_120, i32 %Temp_122
  %Temp_124 = load i8**, i8*** %local_0, align 8
  %Temp_125 = load i32, i32* %local_3, align 4
;load temp temp;
  %Temp_126 = load i32, i32* %Temp_123, align 4
%Temp_127 =call i32 @belongsToCharset(i32 %Temp_126 ,i8** %Temp_124 ,i32 %Temp_125 )
  %equal_zero_30 = icmp eq i32 %Temp_127, 0
  br i1 %equal_zero_30, label %Label_23_if.exit, label %Label_22_if.body
  
Label_22_if.body:

  %Temp_128 = load i32, i32* %local_1, align 4
%Temp_129 =call i32 @inc(i32 %Temp_128 )
  store i32 %Temp_129, i32* %local_1, align 4
  br label %Label_23_if.exit

Label_23_if.exit:

  %Temp_130 = load i32, i32* %local_4, align 4
%Temp_131 =call i32 @inc(i32 %Temp_130 )
  store i32 %Temp_131, i32* %local_4, align 4
  br label %Label_20_while.cond

Label_18_while.end:

  %Temp_132 = load i32, i32* %local_1, align 4
  ret i32 %Temp_132
}
;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@str = global i8** null, align 8

define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i32, align 4
  call void @init_globals()
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_134 = add nsw i32 %zero_31, 12
  %Temp_135 = add nsw i32 %Temp_134,1
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_136 = add nsw i32 %zero_32, 8
  %Temp_137 = mul nsw i32 %Temp_135, %Temp_136
  %Temp_138 = call i32* @malloc(i32 %Temp_137)
  %Temp_133 = bitcast i32* %Temp_138 to i8**
  %Temp_139 = getelementptr inbounds i32, i32* %Temp_138, i32 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
  store i32 %Temp_134, i32* %Temp_139, align 4
  store i8** %Temp_133, i8*** @str, align 8
  %Temp_140 = load i8**, i8*** @str, align 8
%Temp_null_24 = bitcast i8** %Temp_140 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_141 = add nsw i32 %zero_33, 0
%Temp_i32_25 = bitcast i8** %Temp_140 to i32*
%Temp_size_ptr_25 = getelementptr inbounds i32, i32* %Temp_i32_25, i32 0
%arr_size_25 = load i32, i32* %Temp_size_ptr_25,align 4
%sub_negative_25 = icmp slt i32  %Temp_141, 0
br i1 %sub_negative_25 , label %error_idx_25, label %positive_idx_25
positive_idx_25:
%out_of_bounds_25 = icmp sge i32 %Temp_141, %arr_size_25
br i1 %out_of_bounds_25 , label %error_idx_25, label %continue_idx_25
error_idx_25:
call void @AccessViolation()
br label %continue_idx_25
continue_idx_25:
  %Temp_142 = add nsw i32 %Temp_141,1
;getlement temp temp temp;
  %Temp_143 = getelementptr inbounds i8*, i8** %Temp_140, i32 %Temp_142
  %str_7 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.c, i32 0, i32 0), i8** %str_7, align 8
  %Temp_144 = load i8*, i8** %str_7, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_144, i8** %Temp_143, align 8
  %Temp_145 = load i8**, i8*** @str, align 8
%Temp_null_26 = bitcast i8** %Temp_145 to i32*
%equal_null_26 = icmp eq i32* %Temp_null_26, null
br i1 %equal_null_26, label %null_deref_26, label %continue_26
null_deref_26:
call void @InvalidPointer()
br label %continue_26
continue_26:
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_146 = add nsw i32 %zero_34, 1
%Temp_i32_27 = bitcast i8** %Temp_145 to i32*
%Temp_size_ptr_27 = getelementptr inbounds i32, i32* %Temp_i32_27, i32 0
%arr_size_27 = load i32, i32* %Temp_size_ptr_27,align 4
%sub_negative_27 = icmp slt i32  %Temp_146, 0
br i1 %sub_negative_27 , label %error_idx_27, label %positive_idx_27
positive_idx_27:
%out_of_bounds_27 = icmp sge i32 %Temp_146, %arr_size_27
br i1 %out_of_bounds_27 , label %error_idx_27, label %continue_idx_27
error_idx_27:
call void @AccessViolation()
br label %continue_idx_27
continue_idx_27:
  %Temp_147 = add nsw i32 %Temp_146,1
;getlement temp temp temp;
  %Temp_148 = getelementptr inbounds i8*, i8** %Temp_145, i32 %Temp_147
  %str_8 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.o, i32 0, i32 0), i8** %str_8, align 8
  %Temp_149 = load i8*, i8** %str_8, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_149, i8** %Temp_148, align 8
  %Temp_150 = load i8**, i8*** @str, align 8
%Temp_null_28 = bitcast i8** %Temp_150 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_151 = add nsw i32 %zero_35, 2
%Temp_i32_29 = bitcast i8** %Temp_150 to i32*
%Temp_size_ptr_29 = getelementptr inbounds i32, i32* %Temp_i32_29, i32 0
%arr_size_29 = load i32, i32* %Temp_size_ptr_29,align 4
%sub_negative_29 = icmp slt i32  %Temp_151, 0
br i1 %sub_negative_29 , label %error_idx_29, label %positive_idx_29
positive_idx_29:
%out_of_bounds_29 = icmp sge i32 %Temp_151, %arr_size_29
br i1 %out_of_bounds_29 , label %error_idx_29, label %continue_idx_29
error_idx_29:
call void @AccessViolation()
br label %continue_idx_29
continue_idx_29:
  %Temp_152 = add nsw i32 %Temp_151,1
;getlement temp temp temp;
  %Temp_153 = getelementptr inbounds i8*, i8** %Temp_150, i32 %Temp_152
  %str_9 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.m, i32 0, i32 0), i8** %str_9, align 8
  %Temp_154 = load i8*, i8** %str_9, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_154, i8** %Temp_153, align 8
  %Temp_155 = load i8**, i8*** @str, align 8
%Temp_null_30 = bitcast i8** %Temp_155 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_156 = add nsw i32 %zero_36, 3
%Temp_i32_31 = bitcast i8** %Temp_155 to i32*
%Temp_size_ptr_31 = getelementptr inbounds i32, i32* %Temp_i32_31, i32 0
%arr_size_31 = load i32, i32* %Temp_size_ptr_31,align 4
%sub_negative_31 = icmp slt i32  %Temp_156, 0
br i1 %sub_negative_31 , label %error_idx_31, label %positive_idx_31
positive_idx_31:
%out_of_bounds_31 = icmp sge i32 %Temp_156, %arr_size_31
br i1 %out_of_bounds_31 , label %error_idx_31, label %continue_idx_31
error_idx_31:
call void @AccessViolation()
br label %continue_idx_31
continue_idx_31:
  %Temp_157 = add nsw i32 %Temp_156,1
;getlement temp temp temp;
  %Temp_158 = getelementptr inbounds i8*, i8** %Temp_155, i32 %Temp_157
  %str_10 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.p, i32 0, i32 0), i8** %str_10, align 8
  %Temp_159 = load i8*, i8** %str_10, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_159, i8** %Temp_158, align 8
  %Temp_160 = load i8**, i8*** @str, align 8
%Temp_null_32 = bitcast i8** %Temp_160 to i32*
%equal_null_32 = icmp eq i32* %Temp_null_32, null
br i1 %equal_null_32, label %null_deref_32, label %continue_32
null_deref_32:
call void @InvalidPointer()
br label %continue_32
continue_32:
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_161 = add nsw i32 %zero_37, 4
%Temp_i32_33 = bitcast i8** %Temp_160 to i32*
%Temp_size_ptr_33 = getelementptr inbounds i32, i32* %Temp_i32_33, i32 0
%arr_size_33 = load i32, i32* %Temp_size_ptr_33,align 4
%sub_negative_33 = icmp slt i32  %Temp_161, 0
br i1 %sub_negative_33 , label %error_idx_33, label %positive_idx_33
positive_idx_33:
%out_of_bounds_33 = icmp sge i32 %Temp_161, %arr_size_33
br i1 %out_of_bounds_33 , label %error_idx_33, label %continue_idx_33
error_idx_33:
call void @AccessViolation()
br label %continue_idx_33
continue_idx_33:
  %Temp_162 = add nsw i32 %Temp_161,1
;getlement temp temp temp;
  %Temp_163 = getelementptr inbounds i8*, i8** %Temp_160, i32 %Temp_162
  %str_11 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.i, i32 0, i32 0), i8** %str_11, align 8
  %Temp_164 = load i8*, i8** %str_11, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_164, i8** %Temp_163, align 8
  %Temp_165 = load i8**, i8*** @str, align 8
%Temp_null_34 = bitcast i8** %Temp_165 to i32*
%equal_null_34 = icmp eq i32* %Temp_null_34, null
br i1 %equal_null_34, label %null_deref_34, label %continue_34
null_deref_34:
call void @InvalidPointer()
br label %continue_34
continue_34:
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_166 = add nsw i32 %zero_38, 5
%Temp_i32_35 = bitcast i8** %Temp_165 to i32*
%Temp_size_ptr_35 = getelementptr inbounds i32, i32* %Temp_i32_35, i32 0
%arr_size_35 = load i32, i32* %Temp_size_ptr_35,align 4
%sub_negative_35 = icmp slt i32  %Temp_166, 0
br i1 %sub_negative_35 , label %error_idx_35, label %positive_idx_35
positive_idx_35:
%out_of_bounds_35 = icmp sge i32 %Temp_166, %arr_size_35
br i1 %out_of_bounds_35 , label %error_idx_35, label %continue_idx_35
error_idx_35:
call void @AccessViolation()
br label %continue_idx_35
continue_idx_35:
  %Temp_167 = add nsw i32 %Temp_166,1
;getlement temp temp temp;
  %Temp_168 = getelementptr inbounds i8*, i8** %Temp_165, i32 %Temp_167
  %str_12 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.l, i32 0, i32 0), i8** %str_12, align 8
  %Temp_169 = load i8*, i8** %str_12, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_169, i8** %Temp_168, align 8
  %Temp_170 = load i8**, i8*** @str, align 8
%Temp_null_36 = bitcast i8** %Temp_170 to i32*
%equal_null_36 = icmp eq i32* %Temp_null_36, null
br i1 %equal_null_36, label %null_deref_36, label %continue_36
null_deref_36:
call void @InvalidPointer()
br label %continue_36
continue_36:
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_171 = add nsw i32 %zero_39, 6
%Temp_i32_37 = bitcast i8** %Temp_170 to i32*
%Temp_size_ptr_37 = getelementptr inbounds i32, i32* %Temp_i32_37, i32 0
%arr_size_37 = load i32, i32* %Temp_size_ptr_37,align 4
%sub_negative_37 = icmp slt i32  %Temp_171, 0
br i1 %sub_negative_37 , label %error_idx_37, label %positive_idx_37
positive_idx_37:
%out_of_bounds_37 = icmp sge i32 %Temp_171, %arr_size_37
br i1 %out_of_bounds_37 , label %error_idx_37, label %continue_idx_37
error_idx_37:
call void @AccessViolation()
br label %continue_idx_37
continue_idx_37:
  %Temp_172 = add nsw i32 %Temp_171,1
;getlement temp temp temp;
  %Temp_173 = getelementptr inbounds i8*, i8** %Temp_170, i32 %Temp_172
  %str_13 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.a, i32 0, i32 0), i8** %str_13, align 8
  %Temp_174 = load i8*, i8** %str_13, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_174, i8** %Temp_173, align 8
  %Temp_175 = load i8**, i8*** @str, align 8
%Temp_null_38 = bitcast i8** %Temp_175 to i32*
%equal_null_38 = icmp eq i32* %Temp_null_38, null
br i1 %equal_null_38, label %null_deref_38, label %continue_38
null_deref_38:
call void @InvalidPointer()
br label %continue_38
continue_38:
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_176 = add nsw i32 %zero_40, 7
%Temp_i32_39 = bitcast i8** %Temp_175 to i32*
%Temp_size_ptr_39 = getelementptr inbounds i32, i32* %Temp_i32_39, i32 0
%arr_size_39 = load i32, i32* %Temp_size_ptr_39,align 4
%sub_negative_39 = icmp slt i32  %Temp_176, 0
br i1 %sub_negative_39 , label %error_idx_39, label %positive_idx_39
positive_idx_39:
%out_of_bounds_39 = icmp sge i32 %Temp_176, %arr_size_39
br i1 %out_of_bounds_39 , label %error_idx_39, label %continue_idx_39
error_idx_39:
call void @AccessViolation()
br label %continue_idx_39
continue_idx_39:
  %Temp_177 = add nsw i32 %Temp_176,1
;getlement temp temp temp;
  %Temp_178 = getelementptr inbounds i8*, i8** %Temp_175, i32 %Temp_177
  %str_14 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.t, i32 0, i32 0), i8** %str_14, align 8
  %Temp_179 = load i8*, i8** %str_14, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_179, i8** %Temp_178, align 8
  %Temp_180 = load i8**, i8*** @str, align 8
%Temp_null_40 = bitcast i8** %Temp_180 to i32*
%equal_null_40 = icmp eq i32* %Temp_null_40, null
br i1 %equal_null_40, label %null_deref_40, label %continue_40
null_deref_40:
call void @InvalidPointer()
br label %continue_40
continue_40:
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_181 = add nsw i32 %zero_41, 8
%Temp_i32_41 = bitcast i8** %Temp_180 to i32*
%Temp_size_ptr_41 = getelementptr inbounds i32, i32* %Temp_i32_41, i32 0
%arr_size_41 = load i32, i32* %Temp_size_ptr_41,align 4
%sub_negative_41 = icmp slt i32  %Temp_181, 0
br i1 %sub_negative_41 , label %error_idx_41, label %positive_idx_41
positive_idx_41:
%out_of_bounds_41 = icmp sge i32 %Temp_181, %arr_size_41
br i1 %out_of_bounds_41 , label %error_idx_41, label %continue_idx_41
error_idx_41:
call void @AccessViolation()
br label %continue_idx_41
continue_idx_41:
  %Temp_182 = add nsw i32 %Temp_181,1
;getlement temp temp temp;
  %Temp_183 = getelementptr inbounds i8*, i8** %Temp_180, i32 %Temp_182
  %str_15 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.i, i32 0, i32 0), i8** %str_15, align 8
  %Temp_184 = load i8*, i8** %str_15, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_184, i8** %Temp_183, align 8
  %Temp_185 = load i8**, i8*** @str, align 8
%Temp_null_42 = bitcast i8** %Temp_185 to i32*
%equal_null_42 = icmp eq i32* %Temp_null_42, null
br i1 %equal_null_42, label %null_deref_42, label %continue_42
null_deref_42:
call void @InvalidPointer()
br label %continue_42
continue_42:
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_186 = add nsw i32 %zero_42, 9
%Temp_i32_43 = bitcast i8** %Temp_185 to i32*
%Temp_size_ptr_43 = getelementptr inbounds i32, i32* %Temp_i32_43, i32 0
%arr_size_43 = load i32, i32* %Temp_size_ptr_43,align 4
%sub_negative_43 = icmp slt i32  %Temp_186, 0
br i1 %sub_negative_43 , label %error_idx_43, label %positive_idx_43
positive_idx_43:
%out_of_bounds_43 = icmp sge i32 %Temp_186, %arr_size_43
br i1 %out_of_bounds_43 , label %error_idx_43, label %continue_idx_43
error_idx_43:
call void @AccessViolation()
br label %continue_idx_43
continue_idx_43:
  %Temp_187 = add nsw i32 %Temp_186,1
;getlement temp temp temp;
  %Temp_188 = getelementptr inbounds i8*, i8** %Temp_185, i32 %Temp_187
  %str_16 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.o, i32 0, i32 0), i8** %str_16, align 8
  %Temp_189 = load i8*, i8** %str_16, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_189, i8** %Temp_188, align 8
  %Temp_190 = load i8**, i8*** @str, align 8
%Temp_null_44 = bitcast i8** %Temp_190 to i32*
%equal_null_44 = icmp eq i32* %Temp_null_44, null
br i1 %equal_null_44, label %null_deref_44, label %continue_44
null_deref_44:
call void @InvalidPointer()
br label %continue_44
continue_44:
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_191 = add nsw i32 %zero_43, 10
%Temp_i32_45 = bitcast i8** %Temp_190 to i32*
%Temp_size_ptr_45 = getelementptr inbounds i32, i32* %Temp_i32_45, i32 0
%arr_size_45 = load i32, i32* %Temp_size_ptr_45,align 4
%sub_negative_45 = icmp slt i32  %Temp_191, 0
br i1 %sub_negative_45 , label %error_idx_45, label %positive_idx_45
positive_idx_45:
%out_of_bounds_45 = icmp sge i32 %Temp_191, %arr_size_45
br i1 %out_of_bounds_45 , label %error_idx_45, label %continue_idx_45
error_idx_45:
call void @AccessViolation()
br label %continue_idx_45
continue_idx_45:
  %Temp_192 = add nsw i32 %Temp_191,1
;getlement temp temp temp;
  %Temp_193 = getelementptr inbounds i8*, i8** %Temp_190, i32 %Temp_192
  %str_17 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.n, i32 0, i32 0), i8** %str_17, align 8
  %Temp_194 = load i8*, i8** %str_17, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_194, i8** %Temp_193, align 8
  %Temp_195 = load i8**, i8*** @str, align 8
%Temp_null_46 = bitcast i8** %Temp_195 to i32*
%equal_null_46 = icmp eq i32* %Temp_null_46, null
br i1 %equal_null_46, label %null_deref_46, label %continue_46
null_deref_46:
call void @InvalidPointer()
br label %continue_46
continue_46:
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_196 = add nsw i32 %zero_44, 11
%Temp_i32_47 = bitcast i8** %Temp_195 to i32*
%Temp_size_ptr_47 = getelementptr inbounds i32, i32* %Temp_i32_47, i32 0
%arr_size_47 = load i32, i32* %Temp_size_ptr_47,align 4
%sub_negative_47 = icmp slt i32  %Temp_196, 0
br i1 %sub_negative_47 , label %error_idx_47, label %positive_idx_47
positive_idx_47:
%out_of_bounds_47 = icmp sge i32 %Temp_196, %arr_size_47
br i1 %out_of_bounds_47 , label %error_idx_47, label %continue_idx_47
error_idx_47:
call void @AccessViolation()
br label %continue_idx_47
continue_idx_47:
  %Temp_197 = add nsw i32 %Temp_196,1
;getlement temp temp temp;
  %Temp_198 = getelementptr inbounds i8*, i8** %Temp_195, i32 %Temp_197
  %str_18 = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @STR.terminate, i32 0, i32 0), i8** %str_18, align 8
  %Temp_199 = load i8*, i8** %str_18, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_199, i8** %Temp_198, align 8
  %Temp_200 = load i8**, i8*** @str, align 8
  call void @PrintCharArr(i8** %Temp_200 )
  %Temp_201 = load i8**, i8*** @str, align 8
%Temp_202 =call i32 @getCount(i8** %Temp_201 )
  store i32 %Temp_202, i32* %local_0, align 4
  %str_19 = alloca i8*
  store i8* getelementptr inbounds ([22 x i8], [22 x i8]* @STR.NumberOfVowelsFoundIs, i32 0, i32 0), i8** %str_19, align 8
  %Temp_203 = load i8*, i8** %str_19, align 8
  call void @PrintString(i8* %Temp_203 )
  %Temp_204 = load i32, i32* %local_0, align 4
  call void @PrintInt(i32 %Temp_204 )
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_206 = add nsw i32 %zero_45, 11
  %Temp_207 = add nsw i32 %Temp_206,1
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_208 = add nsw i32 %zero_46, 8
  %Temp_209 = mul nsw i32 %Temp_207, %Temp_208
  %Temp_210 = call i32* @malloc(i32 %Temp_209)
  %Temp_205 = bitcast i32* %Temp_210 to i8**
  %Temp_211 = getelementptr inbounds i32, i32* %Temp_210, i32 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
  store i32 %Temp_206, i32* %Temp_211, align 4
  store i8** %Temp_205, i8*** @str, align 8
  %Temp_212 = load i8**, i8*** @str, align 8
%Temp_null_48 = bitcast i8** %Temp_212 to i32*
%equal_null_48 = icmp eq i32* %Temp_null_48, null
br i1 %equal_null_48, label %null_deref_48, label %continue_48
null_deref_48:
call void @InvalidPointer()
br label %continue_48
continue_48:
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_213 = add nsw i32 %zero_47, 0
%Temp_i32_49 = bitcast i8** %Temp_212 to i32*
%Temp_size_ptr_49 = getelementptr inbounds i32, i32* %Temp_i32_49, i32 0
%arr_size_49 = load i32, i32* %Temp_size_ptr_49,align 4
%sub_negative_49 = icmp slt i32  %Temp_213, 0
br i1 %sub_negative_49 , label %error_idx_49, label %positive_idx_49
positive_idx_49:
%out_of_bounds_49 = icmp sge i32 %Temp_213, %arr_size_49
br i1 %out_of_bounds_49 , label %error_idx_49, label %continue_idx_49
error_idx_49:
call void @AccessViolation()
br label %continue_idx_49
continue_idx_49:
  %Temp_214 = add nsw i32 %Temp_213,1
;getlement temp temp temp;
  %Temp_215 = getelementptr inbounds i8*, i8** %Temp_212, i32 %Temp_214
  %str_20 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.a, i32 0, i32 0), i8** %str_20, align 8
  %Temp_216 = load i8*, i8** %str_20, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_216, i8** %Temp_215, align 8
  %Temp_217 = load i8**, i8*** @str, align 8
%Temp_null_50 = bitcast i8** %Temp_217 to i32*
%equal_null_50 = icmp eq i32* %Temp_null_50, null
br i1 %equal_null_50, label %null_deref_50, label %continue_50
null_deref_50:
call void @InvalidPointer()
br label %continue_50
continue_50:
  %zero_48 = load i32, i32* @my_zero, align 4
  %Temp_218 = add nsw i32 %zero_48, 1
%Temp_i32_51 = bitcast i8** %Temp_217 to i32*
%Temp_size_ptr_51 = getelementptr inbounds i32, i32* %Temp_i32_51, i32 0
%arr_size_51 = load i32, i32* %Temp_size_ptr_51,align 4
%sub_negative_51 = icmp slt i32  %Temp_218, 0
br i1 %sub_negative_51 , label %error_idx_51, label %positive_idx_51
positive_idx_51:
%out_of_bounds_51 = icmp sge i32 %Temp_218, %arr_size_51
br i1 %out_of_bounds_51 , label %error_idx_51, label %continue_idx_51
error_idx_51:
call void @AccessViolation()
br label %continue_idx_51
continue_idx_51:
  %Temp_219 = add nsw i32 %Temp_218,1
;getlement temp temp temp;
  %Temp_220 = getelementptr inbounds i8*, i8** %Temp_217, i32 %Temp_219
  %str_21 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.e, i32 0, i32 0), i8** %str_21, align 8
  %Temp_221 = load i8*, i8** %str_21, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_221, i8** %Temp_220, align 8
  %Temp_222 = load i8**, i8*** @str, align 8
%Temp_null_52 = bitcast i8** %Temp_222 to i32*
%equal_null_52 = icmp eq i32* %Temp_null_52, null
br i1 %equal_null_52, label %null_deref_52, label %continue_52
null_deref_52:
call void @InvalidPointer()
br label %continue_52
continue_52:
  %zero_49 = load i32, i32* @my_zero, align 4
  %Temp_223 = add nsw i32 %zero_49, 2
%Temp_i32_53 = bitcast i8** %Temp_222 to i32*
%Temp_size_ptr_53 = getelementptr inbounds i32, i32* %Temp_i32_53, i32 0
%arr_size_53 = load i32, i32* %Temp_size_ptr_53,align 4
%sub_negative_53 = icmp slt i32  %Temp_223, 0
br i1 %sub_negative_53 , label %error_idx_53, label %positive_idx_53
positive_idx_53:
%out_of_bounds_53 = icmp sge i32 %Temp_223, %arr_size_53
br i1 %out_of_bounds_53 , label %error_idx_53, label %continue_idx_53
error_idx_53:
call void @AccessViolation()
br label %continue_idx_53
continue_idx_53:
  %Temp_224 = add nsw i32 %Temp_223,1
;getlement temp temp temp;
  %Temp_225 = getelementptr inbounds i8*, i8** %Temp_222, i32 %Temp_224
  %str_22 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.i, i32 0, i32 0), i8** %str_22, align 8
  %Temp_226 = load i8*, i8** %str_22, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_226, i8** %Temp_225, align 8
  %Temp_227 = load i8**, i8*** @str, align 8
%Temp_null_54 = bitcast i8** %Temp_227 to i32*
%equal_null_54 = icmp eq i32* %Temp_null_54, null
br i1 %equal_null_54, label %null_deref_54, label %continue_54
null_deref_54:
call void @InvalidPointer()
br label %continue_54
continue_54:
  %zero_50 = load i32, i32* @my_zero, align 4
  %Temp_228 = add nsw i32 %zero_50, 3
%Temp_i32_55 = bitcast i8** %Temp_227 to i32*
%Temp_size_ptr_55 = getelementptr inbounds i32, i32* %Temp_i32_55, i32 0
%arr_size_55 = load i32, i32* %Temp_size_ptr_55,align 4
%sub_negative_55 = icmp slt i32  %Temp_228, 0
br i1 %sub_negative_55 , label %error_idx_55, label %positive_idx_55
positive_idx_55:
%out_of_bounds_55 = icmp sge i32 %Temp_228, %arr_size_55
br i1 %out_of_bounds_55 , label %error_idx_55, label %continue_idx_55
error_idx_55:
call void @AccessViolation()
br label %continue_idx_55
continue_idx_55:
  %Temp_229 = add nsw i32 %Temp_228,1
;getlement temp temp temp;
  %Temp_230 = getelementptr inbounds i8*, i8** %Temp_227, i32 %Temp_229
  %str_23 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.o, i32 0, i32 0), i8** %str_23, align 8
  %Temp_231 = load i8*, i8** %str_23, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_231, i8** %Temp_230, align 8
  %Temp_232 = load i8**, i8*** @str, align 8
%Temp_null_56 = bitcast i8** %Temp_232 to i32*
%equal_null_56 = icmp eq i32* %Temp_null_56, null
br i1 %equal_null_56, label %null_deref_56, label %continue_56
null_deref_56:
call void @InvalidPointer()
br label %continue_56
continue_56:
  %zero_51 = load i32, i32* @my_zero, align 4
  %Temp_233 = add nsw i32 %zero_51, 4
%Temp_i32_57 = bitcast i8** %Temp_232 to i32*
%Temp_size_ptr_57 = getelementptr inbounds i32, i32* %Temp_i32_57, i32 0
%arr_size_57 = load i32, i32* %Temp_size_ptr_57,align 4
%sub_negative_57 = icmp slt i32  %Temp_233, 0
br i1 %sub_negative_57 , label %error_idx_57, label %positive_idx_57
positive_idx_57:
%out_of_bounds_57 = icmp sge i32 %Temp_233, %arr_size_57
br i1 %out_of_bounds_57 , label %error_idx_57, label %continue_idx_57
error_idx_57:
call void @AccessViolation()
br label %continue_idx_57
continue_idx_57:
  %Temp_234 = add nsw i32 %Temp_233,1
;getlement temp temp temp;
  %Temp_235 = getelementptr inbounds i8*, i8** %Temp_232, i32 %Temp_234
  %str_24 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.u, i32 0, i32 0), i8** %str_24, align 8
  %Temp_236 = load i8*, i8** %str_24, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_236, i8** %Temp_235, align 8
  %Temp_237 = load i8**, i8*** @str, align 8
%Temp_null_58 = bitcast i8** %Temp_237 to i32*
%equal_null_58 = icmp eq i32* %Temp_null_58, null
br i1 %equal_null_58, label %null_deref_58, label %continue_58
null_deref_58:
call void @InvalidPointer()
br label %continue_58
continue_58:
  %zero_52 = load i32, i32* @my_zero, align 4
  %Temp_238 = add nsw i32 %zero_52, 5
%Temp_i32_59 = bitcast i8** %Temp_237 to i32*
%Temp_size_ptr_59 = getelementptr inbounds i32, i32* %Temp_i32_59, i32 0
%arr_size_59 = load i32, i32* %Temp_size_ptr_59,align 4
%sub_negative_59 = icmp slt i32  %Temp_238, 0
br i1 %sub_negative_59 , label %error_idx_59, label %positive_idx_59
positive_idx_59:
%out_of_bounds_59 = icmp sge i32 %Temp_238, %arr_size_59
br i1 %out_of_bounds_59 , label %error_idx_59, label %continue_idx_59
error_idx_59:
call void @AccessViolation()
br label %continue_idx_59
continue_idx_59:
  %Temp_239 = add nsw i32 %Temp_238,1
;getlement temp temp temp;
  %Temp_240 = getelementptr inbounds i8*, i8** %Temp_237, i32 %Temp_239
  %str_25 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.a, i32 0, i32 0), i8** %str_25, align 8
  %Temp_241 = load i8*, i8** %str_25, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_241, i8** %Temp_240, align 8
  %Temp_242 = load i8**, i8*** @str, align 8
%Temp_null_60 = bitcast i8** %Temp_242 to i32*
%equal_null_60 = icmp eq i32* %Temp_null_60, null
br i1 %equal_null_60, label %null_deref_60, label %continue_60
null_deref_60:
call void @InvalidPointer()
br label %continue_60
continue_60:
  %zero_53 = load i32, i32* @my_zero, align 4
  %Temp_243 = add nsw i32 %zero_53, 6
%Temp_i32_61 = bitcast i8** %Temp_242 to i32*
%Temp_size_ptr_61 = getelementptr inbounds i32, i32* %Temp_i32_61, i32 0
%arr_size_61 = load i32, i32* %Temp_size_ptr_61,align 4
%sub_negative_61 = icmp slt i32  %Temp_243, 0
br i1 %sub_negative_61 , label %error_idx_61, label %positive_idx_61
positive_idx_61:
%out_of_bounds_61 = icmp sge i32 %Temp_243, %arr_size_61
br i1 %out_of_bounds_61 , label %error_idx_61, label %continue_idx_61
error_idx_61:
call void @AccessViolation()
br label %continue_idx_61
continue_idx_61:
  %Temp_244 = add nsw i32 %Temp_243,1
;getlement temp temp temp;
  %Temp_245 = getelementptr inbounds i8*, i8** %Temp_242, i32 %Temp_244
  %str_26 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.e, i32 0, i32 0), i8** %str_26, align 8
  %Temp_246 = load i8*, i8** %str_26, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_246, i8** %Temp_245, align 8
  %Temp_247 = load i8**, i8*** @str, align 8
%Temp_null_62 = bitcast i8** %Temp_247 to i32*
%equal_null_62 = icmp eq i32* %Temp_null_62, null
br i1 %equal_null_62, label %null_deref_62, label %continue_62
null_deref_62:
call void @InvalidPointer()
br label %continue_62
continue_62:
  %zero_54 = load i32, i32* @my_zero, align 4
  %Temp_248 = add nsw i32 %zero_54, 7
%Temp_i32_63 = bitcast i8** %Temp_247 to i32*
%Temp_size_ptr_63 = getelementptr inbounds i32, i32* %Temp_i32_63, i32 0
%arr_size_63 = load i32, i32* %Temp_size_ptr_63,align 4
%sub_negative_63 = icmp slt i32  %Temp_248, 0
br i1 %sub_negative_63 , label %error_idx_63, label %positive_idx_63
positive_idx_63:
%out_of_bounds_63 = icmp sge i32 %Temp_248, %arr_size_63
br i1 %out_of_bounds_63 , label %error_idx_63, label %continue_idx_63
error_idx_63:
call void @AccessViolation()
br label %continue_idx_63
continue_idx_63:
  %Temp_249 = add nsw i32 %Temp_248,1
;getlement temp temp temp;
  %Temp_250 = getelementptr inbounds i8*, i8** %Temp_247, i32 %Temp_249
  %str_27 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.i, i32 0, i32 0), i8** %str_27, align 8
  %Temp_251 = load i8*, i8** %str_27, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_251, i8** %Temp_250, align 8
  %Temp_252 = load i8**, i8*** @str, align 8
%Temp_null_64 = bitcast i8** %Temp_252 to i32*
%equal_null_64 = icmp eq i32* %Temp_null_64, null
br i1 %equal_null_64, label %null_deref_64, label %continue_64
null_deref_64:
call void @InvalidPointer()
br label %continue_64
continue_64:
  %zero_55 = load i32, i32* @my_zero, align 4
  %Temp_253 = add nsw i32 %zero_55, 8
%Temp_i32_65 = bitcast i8** %Temp_252 to i32*
%Temp_size_ptr_65 = getelementptr inbounds i32, i32* %Temp_i32_65, i32 0
%arr_size_65 = load i32, i32* %Temp_size_ptr_65,align 4
%sub_negative_65 = icmp slt i32  %Temp_253, 0
br i1 %sub_negative_65 , label %error_idx_65, label %positive_idx_65
positive_idx_65:
%out_of_bounds_65 = icmp sge i32 %Temp_253, %arr_size_65
br i1 %out_of_bounds_65 , label %error_idx_65, label %continue_idx_65
error_idx_65:
call void @AccessViolation()
br label %continue_idx_65
continue_idx_65:
  %Temp_254 = add nsw i32 %Temp_253,1
;getlement temp temp temp;
  %Temp_255 = getelementptr inbounds i8*, i8** %Temp_252, i32 %Temp_254
  %str_28 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.o, i32 0, i32 0), i8** %str_28, align 8
  %Temp_256 = load i8*, i8** %str_28, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_256, i8** %Temp_255, align 8
  %Temp_257 = load i8**, i8*** @str, align 8
%Temp_null_66 = bitcast i8** %Temp_257 to i32*
%equal_null_66 = icmp eq i32* %Temp_null_66, null
br i1 %equal_null_66, label %null_deref_66, label %continue_66
null_deref_66:
call void @InvalidPointer()
br label %continue_66
continue_66:
  %zero_56 = load i32, i32* @my_zero, align 4
  %Temp_258 = add nsw i32 %zero_56, 9
%Temp_i32_67 = bitcast i8** %Temp_257 to i32*
%Temp_size_ptr_67 = getelementptr inbounds i32, i32* %Temp_i32_67, i32 0
%arr_size_67 = load i32, i32* %Temp_size_ptr_67,align 4
%sub_negative_67 = icmp slt i32  %Temp_258, 0
br i1 %sub_negative_67 , label %error_idx_67, label %positive_idx_67
positive_idx_67:
%out_of_bounds_67 = icmp sge i32 %Temp_258, %arr_size_67
br i1 %out_of_bounds_67 , label %error_idx_67, label %continue_idx_67
error_idx_67:
call void @AccessViolation()
br label %continue_idx_67
continue_idx_67:
  %Temp_259 = add nsw i32 %Temp_258,1
;getlement temp temp temp;
  %Temp_260 = getelementptr inbounds i8*, i8** %Temp_257, i32 %Temp_259
  %str_29 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.u, i32 0, i32 0), i8** %str_29, align 8
  %Temp_261 = load i8*, i8** %str_29, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_261, i8** %Temp_260, align 8
  %Temp_262 = load i8**, i8*** @str, align 8
%Temp_null_68 = bitcast i8** %Temp_262 to i32*
%equal_null_68 = icmp eq i32* %Temp_null_68, null
br i1 %equal_null_68, label %null_deref_68, label %continue_68
null_deref_68:
call void @InvalidPointer()
br label %continue_68
continue_68:
  %zero_57 = load i32, i32* @my_zero, align 4
  %Temp_263 = add nsw i32 %zero_57, 10
%Temp_i32_69 = bitcast i8** %Temp_262 to i32*
%Temp_size_ptr_69 = getelementptr inbounds i32, i32* %Temp_i32_69, i32 0
%arr_size_69 = load i32, i32* %Temp_size_ptr_69,align 4
%sub_negative_69 = icmp slt i32  %Temp_263, 0
br i1 %sub_negative_69 , label %error_idx_69, label %positive_idx_69
positive_idx_69:
%out_of_bounds_69 = icmp sge i32 %Temp_263, %arr_size_69
br i1 %out_of_bounds_69 , label %error_idx_69, label %continue_idx_69
error_idx_69:
call void @AccessViolation()
br label %continue_idx_69
continue_idx_69:
  %Temp_264 = add nsw i32 %Temp_263,1
;getlement temp temp temp;
  %Temp_265 = getelementptr inbounds i8*, i8** %Temp_262, i32 %Temp_264
  %str_30 = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @STR.terminate, i32 0, i32 0), i8** %str_30, align 8
  %Temp_266 = load i8*, i8** %str_30, align 8
;store TYPES.TYPE_STRING@31221be2 dst src;
  store i8* %Temp_266, i8** %Temp_265, align 8
  %Temp_267 = load i8**, i8*** @str, align 8
  call void @PrintCharArr(i8** %Temp_267 )
  %Temp_268 = load i8**, i8*** @str, align 8
%Temp_269 =call i32 @getCount(i8** %Temp_268 )
  store i32 %Temp_269, i32* %local_0, align 4
  %str_31 = alloca i8*
  store i8* getelementptr inbounds ([22 x i8], [22 x i8]* @STR.NumberOfVowelsFoundIs, i32 0, i32 0), i8** %str_31, align 8
  %Temp_270 = load i8*, i8** %str_31, align 8
  call void @PrintString(i8* %Temp_270 )
  %Temp_271 = load i32, i32* %local_0, align 4
  call void @PrintInt(i32 %Temp_271 )
call void @exit(i32 0)
  ret void
}
