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

@STR.A = constant [2 x i8] c"A\00", align 1
@STR.B = constant [2 x i8] c"B\00", align 1
@STR.C = constant [2 x i8] c"C\00", align 1
@STR.D = constant [2 x i8] c"D\00", align 1
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8**, align 8
  %local_1 = alloca i32, align 4
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 6
  %Temp_2 = add nsw i32 %Temp_1,1
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 8
  %Temp_4 = mul nsw i32 %Temp_2, %Temp_3
  %Temp_5 = call i32* @malloc(i32 %Temp_4)
  %Temp_0 = bitcast i32* %Temp_5 to i8**
  %Temp_6 = getelementptr inbounds i32, i32* %Temp_5, i32 0
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_1, i32* %Temp_6, align 4
  store i8** %Temp_0, i8*** %local_0, align 8
  %Temp_7 = load i8**, i8*** %local_0, align 8
%Temp_null_0 = bitcast i8** %Temp_7 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_2, 0
%Temp_i32_1 = bitcast i8** %Temp_7 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_8, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_8, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_9 = add nsw i32 %Temp_8,1
;getlement temp temp temp;
  %Temp_10 = getelementptr inbounds i8*, i8** %Temp_7, i32 %Temp_9
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.A, i32 0, i32 0), i8** %str_0, align 8
  %Temp_11 = load i8*, i8** %str_0, align 8
;store TYPES.TYPE_STRING@5010be6 dst src;
  store i8* %Temp_11, i8** %Temp_10, align 8
  %Temp_12 = load i8**, i8*** %local_0, align 8
%Temp_null_2 = bitcast i8** %Temp_12 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_3, 1
%Temp_i32_3 = bitcast i8** %Temp_12 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_13, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_13, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_14 = add nsw i32 %Temp_13,1
;getlement temp temp temp;
  %Temp_15 = getelementptr inbounds i8*, i8** %Temp_12, i32 %Temp_14
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.B, i32 0, i32 0), i8** %str_1, align 8
  %Temp_16 = load i8*, i8** %str_1, align 8
;store TYPES.TYPE_STRING@5010be6 dst src;
  store i8* %Temp_16, i8** %Temp_15, align 8
  %Temp_17 = load i8**, i8*** %local_0, align 8
%Temp_null_4 = bitcast i8** %Temp_17 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_4, 2
%Temp_i32_5 = bitcast i8** %Temp_17 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_18, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_18, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_19 = add nsw i32 %Temp_18,1
;getlement temp temp temp;
  %Temp_20 = getelementptr inbounds i8*, i8** %Temp_17, i32 %Temp_19
  %str_2 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.A, i32 0, i32 0), i8** %str_2, align 8
  %Temp_21 = load i8*, i8** %str_2, align 8
;store TYPES.TYPE_STRING@5010be6 dst src;
  store i8* %Temp_21, i8** %Temp_20, align 8
  %Temp_22 = load i8**, i8*** %local_0, align 8
%Temp_null_6 = bitcast i8** %Temp_22 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_5, 3
%Temp_i32_7 = bitcast i8** %Temp_22 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_23, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_23, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_24 = add nsw i32 %Temp_23,1
;getlement temp temp temp;
  %Temp_25 = getelementptr inbounds i8*, i8** %Temp_22, i32 %Temp_24
  %str_3 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.C, i32 0, i32 0), i8** %str_3, align 8
  %Temp_26 = load i8*, i8** %str_3, align 8
;store TYPES.TYPE_STRING@5010be6 dst src;
  store i8* %Temp_26, i8** %Temp_25, align 8
  %Temp_27 = load i8**, i8*** %local_0, align 8
%Temp_null_8 = bitcast i8** %Temp_27 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_6, 4
%Temp_i32_9 = bitcast i8** %Temp_27 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_28, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_28, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_29 = add nsw i32 %Temp_28,1
;getlement temp temp temp;
  %Temp_30 = getelementptr inbounds i8*, i8** %Temp_27, i32 %Temp_29
  %str_4 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.A, i32 0, i32 0), i8** %str_4, align 8
  %Temp_31 = load i8*, i8** %str_4, align 8
;store TYPES.TYPE_STRING@5010be6 dst src;
  store i8* %Temp_31, i8** %Temp_30, align 8
  %Temp_32 = load i8**, i8*** %local_0, align 8
%Temp_null_10 = bitcast i8** %Temp_32 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_7, 5
%Temp_i32_11 = bitcast i8** %Temp_32 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_33, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_33, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_34 = add nsw i32 %Temp_33,1
;getlement temp temp temp;
  %Temp_35 = getelementptr inbounds i8*, i8** %Temp_32, i32 %Temp_34
  %str_5 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.D, i32 0, i32 0), i8** %str_5, align 8
  %Temp_36 = load i8*, i8** %str_5, align 8
;store TYPES.TYPE_STRING@5010be6 dst src;
  store i8* %Temp_36, i8** %Temp_35, align 8
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_38 = load i32, i32* %local_1, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_8, 6
  %Temp_37 = icmp slt i32 %Temp_38, %Temp_39
  %Temp_40 = zext i1 %Temp_37 to i32
  %equal_zero_9 = icmp eq i32 %Temp_40, 0
  br i1 %equal_zero_9, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_43 = load i8**, i8*** %local_0, align 8
%Temp_null_12 = bitcast i8** %Temp_43 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_10, 0
%Temp_i32_13 = bitcast i8** %Temp_43 to i32*
%Temp_size_ptr_13 = getelementptr inbounds i32, i32* %Temp_i32_13, i32 0
%arr_size_13 = load i32, i32* %Temp_size_ptr_13,align 4
%sub_negative_13 = icmp slt i32  %Temp_44, 0
br i1 %sub_negative_13 , label %error_idx_13, label %positive_idx_13
positive_idx_13:
%out_of_bounds_13 = icmp sge i32 %Temp_44, %arr_size_13
br i1 %out_of_bounds_13 , label %error_idx_13, label %continue_idx_13
error_idx_13:
call void @AccessViolation()
br label %continue_idx_13
continue_idx_13:
  %Temp_45 = add nsw i32 %Temp_44,1
;getlement temp temp temp;
  %Temp_46 = getelementptr inbounds i8*, i8** %Temp_43, i32 %Temp_45
  %Temp_47 = load i8**, i8*** %local_0, align 8
%Temp_null_14 = bitcast i8** %Temp_47 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %Temp_48 = load i32, i32* %local_1, align 4
%Temp_i32_15 = bitcast i8** %Temp_47 to i32*
%Temp_size_ptr_15 = getelementptr inbounds i32, i32* %Temp_i32_15, i32 0
%arr_size_15 = load i32, i32* %Temp_size_ptr_15,align 4
%sub_negative_15 = icmp slt i32  %Temp_48, 0
br i1 %sub_negative_15 , label %error_idx_15, label %positive_idx_15
positive_idx_15:
%out_of_bounds_15 = icmp sge i32 %Temp_48, %arr_size_15
br i1 %out_of_bounds_15 , label %error_idx_15, label %continue_idx_15
error_idx_15:
call void @AccessViolation()
br label %continue_idx_15
continue_idx_15:
  %Temp_49 = add nsw i32 %Temp_48,1
;getlement temp temp temp;
  %Temp_50 = getelementptr inbounds i8*, i8** %Temp_47, i32 %Temp_49
;load temp temp;
  %Temp_51 = load i8*, i8** %Temp_50, align 8
;load temp temp;
  %Temp_52 = load i8*, i8** %Temp_46, align 8
%str_cmp_0 = call i32 @strcmp(i8* %Temp_52, i8* %Temp_51)
  %Temp_42 = icmp eq i32 %str_cmp_0, 0
  %Temp_53 = zext i1 %Temp_42 to i32
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_11, 1
  %Temp_41 = icmp eq i32 %Temp_53, %Temp_54
  %Temp_55 = zext i1 %Temp_41 to i32
  %equal_zero_12 = icmp eq i32 %Temp_55, 0
  br i1 %equal_zero_12, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_58 = load i8**, i8*** %local_0, align 8
%Temp_null_16 = bitcast i8** %Temp_58 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %Temp_59 = load i32, i32* %local_1, align 4
%Temp_i32_17 = bitcast i8** %Temp_58 to i32*
%Temp_size_ptr_17 = getelementptr inbounds i32, i32* %Temp_i32_17, i32 0
%arr_size_17 = load i32, i32* %Temp_size_ptr_17,align 4
%sub_negative_17 = icmp slt i32  %Temp_59, 0
br i1 %sub_negative_17 , label %error_idx_17, label %positive_idx_17
positive_idx_17:
%out_of_bounds_17 = icmp sge i32 %Temp_59, %arr_size_17
br i1 %out_of_bounds_17 , label %error_idx_17, label %continue_idx_17
error_idx_17:
call void @AccessViolation()
br label %continue_idx_17
continue_idx_17:
  %Temp_60 = add nsw i32 %Temp_59,1
;getlement temp temp temp;
  %Temp_61 = getelementptr inbounds i8*, i8** %Temp_58, i32 %Temp_60
  %str_6 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.C, i32 0, i32 0), i8** %str_6, align 8
  %Temp_62 = load i8*, i8** %str_6, align 8
;load temp temp;
  %Temp_63 = load i8*, i8** %Temp_61, align 8
%str_cmp_1 = call i32 @strcmp(i8* %Temp_63, i8* %Temp_62)
  %Temp_57 = icmp eq i32 %str_cmp_1, 0
  %Temp_64 = zext i1 %Temp_57 to i32
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_65 = add nsw i32 %zero_13, 1
  %Temp_56 = icmp eq i32 %Temp_64, %Temp_65
  %Temp_66 = zext i1 %Temp_56 to i32
  %equal_zero_14 = icmp eq i32 %Temp_66, 0
  br i1 %equal_zero_14, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %Temp_67 = load i8**, i8*** %local_0, align 8
%Temp_null_18 = bitcast i8** %Temp_67 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %Temp_68 = load i32, i32* %local_1, align 4
%Temp_i32_19 = bitcast i8** %Temp_67 to i32*
%Temp_size_ptr_19 = getelementptr inbounds i32, i32* %Temp_i32_19, i32 0
%arr_size_19 = load i32, i32* %Temp_size_ptr_19,align 4
%sub_negative_19 = icmp slt i32  %Temp_68, 0
br i1 %sub_negative_19 , label %error_idx_19, label %positive_idx_19
positive_idx_19:
%out_of_bounds_19 = icmp sge i32 %Temp_68, %arr_size_19
br i1 %out_of_bounds_19 , label %error_idx_19, label %continue_idx_19
error_idx_19:
call void @AccessViolation()
br label %continue_idx_19
continue_idx_19:
  %Temp_69 = add nsw i32 %Temp_68,1
;getlement temp temp temp;
  %Temp_70 = getelementptr inbounds i8*, i8** %Temp_67, i32 %Temp_69
;load temp temp;
  %Temp_71 = load i8*, i8** %Temp_70, align 8
  call void @PrintString(i8* %Temp_71 )
  br label %Label_8_if.exit

Label_8_if.exit:

  br label %Label_5_if.exit

Label_5_if.exit:

  br label %Label_9_if.cond

Label_9_if.cond:

  %Temp_73 = load i32, i32* %local_1, align 4
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_74 = add nsw i32 %zero_15, 0
  %Temp_72 = icmp eq i32 %Temp_73, %Temp_74
  %Temp_75 = zext i1 %Temp_72 to i32
  %equal_zero_16 = icmp eq i32 %Temp_75, 0
  br i1 %equal_zero_16, label %Label_11_if.exit, label %Label_10_if.body
  
Label_10_if.body:

  %Temp_76 = load i8**, i8*** %local_0, align 8
%Temp_null_20 = bitcast i8** %Temp_76 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %Temp_77 = load i32, i32* %local_1, align 4
%Temp_i32_21 = bitcast i8** %Temp_76 to i32*
%Temp_size_ptr_21 = getelementptr inbounds i32, i32* %Temp_i32_21, i32 0
%arr_size_21 = load i32, i32* %Temp_size_ptr_21,align 4
%sub_negative_21 = icmp slt i32  %Temp_77, 0
br i1 %sub_negative_21 , label %error_idx_21, label %positive_idx_21
positive_idx_21:
%out_of_bounds_21 = icmp sge i32 %Temp_77, %arr_size_21
br i1 %out_of_bounds_21 , label %error_idx_21, label %continue_idx_21
error_idx_21:
call void @AccessViolation()
br label %continue_idx_21
continue_idx_21:
  %Temp_78 = add nsw i32 %Temp_77,1
;getlement temp temp temp;
  %Temp_79 = getelementptr inbounds i8*, i8** %Temp_76, i32 %Temp_78
;load temp temp;
  %Temp_80 = load i8*, i8** %Temp_79, align 8
  call void @PrintString(i8* %Temp_80 )
  br label %Label_11_if.exit

Label_11_if.exit:

  %Temp_82 = load i32, i32* %local_1, align 4
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_83 = add nsw i32 %zero_17, 1
  %Temp_81 = add nsw i32 %Temp_82, %Temp_83
%Temp_84 = call i32 @CheckOverflow(i32 %Temp_81)
  store i32 %Temp_84, i32* %local_1, align 4
  br label %Label_2_while.cond

Label_0_while.end:

call void @exit(i32 0)
  ret void
}
