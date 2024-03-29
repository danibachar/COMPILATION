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

define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8*, align 8
  %local_1 = alloca i32, align 4
  %local_2 = alloca i8**, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 40
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 12
;getlement temp temp temp;
  %Temp_4 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_3
  %Temp_5 = bitcast i8* %Temp_4 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_2, 18
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_5 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_6, i32* %Temp_actual_0, align 4
  store i8* %Temp_0, i8** %local_0, align 8
  %Temp_7 = load i8*, i8** %local_0, align 8
%Temp_null_1 = bitcast i8* %Temp_7 to i32*
%equal_null_1 = icmp eq i32* %Temp_null_1, null
br i1 %equal_null_1, label %null_deref_1, label %continue_1
null_deref_1:
call void @InvalidPointer()
br label %continue_1
continue_1:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_3, 28
;getlement temp temp temp;
  %Temp_9 = getelementptr inbounds i8, i8* %Temp_7, i32 %Temp_8
  %Temp_10 = bitcast i8* %Temp_9 to i32**
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_4, 10
  %Temp_13 = add nsw i32 %Temp_12,1
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_5, 8
  %Temp_15 = mul nsw i32 %Temp_13, %Temp_14
  %Temp_16 = call i32* @malloc(i32 %Temp_15)
  %Temp_11 = bitcast i32* %Temp_16 to i32*
  %Temp_17 = getelementptr inbounds i32, i32* %Temp_16, i32 0
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_12, i32* %Temp_17, align 4
;store TYPES.TYPE_ARRAY@1d56ce6a dst src;
%Temp_init_ptr_2 = bitcast i32** %Temp_10 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32**
  store i32* %Temp_11, i32** %Temp_actual_2, align 8
  %Temp_18 = load i8*, i8** %local_0, align 8
%Temp_null_3 = bitcast i8* %Temp_18 to i32*
%equal_null_3 = icmp eq i32* %Temp_null_3, null
br i1 %equal_null_3, label %null_deref_3, label %continue_3
null_deref_3:
call void @InvalidPointer()
br label %continue_3
continue_3:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_6, 0
;getlement temp temp temp;
  %Temp_20 = getelementptr inbounds i8, i8* %Temp_18, i32 %Temp_19
  %Temp_21 = bitcast i8* %Temp_20 to i32**
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_7, 12
  %Temp_24 = add nsw i32 %Temp_23,1
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_8, 8
  %Temp_26 = mul nsw i32 %Temp_24, %Temp_25
  %Temp_27 = call i32* @malloc(i32 %Temp_26)
  %Temp_22 = bitcast i32* %Temp_27 to i32*
  %Temp_28 = getelementptr inbounds i32, i32* %Temp_27, i32 0
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_23, i32* %Temp_28, align 4
;store TYPES.TYPE_ARRAY@1d56ce6a dst src;
%Temp_init_ptr_4 = bitcast i32** %Temp_21 to i32*
store i32 1, i32* %Temp_init_ptr_4,align 4
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32**
  store i32* %Temp_22, i32** %Temp_actual_4, align 8
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_9, 6
  store i32 %Temp_29, i32* %local_1, align 4
  %Temp_30 = load i8*, i8** %local_0, align 8
%Temp_null_5 = bitcast i8* %Temp_30 to i32*
%equal_null_5 = icmp eq i32* %Temp_null_5, null
br i1 %equal_null_5, label %null_deref_5, label %continue_5
null_deref_5:
call void @InvalidPointer()
br label %continue_5
continue_5:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_10, 28
;getlement temp temp temp;
  %Temp_32 = getelementptr inbounds i8, i8* %Temp_30, i32 %Temp_31
  %Temp_33 = bitcast i8* %Temp_32 to i32**
;load temp temp;
%Temp_init_ptr_6 = bitcast i32** %Temp_33 to i32*
%init_state_6 = load i32, i32* %Temp_init_ptr_6,align 4
%is_init_6 = icmp eq i32  %init_state_6, 0
br i1 %is_init_6 , label %error_init_6, label %good_init_6
error_init_6:
call void @InvalidPointer()
br label %good_init_6
good_init_6:
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32**
  %Temp_34 = load i32*, i32** %Temp_actual_6 , align 8
%Temp_null_7 = bitcast i32* %Temp_34 to i32*
%equal_null_7 = icmp eq i32* %Temp_null_7, null
br i1 %equal_null_7, label %null_deref_7, label %continue_7
null_deref_7:
call void @InvalidPointer()
br label %continue_7
continue_7:
  %Temp_35 = load i32, i32* %local_1, align 4
%Temp_i32_8 = bitcast i32* %Temp_34 to i32*
%Temp_size_ptr_8 = getelementptr inbounds i32, i32* %Temp_i32_8, i32 0
%arr_size_8 = load i32, i32* %Temp_size_ptr_8,align 4
%sub_negative_8 = icmp slt i32  %Temp_35, 0
br i1 %sub_negative_8 , label %error_idx_8, label %positive_idx_8
positive_idx_8:
%out_of_bounds_8 = icmp sge i32 %Temp_35, %arr_size_8
br i1 %out_of_bounds_8 , label %error_idx_8, label %continue_idx_8
error_idx_8:
call void @AccessViolation()
br label %continue_idx_8
continue_idx_8:
  %Temp_36 = add nsw i32 %Temp_35,1
;getlement temp temp temp;
  %Temp_37 = getelementptr inbounds i32, i32* %Temp_34, i32 %Temp_36
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_11, 99
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_38, i32* %Temp_37, align 4
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_12, 37
  %Temp_41 = add nsw i32 %Temp_40,1
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_13, 8
  %Temp_43 = mul nsw i32 %Temp_41, %Temp_42
  %Temp_44 = call i32* @malloc(i32 %Temp_43)
  %Temp_39 = bitcast i32* %Temp_44 to i8**
  %Temp_45 = getelementptr inbounds i32, i32* %Temp_44, i32 0
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_40, i32* %Temp_45, align 4
  store i8** %Temp_39, i8*** %local_2, align 8
  %Temp_46 = load i8**, i8*** %local_2, align 8
%Temp_null_9 = bitcast i8** %Temp_46 to i32*
%equal_null_9 = icmp eq i32* %Temp_null_9, null
br i1 %equal_null_9, label %null_deref_9, label %continue_9
null_deref_9:
call void @InvalidPointer()
br label %continue_9
continue_9:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_47 = add nsw i32 %zero_14, 3
%Temp_i32_10 = bitcast i8** %Temp_46 to i32*
%Temp_size_ptr_10 = getelementptr inbounds i32, i32* %Temp_i32_10, i32 0
%arr_size_10 = load i32, i32* %Temp_size_ptr_10,align 4
%sub_negative_10 = icmp slt i32  %Temp_47, 0
br i1 %sub_negative_10 , label %error_idx_10, label %positive_idx_10
positive_idx_10:
%out_of_bounds_10 = icmp sge i32 %Temp_47, %arr_size_10
br i1 %out_of_bounds_10 , label %error_idx_10, label %continue_idx_10
error_idx_10:
call void @AccessViolation()
br label %continue_idx_10
continue_idx_10:
  %Temp_48 = add nsw i32 %Temp_47,1
;getlement temp temp temp;
  %Temp_49 = getelementptr inbounds i8*, i8** %Temp_46, i32 %Temp_48
  %Temp_50 = load i8*, i8** %local_0, align 8
;store TYPES.TYPE_CLASS@5197848c dst src;
  store i8* %Temp_50, i8** %Temp_49, align 8
  %Temp_51 = load i8**, i8*** %local_2, align 8
%Temp_null_11 = bitcast i8** %Temp_51 to i32*
%equal_null_11 = icmp eq i32* %Temp_null_11, null
br i1 %equal_null_11, label %null_deref_11, label %continue_11
null_deref_11:
call void @InvalidPointer()
br label %continue_11
continue_11:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_52 = add nsw i32 %zero_15, 3
%Temp_i32_12 = bitcast i8** %Temp_51 to i32*
%Temp_size_ptr_12 = getelementptr inbounds i32, i32* %Temp_i32_12, i32 0
%arr_size_12 = load i32, i32* %Temp_size_ptr_12,align 4
%sub_negative_12 = icmp slt i32  %Temp_52, 0
br i1 %sub_negative_12 , label %error_idx_12, label %positive_idx_12
positive_idx_12:
%out_of_bounds_12 = icmp sge i32 %Temp_52, %arr_size_12
br i1 %out_of_bounds_12 , label %error_idx_12, label %continue_idx_12
error_idx_12:
call void @AccessViolation()
br label %continue_idx_12
continue_idx_12:
  %Temp_53 = add nsw i32 %Temp_52,1
;getlement temp temp temp;
  %Temp_54 = getelementptr inbounds i8*, i8** %Temp_51, i32 %Temp_53
;load temp temp;
  %Temp_55 = load i8*, i8** %Temp_54, align 8
%Temp_null_13 = bitcast i8* %Temp_55 to i32*
%equal_null_13 = icmp eq i32* %Temp_null_13, null
br i1 %equal_null_13, label %null_deref_13, label %continue_13
null_deref_13:
call void @InvalidPointer()
br label %continue_13
continue_13:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_16, 0
;getlement temp temp temp;
  %Temp_57 = getelementptr inbounds i8, i8* %Temp_55, i32 %Temp_56
  %Temp_58 = bitcast i8* %Temp_57 to i32**
;load temp temp;
%Temp_init_ptr_14 = bitcast i32** %Temp_58 to i32*
%init_state_14 = load i32, i32* %Temp_init_ptr_14,align 4
%is_init_14 = icmp eq i32  %init_state_14, 0
br i1 %is_init_14 , label %error_init_14, label %good_init_14
error_init_14:
call void @InvalidPointer()
br label %good_init_14
good_init_14:
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32**
  %Temp_59 = load i32*, i32** %Temp_actual_14 , align 8
%Temp_null_15 = bitcast i32* %Temp_59 to i32*
%equal_null_15 = icmp eq i32* %Temp_null_15, null
br i1 %equal_null_15, label %null_deref_15, label %continue_15
null_deref_15:
call void @InvalidPointer()
br label %continue_15
continue_15:
  %Temp_60 = load i8**, i8*** %local_2, align 8
%Temp_null_16 = bitcast i8** %Temp_60 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_61 = add nsw i32 %zero_17, 3
%Temp_i32_17 = bitcast i8** %Temp_60 to i32*
%Temp_size_ptr_17 = getelementptr inbounds i32, i32* %Temp_i32_17, i32 0
%arr_size_17 = load i32, i32* %Temp_size_ptr_17,align 4
%sub_negative_17 = icmp slt i32  %Temp_61, 0
br i1 %sub_negative_17 , label %error_idx_17, label %positive_idx_17
positive_idx_17:
%out_of_bounds_17 = icmp sge i32 %Temp_61, %arr_size_17
br i1 %out_of_bounds_17 , label %error_idx_17, label %continue_idx_17
error_idx_17:
call void @AccessViolation()
br label %continue_idx_17
continue_idx_17:
  %Temp_62 = add nsw i32 %Temp_61,1
;getlement temp temp temp;
  %Temp_63 = getelementptr inbounds i8*, i8** %Temp_60, i32 %Temp_62
;load temp temp;
  %Temp_64 = load i8*, i8** %Temp_63, align 8
%Temp_null_18 = bitcast i8* %Temp_64 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_65 = add nsw i32 %zero_18, 28
;getlement temp temp temp;
  %Temp_66 = getelementptr inbounds i8, i8* %Temp_64, i32 %Temp_65
  %Temp_67 = bitcast i8* %Temp_66 to i32**
;load temp temp;
%Temp_init_ptr_19 = bitcast i32** %Temp_67 to i32*
%init_state_19 = load i32, i32* %Temp_init_ptr_19,align 4
%is_init_19 = icmp eq i32  %init_state_19, 0
br i1 %is_init_19 , label %error_init_19, label %good_init_19
error_init_19:
call void @InvalidPointer()
br label %good_init_19
good_init_19:
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32**
  %Temp_68 = load i32*, i32** %Temp_actual_19 , align 8
%Temp_null_20 = bitcast i32* %Temp_68 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %Temp_69 = load i32, i32* %local_1, align 4
%Temp_i32_21 = bitcast i32* %Temp_68 to i32*
%Temp_size_ptr_21 = getelementptr inbounds i32, i32* %Temp_i32_21, i32 0
%arr_size_21 = load i32, i32* %Temp_size_ptr_21,align 4
%sub_negative_21 = icmp slt i32  %Temp_69, 0
br i1 %sub_negative_21 , label %error_idx_21, label %positive_idx_21
positive_idx_21:
%out_of_bounds_21 = icmp sge i32 %Temp_69, %arr_size_21
br i1 %out_of_bounds_21 , label %error_idx_21, label %continue_idx_21
error_idx_21:
call void @AccessViolation()
br label %continue_idx_21
continue_idx_21:
  %Temp_70 = add nsw i32 %Temp_69,1
;getlement temp temp temp;
  %Temp_71 = getelementptr inbounds i32, i32* %Temp_68, i32 %Temp_70
;load temp temp;
  %Temp_72 = load i32, i32* %Temp_71, align 4
%Temp_i32_22 = bitcast i32* %Temp_59 to i32*
%Temp_size_ptr_22 = getelementptr inbounds i32, i32* %Temp_i32_22, i32 0
%arr_size_22 = load i32, i32* %Temp_size_ptr_22,align 4
%sub_negative_22 = icmp slt i32  %Temp_72, 0
br i1 %sub_negative_22 , label %error_idx_22, label %positive_idx_22
positive_idx_22:
%out_of_bounds_22 = icmp sge i32 %Temp_72, %arr_size_22
br i1 %out_of_bounds_22 , label %error_idx_22, label %continue_idx_22
error_idx_22:
call void @AccessViolation()
br label %continue_idx_22
continue_idx_22:
  %Temp_73 = add nsw i32 %Temp_72,1
;getlement temp temp temp;
  %Temp_74 = getelementptr inbounds i32, i32* %Temp_59, i32 %Temp_73
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_75 = add nsw i32 %zero_19, 999
;store TYPES.TYPE_INT@439f5b3d dst src;
  store i32 %Temp_75, i32* %Temp_74, align 4
call void @exit(i32 0)
  ret void
}
