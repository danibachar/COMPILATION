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

define i32 @search(i32*,i32,i32)
 { 
  %data = alloca i32*, align 8
  %size = alloca i32, align 4
  %key = alloca i32, align 4
  %local_0 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_2 = alloca i32, align 4
  store i32* %0, i32** %data, align 8
  store i32 %1, i32* %size, align 4
  store i32 %2, i32* %key, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 0
  store i32 %Temp_0, i32* %local_0, align 4
  %Temp_2 = load i32, i32* %size, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 1
  %Temp_1 = sub nsw i32 %Temp_2, %Temp_3
%Temp_4 = call i32 @CheckOverflow(i32 %Temp_1)
  store i32 %Temp_4, i32* %local_1, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_6 = load i32, i32* %local_1, align 4
  %Temp_8 = load i32, i32* %local_0, align 4
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_2, 1
  %Temp_7 = sub nsw i32 %Temp_8, %Temp_9
%Temp_10 = call i32 @CheckOverflow(i32 %Temp_7)
  %Temp_5 = icmp slt i32 %Temp_10, %Temp_6
  %Temp_11 = zext i1 %Temp_5 to i32
  %equal_zero_3 = icmp eq i32 %Temp_11, 0
  br i1 %equal_zero_3, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_14 = load i32, i32* %local_0, align 4
  %Temp_15 = load i32, i32* %local_1, align 4
  %Temp_13 = add nsw i32 %Temp_14, %Temp_15
%Temp_16 = call i32 @CheckOverflow(i32 %Temp_13)
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_4, 2
%is_div_zero_0 = icmp eq i32  %Temp_17, 0
br i1 %is_div_zero_0 , label %div_by_zero_0, label %good_div_0
div_by_zero_0:
call void @DivideByZero()
br label %good_div_0
good_div_0:
  %Temp_12 = sdiv i32 %Temp_16, %Temp_17
%Temp_18 = call i32 @CheckOverflow(i32 %Temp_12)
  store i32 %Temp_18, i32* %local_2, align 4
  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_20 = load i32*, i32** %data, align 8
%Temp_null_0 = bitcast i32* %Temp_20 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %Temp_21 = load i32, i32* %local_2, align 4
%Temp_i32_1 = bitcast i32* %Temp_20 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_21, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_21, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_22 = add nsw i32 %Temp_21,1
;getlement temp temp temp;
  %Temp_23 = getelementptr inbounds i32, i32* %Temp_20, i32 %Temp_22
  %Temp_24 = load i32, i32* %key, align 4
;load temp temp;
  %Temp_25 = load i32, i32* %Temp_23, align 4
  %Temp_19 = icmp eq i32 %Temp_25, %Temp_24
  %Temp_26 = zext i1 %Temp_19 to i32
  %equal_zero_5 = icmp eq i32 %Temp_26, 0
  br i1 %equal_zero_5, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_6, 1
  ret i32 %Temp_27
  br label %Label_5_if.exit

Label_5_if.exit:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_29 = load i32*, i32** %data, align 8
%Temp_null_2 = bitcast i32* %Temp_29 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %Temp_30 = load i32, i32* %local_2, align 4
%Temp_i32_3 = bitcast i32* %Temp_29 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_30, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_30, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_31 = add nsw i32 %Temp_30,1
;getlement temp temp temp;
  %Temp_32 = getelementptr inbounds i32, i32* %Temp_29, i32 %Temp_31
  %Temp_33 = load i32, i32* %key, align 4
;load temp temp;
  %Temp_34 = load i32, i32* %Temp_32, align 4
  %Temp_28 = icmp slt i32 %Temp_34, %Temp_33
  %Temp_35 = zext i1 %Temp_28 to i32
  %equal_zero_7 = icmp eq i32 %Temp_35, 0
  br i1 %equal_zero_7, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %Temp_37 = load i32, i32* %local_2, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_8, 1
  %Temp_36 = add nsw i32 %Temp_37, %Temp_38
%Temp_39 = call i32 @CheckOverflow(i32 %Temp_36)
  store i32 %Temp_39, i32* %local_0, align 4
  br label %Label_8_if.exit

Label_8_if.exit:

  br label %Label_9_if.cond

Label_9_if.cond:

  %Temp_41 = load i32*, i32** %data, align 8
%Temp_null_4 = bitcast i32* %Temp_41 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %Temp_42 = load i32, i32* %local_2, align 4
%Temp_i32_5 = bitcast i32* %Temp_41 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_42, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_42, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_43 = add nsw i32 %Temp_42,1
;getlement temp temp temp;
  %Temp_44 = getelementptr inbounds i32, i32* %Temp_41, i32 %Temp_43
  %Temp_45 = load i32, i32* %key, align 4
;load temp temp;
  %Temp_46 = load i32, i32* %Temp_44, align 4
  %Temp_40 = icmp slt i32 %Temp_45, %Temp_46
  %Temp_47 = zext i1 %Temp_40 to i32
  %equal_zero_9 = icmp eq i32 %Temp_47, 0
  br i1 %equal_zero_9, label %Label_11_if.exit, label %Label_10_if.body
  
Label_10_if.body:

  %Temp_49 = load i32, i32* %local_2, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_50 = add nsw i32 %zero_10, 1
  %Temp_48 = sub nsw i32 %Temp_49, %Temp_50
%Temp_51 = call i32 @CheckOverflow(i32 %Temp_48)
  store i32 %Temp_51, i32* %local_1, align 4
  br label %Label_11_if.exit

Label_11_if.exit:

  br label %Label_2_while.cond

Label_0_while.end:

  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_52 = add nsw i32 %zero_11, 0
  ret i32 %Temp_52
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i32*, align 8
  call void @init_globals()
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_12, 17
  %Temp_55 = add nsw i32 %Temp_54,1
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_13, 8
  %Temp_57 = mul nsw i32 %Temp_55, %Temp_56
  %Temp_58 = call i32* @malloc(i32 %Temp_57)
  %Temp_53 = bitcast i32* %Temp_58 to i32*
  %Temp_59 = getelementptr inbounds i32, i32* %Temp_58, i32 0
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_54, i32* %Temp_59, align 4
  store i32* %Temp_53, i32** %local_0, align 8
  %Temp_60 = load i32*, i32** %local_0, align 8
%Temp_null_6 = bitcast i32* %Temp_60 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_61 = add nsw i32 %zero_14, 0
%Temp_i32_7 = bitcast i32* %Temp_60 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_61, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_61, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_62 = add nsw i32 %Temp_61,1
;getlement temp temp temp;
  %Temp_63 = getelementptr inbounds i32, i32* %Temp_60, i32 %Temp_62
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_64 = add nsw i32 %zero_15, -9999
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_64, i32* %Temp_63, align 4
  %Temp_65 = load i32*, i32** %local_0, align 8
%Temp_null_8 = bitcast i32* %Temp_65 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_66 = add nsw i32 %zero_16, 1
%Temp_i32_9 = bitcast i32* %Temp_65 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_66, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_66, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_67 = add nsw i32 %Temp_66,1
;getlement temp temp temp;
  %Temp_68 = getelementptr inbounds i32, i32* %Temp_65, i32 %Temp_67
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_69 = add nsw i32 %zero_17, -2334
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_69, i32* %Temp_68, align 4
  %Temp_70 = load i32*, i32** %local_0, align 8
%Temp_null_10 = bitcast i32* %Temp_70 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_18, 2
%Temp_i32_11 = bitcast i32* %Temp_70 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_71, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_71, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_72 = add nsw i32 %Temp_71,1
;getlement temp temp temp;
  %Temp_73 = getelementptr inbounds i32, i32* %Temp_70, i32 %Temp_72
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_74 = add nsw i32 %zero_19, -999
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_74, i32* %Temp_73, align 4
  %Temp_75 = load i32*, i32** %local_0, align 8
%Temp_null_12 = bitcast i32* %Temp_75 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_76 = add nsw i32 %zero_20, 3
%Temp_i32_13 = bitcast i32* %Temp_75 to i32*
%Temp_size_ptr_13 = getelementptr inbounds i32, i32* %Temp_i32_13, i32 0
%arr_size_13 = load i32, i32* %Temp_size_ptr_13,align 4
%sub_negative_13 = icmp slt i32  %Temp_76, 0
br i1 %sub_negative_13 , label %error_idx_13, label %positive_idx_13
positive_idx_13:
%out_of_bounds_13 = icmp sge i32 %Temp_76, %arr_size_13
br i1 %out_of_bounds_13 , label %error_idx_13, label %continue_idx_13
error_idx_13:
call void @AccessViolation()
br label %continue_idx_13
continue_idx_13:
  %Temp_77 = add nsw i32 %Temp_76,1
;getlement temp temp temp;
  %Temp_78 = getelementptr inbounds i32, i32* %Temp_75, i32 %Temp_77
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_79 = add nsw i32 %zero_21, -314
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_79, i32* %Temp_78, align 4
  %Temp_80 = load i32*, i32** %local_0, align 8
%Temp_null_14 = bitcast i32* %Temp_80 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_22, 4
%Temp_i32_15 = bitcast i32* %Temp_80 to i32*
%Temp_size_ptr_15 = getelementptr inbounds i32, i32* %Temp_i32_15, i32 0
%arr_size_15 = load i32, i32* %Temp_size_ptr_15,align 4
%sub_negative_15 = icmp slt i32  %Temp_81, 0
br i1 %sub_negative_15 , label %error_idx_15, label %positive_idx_15
positive_idx_15:
%out_of_bounds_15 = icmp sge i32 %Temp_81, %arr_size_15
br i1 %out_of_bounds_15 , label %error_idx_15, label %continue_idx_15
error_idx_15:
call void @AccessViolation()
br label %continue_idx_15
continue_idx_15:
  %Temp_82 = add nsw i32 %Temp_81,1
;getlement temp temp temp;
  %Temp_83 = getelementptr inbounds i32, i32* %Temp_80, i32 %Temp_82
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_23, -34
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_84, i32* %Temp_83, align 4
  %Temp_85 = load i32*, i32** %local_0, align 8
%Temp_null_16 = bitcast i32* %Temp_85 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_24, 5
%Temp_i32_17 = bitcast i32* %Temp_85 to i32*
%Temp_size_ptr_17 = getelementptr inbounds i32, i32* %Temp_i32_17, i32 0
%arr_size_17 = load i32, i32* %Temp_size_ptr_17,align 4
%sub_negative_17 = icmp slt i32  %Temp_86, 0
br i1 %sub_negative_17 , label %error_idx_17, label %positive_idx_17
positive_idx_17:
%out_of_bounds_17 = icmp sge i32 %Temp_86, %arr_size_17
br i1 %out_of_bounds_17 , label %error_idx_17, label %continue_idx_17
error_idx_17:
call void @AccessViolation()
br label %continue_idx_17
continue_idx_17:
  %Temp_87 = add nsw i32 %Temp_86,1
;getlement temp temp temp;
  %Temp_88 = getelementptr inbounds i32, i32* %Temp_85, i32 %Temp_87
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_89 = add nsw i32 %zero_25, 0
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_89, i32* %Temp_88, align 4
  %Temp_90 = load i32*, i32** %local_0, align 8
%Temp_null_18 = bitcast i32* %Temp_90 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_26, 6
%Temp_i32_19 = bitcast i32* %Temp_90 to i32*
%Temp_size_ptr_19 = getelementptr inbounds i32, i32* %Temp_i32_19, i32 0
%arr_size_19 = load i32, i32* %Temp_size_ptr_19,align 4
%sub_negative_19 = icmp slt i32  %Temp_91, 0
br i1 %sub_negative_19 , label %error_idx_19, label %positive_idx_19
positive_idx_19:
%out_of_bounds_19 = icmp sge i32 %Temp_91, %arr_size_19
br i1 %out_of_bounds_19 , label %error_idx_19, label %continue_idx_19
error_idx_19:
call void @AccessViolation()
br label %continue_idx_19
continue_idx_19:
  %Temp_92 = add nsw i32 %Temp_91,1
;getlement temp temp temp;
  %Temp_93 = getelementptr inbounds i32, i32* %Temp_90, i32 %Temp_92
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_94 = add nsw i32 %zero_27, 232
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_94, i32* %Temp_93, align 4
  %Temp_95 = load i32*, i32** %local_0, align 8
%Temp_null_20 = bitcast i32* %Temp_95 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_96 = add nsw i32 %zero_28, 7
%Temp_i32_21 = bitcast i32* %Temp_95 to i32*
%Temp_size_ptr_21 = getelementptr inbounds i32, i32* %Temp_i32_21, i32 0
%arr_size_21 = load i32, i32* %Temp_size_ptr_21,align 4
%sub_negative_21 = icmp slt i32  %Temp_96, 0
br i1 %sub_negative_21 , label %error_idx_21, label %positive_idx_21
positive_idx_21:
%out_of_bounds_21 = icmp sge i32 %Temp_96, %arr_size_21
br i1 %out_of_bounds_21 , label %error_idx_21, label %continue_idx_21
error_idx_21:
call void @AccessViolation()
br label %continue_idx_21
continue_idx_21:
  %Temp_97 = add nsw i32 %Temp_96,1
;getlement temp temp temp;
  %Temp_98 = getelementptr inbounds i32, i32* %Temp_95, i32 %Temp_97
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_99 = add nsw i32 %zero_29, 300
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_99, i32* %Temp_98, align 4
  %Temp_100 = load i32*, i32** %local_0, align 8
%Temp_null_22 = bitcast i32* %Temp_100 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_101 = add nsw i32 %zero_30, 8
%Temp_i32_23 = bitcast i32* %Temp_100 to i32*
%Temp_size_ptr_23 = getelementptr inbounds i32, i32* %Temp_i32_23, i32 0
%arr_size_23 = load i32, i32* %Temp_size_ptr_23,align 4
%sub_negative_23 = icmp slt i32  %Temp_101, 0
br i1 %sub_negative_23 , label %error_idx_23, label %positive_idx_23
positive_idx_23:
%out_of_bounds_23 = icmp sge i32 %Temp_101, %arr_size_23
br i1 %out_of_bounds_23 , label %error_idx_23, label %continue_idx_23
error_idx_23:
call void @AccessViolation()
br label %continue_idx_23
continue_idx_23:
  %Temp_102 = add nsw i32 %Temp_101,1
;getlement temp temp temp;
  %Temp_103 = getelementptr inbounds i32, i32* %Temp_100, i32 %Temp_102
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_104 = add nsw i32 %zero_31, 400
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_104, i32* %Temp_103, align 4
  %Temp_105 = load i32*, i32** %local_0, align 8
%Temp_null_24 = bitcast i32* %Temp_105 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_106 = add nsw i32 %zero_32, 9
%Temp_i32_25 = bitcast i32* %Temp_105 to i32*
%Temp_size_ptr_25 = getelementptr inbounds i32, i32* %Temp_i32_25, i32 0
%arr_size_25 = load i32, i32* %Temp_size_ptr_25,align 4
%sub_negative_25 = icmp slt i32  %Temp_106, 0
br i1 %sub_negative_25 , label %error_idx_25, label %positive_idx_25
positive_idx_25:
%out_of_bounds_25 = icmp sge i32 %Temp_106, %arr_size_25
br i1 %out_of_bounds_25 , label %error_idx_25, label %continue_idx_25
error_idx_25:
call void @AccessViolation()
br label %continue_idx_25
continue_idx_25:
  %Temp_107 = add nsw i32 %Temp_106,1
;getlement temp temp temp;
  %Temp_108 = getelementptr inbounds i32, i32* %Temp_105, i32 %Temp_107
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_109 = add nsw i32 %zero_33, 500
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_109, i32* %Temp_108, align 4
  %Temp_110 = load i32*, i32** %local_0, align 8
%Temp_null_26 = bitcast i32* %Temp_110 to i32*
%equal_null_26 = icmp eq i32* %Temp_null_26, null
br i1 %equal_null_26, label %null_deref_26, label %continue_26
null_deref_26:
call void @InvalidPointer()
br label %continue_26
continue_26:
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_34, 10
%Temp_i32_27 = bitcast i32* %Temp_110 to i32*
%Temp_size_ptr_27 = getelementptr inbounds i32, i32* %Temp_i32_27, i32 0
%arr_size_27 = load i32, i32* %Temp_size_ptr_27,align 4
%sub_negative_27 = icmp slt i32  %Temp_111, 0
br i1 %sub_negative_27 , label %error_idx_27, label %positive_idx_27
positive_idx_27:
%out_of_bounds_27 = icmp sge i32 %Temp_111, %arr_size_27
br i1 %out_of_bounds_27 , label %error_idx_27, label %continue_idx_27
error_idx_27:
call void @AccessViolation()
br label %continue_idx_27
continue_idx_27:
  %Temp_112 = add nsw i32 %Temp_111,1
;getlement temp temp temp;
  %Temp_113 = getelementptr inbounds i32, i32* %Temp_110, i32 %Temp_112
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_114 = add nsw i32 %zero_35, 999
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_114, i32* %Temp_113, align 4
  %Temp_115 = load i32*, i32** %local_0, align 8
%Temp_null_28 = bitcast i32* %Temp_115 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_116 = add nsw i32 %zero_36, 11
%Temp_i32_29 = bitcast i32* %Temp_115 to i32*
%Temp_size_ptr_29 = getelementptr inbounds i32, i32* %Temp_i32_29, i32 0
%arr_size_29 = load i32, i32* %Temp_size_ptr_29,align 4
%sub_negative_29 = icmp slt i32  %Temp_116, 0
br i1 %sub_negative_29 , label %error_idx_29, label %positive_idx_29
positive_idx_29:
%out_of_bounds_29 = icmp sge i32 %Temp_116, %arr_size_29
br i1 %out_of_bounds_29 , label %error_idx_29, label %continue_idx_29
error_idx_29:
call void @AccessViolation()
br label %continue_idx_29
continue_idx_29:
  %Temp_117 = add nsw i32 %Temp_116,1
;getlement temp temp temp;
  %Temp_118 = getelementptr inbounds i32, i32* %Temp_115, i32 %Temp_117
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_119 = add nsw i32 %zero_37, 1000
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_119, i32* %Temp_118, align 4
  %Temp_120 = load i32*, i32** %local_0, align 8
%Temp_null_30 = bitcast i32* %Temp_120 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_121 = add nsw i32 %zero_38, 12
%Temp_i32_31 = bitcast i32* %Temp_120 to i32*
%Temp_size_ptr_31 = getelementptr inbounds i32, i32* %Temp_i32_31, i32 0
%arr_size_31 = load i32, i32* %Temp_size_ptr_31,align 4
%sub_negative_31 = icmp slt i32  %Temp_121, 0
br i1 %sub_negative_31 , label %error_idx_31, label %positive_idx_31
positive_idx_31:
%out_of_bounds_31 = icmp sge i32 %Temp_121, %arr_size_31
br i1 %out_of_bounds_31 , label %error_idx_31, label %continue_idx_31
error_idx_31:
call void @AccessViolation()
br label %continue_idx_31
continue_idx_31:
  %Temp_122 = add nsw i32 %Temp_121,1
;getlement temp temp temp;
  %Temp_123 = getelementptr inbounds i32, i32* %Temp_120, i32 %Temp_122
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_124 = add nsw i32 %zero_39, 1220
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_124, i32* %Temp_123, align 4
  %Temp_125 = load i32*, i32** %local_0, align 8
%Temp_null_32 = bitcast i32* %Temp_125 to i32*
%equal_null_32 = icmp eq i32* %Temp_null_32, null
br i1 %equal_null_32, label %null_deref_32, label %continue_32
null_deref_32:
call void @InvalidPointer()
br label %continue_32
continue_32:
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_126 = add nsw i32 %zero_40, 13
%Temp_i32_33 = bitcast i32* %Temp_125 to i32*
%Temp_size_ptr_33 = getelementptr inbounds i32, i32* %Temp_i32_33, i32 0
%arr_size_33 = load i32, i32* %Temp_size_ptr_33,align 4
%sub_negative_33 = icmp slt i32  %Temp_126, 0
br i1 %sub_negative_33 , label %error_idx_33, label %positive_idx_33
positive_idx_33:
%out_of_bounds_33 = icmp sge i32 %Temp_126, %arr_size_33
br i1 %out_of_bounds_33 , label %error_idx_33, label %continue_idx_33
error_idx_33:
call void @AccessViolation()
br label %continue_idx_33
continue_idx_33:
  %Temp_127 = add nsw i32 %Temp_126,1
;getlement temp temp temp;
  %Temp_128 = getelementptr inbounds i32, i32* %Temp_125, i32 %Temp_127
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_129 = add nsw i32 %zero_41, 1430
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_129, i32* %Temp_128, align 4
  %Temp_130 = load i32*, i32** %local_0, align 8
%Temp_null_34 = bitcast i32* %Temp_130 to i32*
%equal_null_34 = icmp eq i32* %Temp_null_34, null
br i1 %equal_null_34, label %null_deref_34, label %continue_34
null_deref_34:
call void @InvalidPointer()
br label %continue_34
continue_34:
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_131 = add nsw i32 %zero_42, 14
%Temp_i32_35 = bitcast i32* %Temp_130 to i32*
%Temp_size_ptr_35 = getelementptr inbounds i32, i32* %Temp_i32_35, i32 0
%arr_size_35 = load i32, i32* %Temp_size_ptr_35,align 4
%sub_negative_35 = icmp slt i32  %Temp_131, 0
br i1 %sub_negative_35 , label %error_idx_35, label %positive_idx_35
positive_idx_35:
%out_of_bounds_35 = icmp sge i32 %Temp_131, %arr_size_35
br i1 %out_of_bounds_35 , label %error_idx_35, label %continue_idx_35
error_idx_35:
call void @AccessViolation()
br label %continue_idx_35
continue_idx_35:
  %Temp_132 = add nsw i32 %Temp_131,1
;getlement temp temp temp;
  %Temp_133 = getelementptr inbounds i32, i32* %Temp_130, i32 %Temp_132
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_134 = add nsw i32 %zero_43, 2220
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_134, i32* %Temp_133, align 4
  %Temp_135 = load i32*, i32** %local_0, align 8
%Temp_null_36 = bitcast i32* %Temp_135 to i32*
%equal_null_36 = icmp eq i32* %Temp_null_36, null
br i1 %equal_null_36, label %null_deref_36, label %continue_36
null_deref_36:
call void @InvalidPointer()
br label %continue_36
continue_36:
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_136 = add nsw i32 %zero_44, 15
%Temp_i32_37 = bitcast i32* %Temp_135 to i32*
%Temp_size_ptr_37 = getelementptr inbounds i32, i32* %Temp_i32_37, i32 0
%arr_size_37 = load i32, i32* %Temp_size_ptr_37,align 4
%sub_negative_37 = icmp slt i32  %Temp_136, 0
br i1 %sub_negative_37 , label %error_idx_37, label %positive_idx_37
positive_idx_37:
%out_of_bounds_37 = icmp sge i32 %Temp_136, %arr_size_37
br i1 %out_of_bounds_37 , label %error_idx_37, label %continue_idx_37
error_idx_37:
call void @AccessViolation()
br label %continue_idx_37
continue_idx_37:
  %Temp_137 = add nsw i32 %Temp_136,1
;getlement temp temp temp;
  %Temp_138 = getelementptr inbounds i32, i32* %Temp_135, i32 %Temp_137
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_139 = add nsw i32 %zero_45, 2990
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_139, i32* %Temp_138, align 4
  %Temp_140 = load i32*, i32** %local_0, align 8
%Temp_null_38 = bitcast i32* %Temp_140 to i32*
%equal_null_38 = icmp eq i32* %Temp_null_38, null
br i1 %equal_null_38, label %null_deref_38, label %continue_38
null_deref_38:
call void @InvalidPointer()
br label %continue_38
continue_38:
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_141 = add nsw i32 %zero_46, 16
%Temp_i32_39 = bitcast i32* %Temp_140 to i32*
%Temp_size_ptr_39 = getelementptr inbounds i32, i32* %Temp_i32_39, i32 0
%arr_size_39 = load i32, i32* %Temp_size_ptr_39,align 4
%sub_negative_39 = icmp slt i32  %Temp_141, 0
br i1 %sub_negative_39 , label %error_idx_39, label %positive_idx_39
positive_idx_39:
%out_of_bounds_39 = icmp sge i32 %Temp_141, %arr_size_39
br i1 %out_of_bounds_39 , label %error_idx_39, label %continue_idx_39
error_idx_39:
call void @AccessViolation()
br label %continue_idx_39
continue_idx_39:
  %Temp_142 = add nsw i32 %Temp_141,1
;getlement temp temp temp;
  %Temp_143 = getelementptr inbounds i32, i32* %Temp_140, i32 %Temp_142
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_144 = add nsw i32 %zero_47, 9999
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_144, i32* %Temp_143, align 4
  %Temp_145 = load i32*, i32** %local_0, align 8
  %zero_48 = load i32, i32* @my_zero, align 4
  %Temp_146 = add nsw i32 %zero_48, 17
  %zero_49 = load i32, i32* @my_zero, align 4
  %Temp_147 = add nsw i32 %zero_49, -32768
%Temp_148 =call i32 @search(i32* %Temp_145 ,i32 %Temp_146 ,i32 %Temp_147 )
  call void @PrintInt(i32 %Temp_148 )
  %Temp_149 = load i32*, i32** %local_0, align 8
  %zero_50 = load i32, i32* @my_zero, align 4
  %Temp_150 = add nsw i32 %zero_50, 17
  %zero_51 = load i32, i32* @my_zero, align 4
  %Temp_151 = add nsw i32 %zero_51, -2334
%Temp_152 =call i32 @search(i32* %Temp_149 ,i32 %Temp_150 ,i32 %Temp_151 )
  call void @PrintInt(i32 %Temp_152 )
  %Temp_153 = load i32*, i32** %local_0, align 8
  %zero_52 = load i32, i32* @my_zero, align 4
  %Temp_154 = add nsw i32 %zero_52, 17
  %zero_53 = load i32, i32* @my_zero, align 4
  %Temp_155 = add nsw i32 %zero_53, -999
%Temp_156 =call i32 @search(i32* %Temp_153 ,i32 %Temp_154 ,i32 %Temp_155 )
  call void @PrintInt(i32 %Temp_156 )
  %Temp_157 = load i32*, i32** %local_0, align 8
  %zero_54 = load i32, i32* @my_zero, align 4
  %Temp_158 = add nsw i32 %zero_54, 17
  %zero_55 = load i32, i32* @my_zero, align 4
  %Temp_159 = add nsw i32 %zero_55, -314
%Temp_160 =call i32 @search(i32* %Temp_157 ,i32 %Temp_158 ,i32 %Temp_159 )
  call void @PrintInt(i32 %Temp_160 )
  %Temp_161 = load i32*, i32** %local_0, align 8
  %zero_56 = load i32, i32* @my_zero, align 4
  %Temp_162 = add nsw i32 %zero_56, 17
  %zero_57 = load i32, i32* @my_zero, align 4
  %Temp_163 = add nsw i32 %zero_57, -34
%Temp_164 =call i32 @search(i32* %Temp_161 ,i32 %Temp_162 ,i32 %Temp_163 )
  call void @PrintInt(i32 %Temp_164 )
  %Temp_165 = load i32*, i32** %local_0, align 8
  %zero_58 = load i32, i32* @my_zero, align 4
  %Temp_166 = add nsw i32 %zero_58, 17
  %zero_59 = load i32, i32* @my_zero, align 4
  %Temp_167 = add nsw i32 %zero_59, 0
%Temp_168 =call i32 @search(i32* %Temp_165 ,i32 %Temp_166 ,i32 %Temp_167 )
  call void @PrintInt(i32 %Temp_168 )
  %Temp_169 = load i32*, i32** %local_0, align 8
  %zero_60 = load i32, i32* @my_zero, align 4
  %Temp_170 = add nsw i32 %zero_60, 17
  %zero_61 = load i32, i32* @my_zero, align 4
  %Temp_171 = add nsw i32 %zero_61, 232
%Temp_172 =call i32 @search(i32* %Temp_169 ,i32 %Temp_170 ,i32 %Temp_171 )
  call void @PrintInt(i32 %Temp_172 )
  %Temp_173 = load i32*, i32** %local_0, align 8
  %zero_62 = load i32, i32* @my_zero, align 4
  %Temp_174 = add nsw i32 %zero_62, 17
  %zero_63 = load i32, i32* @my_zero, align 4
  %Temp_175 = add nsw i32 %zero_63, 300
%Temp_176 =call i32 @search(i32* %Temp_173 ,i32 %Temp_174 ,i32 %Temp_175 )
  call void @PrintInt(i32 %Temp_176 )
  %Temp_177 = load i32*, i32** %local_0, align 8
  %zero_64 = load i32, i32* @my_zero, align 4
  %Temp_178 = add nsw i32 %zero_64, 17
  %zero_65 = load i32, i32* @my_zero, align 4
  %Temp_179 = add nsw i32 %zero_65, 400
%Temp_180 =call i32 @search(i32* %Temp_177 ,i32 %Temp_178 ,i32 %Temp_179 )
  call void @PrintInt(i32 %Temp_180 )
  %Temp_181 = load i32*, i32** %local_0, align 8
  %zero_66 = load i32, i32* @my_zero, align 4
  %Temp_182 = add nsw i32 %zero_66, 17
  %zero_67 = load i32, i32* @my_zero, align 4
  %Temp_183 = add nsw i32 %zero_67, 500
%Temp_184 =call i32 @search(i32* %Temp_181 ,i32 %Temp_182 ,i32 %Temp_183 )
  call void @PrintInt(i32 %Temp_184 )
  %Temp_185 = load i32*, i32** %local_0, align 8
  %zero_68 = load i32, i32* @my_zero, align 4
  %Temp_186 = add nsw i32 %zero_68, 17
  %zero_69 = load i32, i32* @my_zero, align 4
  %Temp_187 = add nsw i32 %zero_69, 999
%Temp_188 =call i32 @search(i32* %Temp_185 ,i32 %Temp_186 ,i32 %Temp_187 )
  call void @PrintInt(i32 %Temp_188 )
  %Temp_189 = load i32*, i32** %local_0, align 8
  %zero_70 = load i32, i32* @my_zero, align 4
  %Temp_190 = add nsw i32 %zero_70, 17
  %zero_71 = load i32, i32* @my_zero, align 4
  %Temp_191 = add nsw i32 %zero_71, 1000
%Temp_192 =call i32 @search(i32* %Temp_189 ,i32 %Temp_190 ,i32 %Temp_191 )
  call void @PrintInt(i32 %Temp_192 )
  %Temp_193 = load i32*, i32** %local_0, align 8
  %zero_72 = load i32, i32* @my_zero, align 4
  %Temp_194 = add nsw i32 %zero_72, 17
  %zero_73 = load i32, i32* @my_zero, align 4
  %Temp_195 = add nsw i32 %zero_73, 1220
%Temp_196 =call i32 @search(i32* %Temp_193 ,i32 %Temp_194 ,i32 %Temp_195 )
  call void @PrintInt(i32 %Temp_196 )
  %Temp_197 = load i32*, i32** %local_0, align 8
  %zero_74 = load i32, i32* @my_zero, align 4
  %Temp_198 = add nsw i32 %zero_74, 17
  %zero_75 = load i32, i32* @my_zero, align 4
  %Temp_199 = add nsw i32 %zero_75, 1430
%Temp_200 =call i32 @search(i32* %Temp_197 ,i32 %Temp_198 ,i32 %Temp_199 )
  call void @PrintInt(i32 %Temp_200 )
  %Temp_201 = load i32*, i32** %local_0, align 8
  %zero_76 = load i32, i32* @my_zero, align 4
  %Temp_202 = add nsw i32 %zero_76, 17
  %zero_77 = load i32, i32* @my_zero, align 4
  %Temp_203 = add nsw i32 %zero_77, 2220
%Temp_204 =call i32 @search(i32* %Temp_201 ,i32 %Temp_202 ,i32 %Temp_203 )
  call void @PrintInt(i32 %Temp_204 )
  %Temp_205 = load i32*, i32** %local_0, align 8
  %zero_78 = load i32, i32* @my_zero, align 4
  %Temp_206 = add nsw i32 %zero_78, 17
  %zero_79 = load i32, i32* @my_zero, align 4
  %Temp_207 = add nsw i32 %zero_79, 2990
%Temp_208 =call i32 @search(i32* %Temp_205 ,i32 %Temp_206 ,i32 %Temp_207 )
  call void @PrintInt(i32 %Temp_208 )
  %Temp_209 = load i32*, i32** %local_0, align 8
  %zero_80 = load i32, i32* @my_zero, align 4
  %Temp_210 = add nsw i32 %zero_80, 17
  %zero_81 = load i32, i32* @my_zero, align 4
  %Temp_211 = add nsw i32 %zero_81, 32767
%Temp_212 =call i32 @search(i32* %Temp_209 ,i32 %Temp_210 ,i32 %Temp_211 )
  call void @PrintInt(i32 %Temp_212 )
  %Temp_213 = load i32*, i32** %local_0, align 8
  %zero_82 = load i32, i32* @my_zero, align 4
  %Temp_214 = add nsw i32 %zero_82, 17
  %zero_83 = load i32, i32* @my_zero, align 4
  %Temp_215 = add nsw i32 %zero_83, 34
%Temp_216 =call i32 @search(i32* %Temp_213 ,i32 %Temp_214 ,i32 %Temp_215 )
  call void @PrintInt(i32 %Temp_216 )
  %Temp_217 = load i32*, i32** %local_0, align 8
  %zero_84 = load i32, i32* @my_zero, align 4
  %Temp_218 = add nsw i32 %zero_84, 17
  %zero_85 = load i32, i32* @my_zero, align 4
  %Temp_219 = add nsw i32 %zero_85, 16
%Temp_220 =call i32 @search(i32* %Temp_217 ,i32 %Temp_218 ,i32 %Temp_219 )
  call void @PrintInt(i32 %Temp_220 )
  %Temp_221 = load i32*, i32** %local_0, align 8
  %zero_86 = load i32, i32* @my_zero, align 4
  %Temp_222 = add nsw i32 %zero_86, 17
  %zero_87 = load i32, i32* @my_zero, align 4
  %Temp_223 = add nsw i32 %zero_87, 17
%Temp_224 =call i32 @search(i32* %Temp_221 ,i32 %Temp_222 ,i32 %Temp_223 )
  call void @PrintInt(i32 %Temp_224 )
  %Temp_225 = load i32*, i32** %local_0, align 8
  %zero_88 = load i32, i32* @my_zero, align 4
  %Temp_226 = add nsw i32 %zero_88, 17
  %zero_89 = load i32, i32* @my_zero, align 4
  %Temp_227 = add nsw i32 %zero_89, -344
%Temp_228 =call i32 @search(i32* %Temp_225 ,i32 %Temp_226 ,i32 %Temp_227 )
  call void @PrintInt(i32 %Temp_228 )
  %Temp_229 = load i32*, i32** %local_0, align 8
  %zero_90 = load i32, i32* @my_zero, align 4
  %Temp_230 = add nsw i32 %zero_90, 17
  %zero_91 = load i32, i32* @my_zero, align 4
  %Temp_231 = add nsw i32 %zero_91, 111
%Temp_232 =call i32 @search(i32* %Temp_229 ,i32 %Temp_230 ,i32 %Temp_231 )
  call void @PrintInt(i32 %Temp_232 )
  %Temp_233 = load i32*, i32** %local_0, align 8
  %zero_92 = load i32, i32* @my_zero, align 4
  %Temp_234 = add nsw i32 %zero_92, 17
  %zero_93 = load i32, i32* @my_zero, align 4
  %Temp_235 = add nsw i32 %zero_93, -500
%Temp_236 =call i32 @search(i32* %Temp_233 ,i32 %Temp_234 ,i32 %Temp_235 )
  call void @PrintInt(i32 %Temp_236 )
  %Temp_237 = load i32*, i32** %local_0, align 8
  %zero_94 = load i32, i32* @my_zero, align 4
  %Temp_238 = add nsw i32 %zero_94, 17
  %zero_95 = load i32, i32* @my_zero, align 4
  %Temp_239 = add nsw i32 %zero_95, 1
%Temp_240 =call i32 @search(i32* %Temp_237 ,i32 %Temp_238 ,i32 %Temp_239 )
  call void @PrintInt(i32 %Temp_240 )
call void @exit(i32 0)
  ret void
}
