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

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@c = global i8* null, align 8

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@arr = global i32* null, align 8

define i32 @inc()
 { 
  %Temp_0 = load i8*, i8** @c, align 8
%Temp_null_0 = bitcast i8* %Temp_0 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 0
;getlement temp temp temp;
  %Temp_2 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_1
  %Temp_3 = bitcast i8* %Temp_2 to i32*
  %Temp_5 = load i8*, i8** @c, align 8
%Temp_null_1 = bitcast i8* %Temp_5 to i32*
%equal_null_1 = icmp eq i32* %Temp_null_1, null
br i1 %equal_null_1, label %null_deref_1, label %continue_1
null_deref_1:
call void @InvalidPointer()
br label %continue_1
continue_1:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_1, 0
;getlement temp temp temp;
  %Temp_7 = getelementptr inbounds i8, i8* %Temp_5, i32 %Temp_6
  %Temp_8 = bitcast i8* %Temp_7 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_2, 1
;load temp temp;
%Temp_init_ptr_2 = bitcast i32* %Temp_8 to i32*
%init_state_2 = load i32, i32* %Temp_init_ptr_2,align 4
%is_init_2 = icmp eq i32  %init_state_2, 0
br i1 %is_init_2 , label %error_init_2, label %good_init_2
error_init_2:
call void @InvalidPointer()
br label %good_init_2
good_init_2:
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  %Temp_10 = load i32, i32* %Temp_actual_2 , align 4
  %Temp_4 = add nsw i32 %Temp_10, %Temp_9
%Temp_11 = call i32 @CheckOverflow(i32 %Temp_4)
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_3 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_11, i32* %Temp_actual_3, align 4
  ret i32 0
}
define i32 @dec()
 { 
  %Temp_12 = load i8*, i8** @c, align 8
%Temp_null_4 = bitcast i8* %Temp_12 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_3, 0
;getlement temp temp temp;
  %Temp_14 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_13
  %Temp_15 = bitcast i8* %Temp_14 to i32*
  %Temp_17 = load i8*, i8** @c, align 8
%Temp_null_5 = bitcast i8* %Temp_17 to i32*
%equal_null_5 = icmp eq i32* %Temp_null_5, null
br i1 %equal_null_5, label %null_deref_5, label %continue_5
null_deref_5:
call void @InvalidPointer()
br label %continue_5
continue_5:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_4, 0
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_17, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i32*
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_5, 1
;load temp temp;
%Temp_init_ptr_6 = bitcast i32* %Temp_20 to i32*
%init_state_6 = load i32, i32* %Temp_init_ptr_6,align 4
%is_init_6 = icmp eq i32  %init_state_6, 0
br i1 %is_init_6 , label %error_init_6, label %good_init_6
error_init_6:
call void @InvalidPointer()
br label %good_init_6
good_init_6:
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  %Temp_22 = load i32, i32* %Temp_actual_6 , align 4
  %Temp_16 = sub nsw i32 %Temp_22, %Temp_21
%Temp_23 = call i32 @CheckOverflow(i32 %Temp_16)
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_7 = bitcast i32* %Temp_15 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  store i32 %Temp_23, i32* %Temp_actual_7, align 4
  ret i32 0
}
define i32 @foo()
 { 
%Temp_24 =call i32 @inc()
  %Temp_25 = load i8*, i8** @c, align 8
%Temp_null_8 = bitcast i8* %Temp_25 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_6, 0
;getlement temp temp temp;
  %Temp_27 = getelementptr inbounds i8, i8* %Temp_25, i32 %Temp_26
  %Temp_28 = bitcast i8* %Temp_27 to i32*
;load temp temp;
%Temp_init_ptr_9 = bitcast i32* %Temp_28 to i32*
%init_state_9 = load i32, i32* %Temp_init_ptr_9,align 4
%is_init_9 = icmp eq i32  %init_state_9, 0
br i1 %is_init_9 , label %error_init_9, label %good_init_9
error_init_9:
call void @InvalidPointer()
br label %good_init_9
good_init_9:
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  %Temp_29 = load i32, i32* %Temp_actual_9 , align 4
  ret i32 %Temp_29
}
define i32 @bar()
 { 
%Temp_30 =call i32 @dec()
  %Temp_31 = load i8*, i8** @c, align 8
%Temp_null_10 = bitcast i8* %Temp_31 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_7, 0
;getlement temp temp temp;
  %Temp_33 = getelementptr inbounds i8, i8* %Temp_31, i32 %Temp_32
  %Temp_34 = bitcast i8* %Temp_33 to i32*
;load temp temp;
%Temp_init_ptr_11 = bitcast i32* %Temp_34 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  %Temp_35 = load i32, i32* %Temp_actual_11 , align 4
  ret i32 %Temp_35
}
define void @init_globals()
 { 
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_8, 8
  %Temp_38 = call i32* @malloc(i32 %Temp_37)
  %Temp_36 = bitcast i32* %Temp_38 to i8*
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_9, 0
;getlement temp temp temp;
  %Temp_40 = getelementptr inbounds i8, i8* %Temp_36, i32 %Temp_39
  %Temp_41 = bitcast i8* %Temp_40 to i32*
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_10, 1
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_41 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_42, i32* %Temp_actual_12, align 4
  store i8* %Temp_36, i8** @c, align 8
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_11, 5
  %Temp_45 = add nsw i32 %Temp_44,1
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_12, 8
  %Temp_47 = mul nsw i32 %Temp_45, %Temp_46
  %Temp_48 = call i32* @malloc(i32 %Temp_47)
  %Temp_43 = bitcast i32* %Temp_48 to i32*
  %Temp_49 = getelementptr inbounds i32, i32* %Temp_48, i32 0
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_44, i32* %Temp_49, align 4
  store i32* %Temp_43, i32** @arr, align 8
  ret void
}
define void @main()
 { 
  call void @init_globals()
  %Temp_50 = load i32*, i32** @arr, align 8
%Temp_null_13 = bitcast i32* %Temp_50 to i32*
%equal_null_13 = icmp eq i32* %Temp_null_13, null
br i1 %equal_null_13, label %null_deref_13, label %continue_13
null_deref_13:
call void @InvalidPointer()
br label %continue_13
continue_13:
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_13, 0
%Temp_i32_14 = bitcast i32* %Temp_50 to i32*
%Temp_size_ptr_14 = getelementptr inbounds i32, i32* %Temp_i32_14, i32 0
%arr_size_14 = load i32, i32* %Temp_size_ptr_14,align 4
%sub_negative_14 = icmp slt i32  %Temp_51, 0
br i1 %sub_negative_14 , label %error_idx_14, label %positive_idx_14
positive_idx_14:
%out_of_bounds_14 = icmp sge i32 %Temp_51, %arr_size_14
br i1 %out_of_bounds_14 , label %error_idx_14, label %continue_idx_14
error_idx_14:
call void @AccessViolation()
br label %continue_idx_14
continue_idx_14:
  %Temp_52 = add nsw i32 %Temp_51,1
;getlement temp temp temp;
  %Temp_53 = getelementptr inbounds i32, i32* %Temp_50, i32 %Temp_52
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_14, 0
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_54, i32* %Temp_53, align 4
  %Temp_55 = load i32*, i32** @arr, align 8
%Temp_null_15 = bitcast i32* %Temp_55 to i32*
%equal_null_15 = icmp eq i32* %Temp_null_15, null
br i1 %equal_null_15, label %null_deref_15, label %continue_15
null_deref_15:
call void @InvalidPointer()
br label %continue_15
continue_15:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_15, 1
%Temp_i32_16 = bitcast i32* %Temp_55 to i32*
%Temp_size_ptr_16 = getelementptr inbounds i32, i32* %Temp_i32_16, i32 0
%arr_size_16 = load i32, i32* %Temp_size_ptr_16,align 4
%sub_negative_16 = icmp slt i32  %Temp_56, 0
br i1 %sub_negative_16 , label %error_idx_16, label %positive_idx_16
positive_idx_16:
%out_of_bounds_16 = icmp sge i32 %Temp_56, %arr_size_16
br i1 %out_of_bounds_16 , label %error_idx_16, label %continue_idx_16
error_idx_16:
call void @AccessViolation()
br label %continue_idx_16
continue_idx_16:
  %Temp_57 = add nsw i32 %Temp_56,1
;getlement temp temp temp;
  %Temp_58 = getelementptr inbounds i32, i32* %Temp_55, i32 %Temp_57
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_59 = add nsw i32 %zero_16, 1
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_59, i32* %Temp_58, align 4
  %Temp_60 = load i32*, i32** @arr, align 8
%Temp_null_17 = bitcast i32* %Temp_60 to i32*
%equal_null_17 = icmp eq i32* %Temp_null_17, null
br i1 %equal_null_17, label %null_deref_17, label %continue_17
null_deref_17:
call void @InvalidPointer()
br label %continue_17
continue_17:
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_61 = add nsw i32 %zero_17, 2
%Temp_i32_18 = bitcast i32* %Temp_60 to i32*
%Temp_size_ptr_18 = getelementptr inbounds i32, i32* %Temp_i32_18, i32 0
%arr_size_18 = load i32, i32* %Temp_size_ptr_18,align 4
%sub_negative_18 = icmp slt i32  %Temp_61, 0
br i1 %sub_negative_18 , label %error_idx_18, label %positive_idx_18
positive_idx_18:
%out_of_bounds_18 = icmp sge i32 %Temp_61, %arr_size_18
br i1 %out_of_bounds_18 , label %error_idx_18, label %continue_idx_18
error_idx_18:
call void @AccessViolation()
br label %continue_idx_18
continue_idx_18:
  %Temp_62 = add nsw i32 %Temp_61,1
;getlement temp temp temp;
  %Temp_63 = getelementptr inbounds i32, i32* %Temp_60, i32 %Temp_62
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_64 = add nsw i32 %zero_18, 2
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_64, i32* %Temp_63, align 4
  %Temp_65 = load i32*, i32** @arr, align 8
%Temp_null_19 = bitcast i32* %Temp_65 to i32*
%equal_null_19 = icmp eq i32* %Temp_null_19, null
br i1 %equal_null_19, label %null_deref_19, label %continue_19
null_deref_19:
call void @InvalidPointer()
br label %continue_19
continue_19:
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_66 = add nsw i32 %zero_19, 3
%Temp_i32_20 = bitcast i32* %Temp_65 to i32*
%Temp_size_ptr_20 = getelementptr inbounds i32, i32* %Temp_i32_20, i32 0
%arr_size_20 = load i32, i32* %Temp_size_ptr_20,align 4
%sub_negative_20 = icmp slt i32  %Temp_66, 0
br i1 %sub_negative_20 , label %error_idx_20, label %positive_idx_20
positive_idx_20:
%out_of_bounds_20 = icmp sge i32 %Temp_66, %arr_size_20
br i1 %out_of_bounds_20 , label %error_idx_20, label %continue_idx_20
error_idx_20:
call void @AccessViolation()
br label %continue_idx_20
continue_idx_20:
  %Temp_67 = add nsw i32 %Temp_66,1
;getlement temp temp temp;
  %Temp_68 = getelementptr inbounds i32, i32* %Temp_65, i32 %Temp_67
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_69 = add nsw i32 %zero_20, 3
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_69, i32* %Temp_68, align 4
  %Temp_70 = load i32*, i32** @arr, align 8
%Temp_null_21 = bitcast i32* %Temp_70 to i32*
%equal_null_21 = icmp eq i32* %Temp_null_21, null
br i1 %equal_null_21, label %null_deref_21, label %continue_21
null_deref_21:
call void @InvalidPointer()
br label %continue_21
continue_21:
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_21, 4
%Temp_i32_22 = bitcast i32* %Temp_70 to i32*
%Temp_size_ptr_22 = getelementptr inbounds i32, i32* %Temp_i32_22, i32 0
%arr_size_22 = load i32, i32* %Temp_size_ptr_22,align 4
%sub_negative_22 = icmp slt i32  %Temp_71, 0
br i1 %sub_negative_22 , label %error_idx_22, label %positive_idx_22
positive_idx_22:
%out_of_bounds_22 = icmp sge i32 %Temp_71, %arr_size_22
br i1 %out_of_bounds_22 , label %error_idx_22, label %continue_idx_22
error_idx_22:
call void @AccessViolation()
br label %continue_idx_22
continue_idx_22:
  %Temp_72 = add nsw i32 %Temp_71,1
;getlement temp temp temp;
  %Temp_73 = getelementptr inbounds i32, i32* %Temp_70, i32 %Temp_72
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_74 = add nsw i32 %zero_22, 4
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_74, i32* %Temp_73, align 4
  %Temp_75 = load i32*, i32** @arr, align 8
%Temp_null_23 = bitcast i32* %Temp_75 to i32*
%equal_null_23 = icmp eq i32* %Temp_null_23, null
br i1 %equal_null_23, label %null_deref_23, label %continue_23
null_deref_23:
call void @InvalidPointer()
br label %continue_23
continue_23:
%Temp_76 =call i32 @foo()
%Temp_i32_24 = bitcast i32* %Temp_75 to i32*
%Temp_size_ptr_24 = getelementptr inbounds i32, i32* %Temp_i32_24, i32 0
%arr_size_24 = load i32, i32* %Temp_size_ptr_24,align 4
%sub_negative_24 = icmp slt i32  %Temp_76, 0
br i1 %sub_negative_24 , label %error_idx_24, label %positive_idx_24
positive_idx_24:
%out_of_bounds_24 = icmp sge i32 %Temp_76, %arr_size_24
br i1 %out_of_bounds_24 , label %error_idx_24, label %continue_idx_24
error_idx_24:
call void @AccessViolation()
br label %continue_idx_24
continue_idx_24:
  %Temp_77 = add nsw i32 %Temp_76,1
;getlement temp temp temp;
  %Temp_78 = getelementptr inbounds i32, i32* %Temp_75, i32 %Temp_77
%Temp_79 =call i32 @bar()
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_79, i32* %Temp_78, align 4
  %Temp_80 = load i32*, i32** @arr, align 8
%Temp_null_25 = bitcast i32* %Temp_80 to i32*
%equal_null_25 = icmp eq i32* %Temp_null_25, null
br i1 %equal_null_25, label %null_deref_25, label %continue_25
null_deref_25:
call void @InvalidPointer()
br label %continue_25
continue_25:
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_23, 2
%Temp_i32_26 = bitcast i32* %Temp_80 to i32*
%Temp_size_ptr_26 = getelementptr inbounds i32, i32* %Temp_i32_26, i32 0
%arr_size_26 = load i32, i32* %Temp_size_ptr_26,align 4
%sub_negative_26 = icmp slt i32  %Temp_81, 0
br i1 %sub_negative_26 , label %error_idx_26, label %positive_idx_26
positive_idx_26:
%out_of_bounds_26 = icmp sge i32 %Temp_81, %arr_size_26
br i1 %out_of_bounds_26 , label %error_idx_26, label %continue_idx_26
error_idx_26:
call void @AccessViolation()
br label %continue_idx_26
continue_idx_26:
  %Temp_82 = add nsw i32 %Temp_81,1
;getlement temp temp temp;
  %Temp_83 = getelementptr inbounds i32, i32* %Temp_80, i32 %Temp_82
;load temp temp;
  %Temp_84 = load i32, i32* %Temp_83, align 4
  call void @PrintInt(i32 %Temp_84 )
  %Temp_85 = load i32*, i32** @arr, align 8
%Temp_null_27 = bitcast i32* %Temp_85 to i32*
%equal_null_27 = icmp eq i32* %Temp_null_27, null
br i1 %equal_null_27, label %null_deref_27, label %continue_27
null_deref_27:
call void @InvalidPointer()
br label %continue_27
continue_27:
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_24, 1
%Temp_i32_28 = bitcast i32* %Temp_85 to i32*
%Temp_size_ptr_28 = getelementptr inbounds i32, i32* %Temp_i32_28, i32 0
%arr_size_28 = load i32, i32* %Temp_size_ptr_28,align 4
%sub_negative_28 = icmp slt i32  %Temp_86, 0
br i1 %sub_negative_28 , label %error_idx_28, label %positive_idx_28
positive_idx_28:
%out_of_bounds_28 = icmp sge i32 %Temp_86, %arr_size_28
br i1 %out_of_bounds_28 , label %error_idx_28, label %continue_idx_28
error_idx_28:
call void @AccessViolation()
br label %continue_idx_28
continue_idx_28:
  %Temp_87 = add nsw i32 %Temp_86,1
;getlement temp temp temp;
  %Temp_88 = getelementptr inbounds i32, i32* %Temp_85, i32 %Temp_87
;load temp temp;
  %Temp_89 = load i32, i32* %Temp_88, align 4
  call void @PrintInt(i32 %Temp_89 )
call void @exit(i32 0)
  ret void
}
