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

@STR.HELLO = constant [6 x i8] c"HELLO\00", align 1
@STR.BYE = constant [4 x i8] c"BYE\00", align 1
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_1 = alloca i8*, align 8
  %local_0 = alloca i8*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 12
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  store i8* %Temp_0, i8** %local_0, align 8
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_1, 12
  %Temp_5 = call i32* @malloc(i32 %Temp_4)
  %Temp_3 = bitcast i32* %Temp_5 to i8*
  store i8* %Temp_3, i8** %local_1, align 8
  %Temp_6 = load i8*, i8** %local_0, align 8
%Temp_null_0 = bitcast i8* %Temp_6 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_2, 0
;getlement temp temp temp;
  %Temp_8 = getelementptr inbounds i8, i8* %Temp_6, i32 %Temp_7
  %Temp_9 = bitcast i8* %Temp_8 to i8***
;load temp temp;
%Temp_init_ptr_1 = bitcast i8*** %Temp_9 to i32*
%init_state_1 = load i32, i32* %Temp_init_ptr_1,align 4
%is_init_1 = icmp eq i32  %init_state_1, 0
br i1 %is_init_1 , label %error_init_1, label %good_init_1
error_init_1:
call void @InvalidPointer()
br label %good_init_1
good_init_1:
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i8***
  %Temp_10 = load i8**, i8*** %Temp_actual_1 , align 8
%Temp_null_2 = bitcast i8** %Temp_10 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_3, 0
%Temp_i32_3 = bitcast i8** %Temp_10 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_11, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_11, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_12 = add nsw i32 %Temp_11,1
;getlement temp temp temp;
  %Temp_13 = getelementptr inbounds i8*, i8** %Temp_10, i32 %Temp_12
;load temp temp;
  %Temp_14 = load i8*, i8** %Temp_13, align 8
%Temp_null_4 = bitcast i8* %Temp_14 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_4, 0
;getlement temp temp temp;
  %Temp_16 = getelementptr inbounds i8, i8* %Temp_14, i32 %Temp_15
  %Temp_17 = bitcast i8* %Temp_16 to i8**
;load temp temp;
%Temp_init_ptr_5 = bitcast i8** %Temp_17 to i32*
%init_state_5 = load i32, i32* %Temp_init_ptr_5,align 4
%is_init_5 = icmp eq i32  %init_state_5, 0
br i1 %is_init_5 , label %error_init_5, label %good_init_5
error_init_5:
call void @InvalidPointer()
br label %good_init_5
good_init_5:
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i8**
  %Temp_18 = load i8*, i8** %Temp_actual_5 , align 8
  call void @PrintString(i8* %Temp_18 )
  %Temp_19 = load i8*, i8** %local_0, align 8
%Temp_null_6 = bitcast i8* %Temp_19 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_5, 0
;getlement temp temp temp;
  %Temp_21 = getelementptr inbounds i8, i8* %Temp_19, i32 %Temp_20
  %Temp_22 = bitcast i8* %Temp_21 to i8***
;load temp temp;
%Temp_init_ptr_7 = bitcast i8*** %Temp_22 to i32*
%init_state_7 = load i32, i32* %Temp_init_ptr_7,align 4
%is_init_7 = icmp eq i32  %init_state_7, 0
br i1 %is_init_7 , label %error_init_7, label %good_init_7
error_init_7:
call void @InvalidPointer()
br label %good_init_7
good_init_7:
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i8***
  %Temp_23 = load i8**, i8*** %Temp_actual_7 , align 8
%Temp_null_8 = bitcast i8** %Temp_23 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_6, 1
%Temp_i32_9 = bitcast i8** %Temp_23 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_24, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_24, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_25 = add nsw i32 %Temp_24,1
;getlement temp temp temp;
  %Temp_26 = getelementptr inbounds i8*, i8** %Temp_23, i32 %Temp_25
;load temp temp;
  %Temp_27 = load i8*, i8** %Temp_26, align 8
%Temp_null_10 = bitcast i8* %Temp_27 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_7, 0
;getlement temp temp temp;
  %Temp_29 = getelementptr inbounds i8, i8* %Temp_27, i32 %Temp_28
  %Temp_30 = bitcast i8* %Temp_29 to i8**
;load temp temp;
%Temp_init_ptr_11 = bitcast i8** %Temp_30 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i8**
  %Temp_31 = load i8*, i8** %Temp_actual_11 , align 8
  call void @PrintString(i8* %Temp_31 )
  %Temp_32 = load i8*, i8** %local_1, align 8
%Temp_null_12 = bitcast i8* %Temp_32 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_8, 0
;getlement temp temp temp;
  %Temp_34 = getelementptr inbounds i8, i8* %Temp_32, i32 %Temp_33
  %Temp_35 = bitcast i8* %Temp_34 to i8***
;load temp temp;
%Temp_init_ptr_13 = bitcast i8*** %Temp_35 to i32*
%init_state_13 = load i32, i32* %Temp_init_ptr_13,align 4
%is_init_13 = icmp eq i32  %init_state_13, 0
br i1 %is_init_13 , label %error_init_13, label %good_init_13
error_init_13:
call void @InvalidPointer()
br label %good_init_13
good_init_13:
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i8***
  %Temp_36 = load i8**, i8*** %Temp_actual_13 , align 8
%Temp_null_14 = bitcast i8** %Temp_36 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_9, 1
%Temp_i32_15 = bitcast i8** %Temp_36 to i32*
%Temp_size_ptr_15 = getelementptr inbounds i32, i32* %Temp_i32_15, i32 0
%arr_size_15 = load i32, i32* %Temp_size_ptr_15,align 4
%sub_negative_15 = icmp slt i32  %Temp_37, 0
br i1 %sub_negative_15 , label %error_idx_15, label %positive_idx_15
positive_idx_15:
%out_of_bounds_15 = icmp sge i32 %Temp_37, %arr_size_15
br i1 %out_of_bounds_15 , label %error_idx_15, label %continue_idx_15
error_idx_15:
call void @AccessViolation()
br label %continue_idx_15
continue_idx_15:
  %Temp_38 = add nsw i32 %Temp_37,1
;getlement temp temp temp;
  %Temp_39 = getelementptr inbounds i8*, i8** %Temp_36, i32 %Temp_38
;load temp temp;
  %Temp_40 = load i8*, i8** %Temp_39, align 8
%Temp_null_16 = bitcast i8* %Temp_40 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_10, 0
;getlement temp temp temp;
  %Temp_42 = getelementptr inbounds i8, i8* %Temp_40, i32 %Temp_41
  %Temp_43 = bitcast i8* %Temp_42 to i8**
;load temp temp;
%Temp_init_ptr_17 = bitcast i8** %Temp_43 to i32*
%init_state_17 = load i32, i32* %Temp_init_ptr_17,align 4
%is_init_17 = icmp eq i32  %init_state_17, 0
br i1 %is_init_17 , label %error_init_17, label %good_init_17
error_init_17:
call void @InvalidPointer()
br label %good_init_17
good_init_17:
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i8**
  %Temp_44 = load i8*, i8** %Temp_actual_17 , align 8
  call void @PrintString(i8* %Temp_44 )
  %Temp_45 = load i8*, i8** %local_1, align 8
%Temp_null_18 = bitcast i8* %Temp_45 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_11, 0
;getlement temp temp temp;
  %Temp_47 = getelementptr inbounds i8, i8* %Temp_45, i32 %Temp_46
  %Temp_48 = bitcast i8* %Temp_47 to i8***
;load temp temp;
%Temp_init_ptr_19 = bitcast i8*** %Temp_48 to i32*
%init_state_19 = load i32, i32* %Temp_init_ptr_19,align 4
%is_init_19 = icmp eq i32  %init_state_19, 0
br i1 %is_init_19 , label %error_init_19, label %good_init_19
error_init_19:
call void @InvalidPointer()
br label %good_init_19
good_init_19:
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i8***
  %Temp_49 = load i8**, i8*** %Temp_actual_19 , align 8
%Temp_null_20 = bitcast i8** %Temp_49 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_50 = add nsw i32 %zero_12, 4
%Temp_i32_21 = bitcast i8** %Temp_49 to i32*
%Temp_size_ptr_21 = getelementptr inbounds i32, i32* %Temp_i32_21, i32 0
%arr_size_21 = load i32, i32* %Temp_size_ptr_21,align 4
%sub_negative_21 = icmp slt i32  %Temp_50, 0
br i1 %sub_negative_21 , label %error_idx_21, label %positive_idx_21
positive_idx_21:
%out_of_bounds_21 = icmp sge i32 %Temp_50, %arr_size_21
br i1 %out_of_bounds_21 , label %error_idx_21, label %continue_idx_21
error_idx_21:
call void @AccessViolation()
br label %continue_idx_21
continue_idx_21:
  %Temp_51 = add nsw i32 %Temp_50,1
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8*, i8** %Temp_49, i32 %Temp_51
;load temp temp;
  %Temp_53 = load i8*, i8** %Temp_52, align 8
%Temp_null_22 = bitcast i8* %Temp_53 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_13, 0
;getlement temp temp temp;
  %Temp_55 = getelementptr inbounds i8, i8* %Temp_53, i32 %Temp_54
  %Temp_56 = bitcast i8* %Temp_55 to i8**
;load temp temp;
%Temp_init_ptr_23 = bitcast i8** %Temp_56 to i32*
%init_state_23 = load i32, i32* %Temp_init_ptr_23,align 4
%is_init_23 = icmp eq i32  %init_state_23, 0
br i1 %is_init_23 , label %error_init_23, label %good_init_23
error_init_23:
call void @InvalidPointer()
br label %good_init_23
good_init_23:
%Temp_actual_ptr_23 = getelementptr inbounds i32, i32* %Temp_init_ptr_23, i32 1
%Temp_actual_23 = bitcast i32* %Temp_actual_ptr_23 to i8**
  %Temp_57 = load i8*, i8** %Temp_actual_23 , align 8
  call void @PrintString(i8* %Temp_57 )
  %Temp_58 = load i8*, i8** %local_1, align 8
%Temp_null_24 = bitcast i8* %Temp_58 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_59 = add nsw i32 %zero_14, 0
;getlement temp temp temp;
  %Temp_60 = getelementptr inbounds i8, i8* %Temp_58, i32 %Temp_59
  %Temp_61 = bitcast i8* %Temp_60 to i8***
;load temp temp;
%Temp_init_ptr_25 = bitcast i8*** %Temp_61 to i32*
%init_state_25 = load i32, i32* %Temp_init_ptr_25,align 4
%is_init_25 = icmp eq i32  %init_state_25, 0
br i1 %is_init_25 , label %error_init_25, label %good_init_25
error_init_25:
call void @InvalidPointer()
br label %good_init_25
good_init_25:
%Temp_actual_ptr_25 = getelementptr inbounds i32, i32* %Temp_init_ptr_25, i32 1
%Temp_actual_25 = bitcast i32* %Temp_actual_ptr_25 to i8***
  %Temp_62 = load i8**, i8*** %Temp_actual_25 , align 8
%Temp_null_26 = bitcast i8** %Temp_62 to i32*
%equal_null_26 = icmp eq i32* %Temp_null_26, null
br i1 %equal_null_26, label %null_deref_26, label %continue_26
null_deref_26:
call void @InvalidPointer()
br label %continue_26
continue_26:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_63 = add nsw i32 %zero_15, 10
%Temp_i32_27 = bitcast i8** %Temp_62 to i32*
%Temp_size_ptr_27 = getelementptr inbounds i32, i32* %Temp_i32_27, i32 0
%arr_size_27 = load i32, i32* %Temp_size_ptr_27,align 4
%sub_negative_27 = icmp slt i32  %Temp_63, 0
br i1 %sub_negative_27 , label %error_idx_27, label %positive_idx_27
positive_idx_27:
%out_of_bounds_27 = icmp sge i32 %Temp_63, %arr_size_27
br i1 %out_of_bounds_27 , label %error_idx_27, label %continue_idx_27
error_idx_27:
call void @AccessViolation()
br label %continue_idx_27
continue_idx_27:
  %Temp_64 = add nsw i32 %Temp_63,1
;getlement temp temp temp;
  %Temp_65 = getelementptr inbounds i8*, i8** %Temp_62, i32 %Temp_64
;load temp temp;
  %Temp_66 = load i8*, i8** %Temp_65, align 8
%Temp_null_28 = bitcast i8* %Temp_66 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_67 = add nsw i32 %zero_16, 0
;getlement temp temp temp;
  %Temp_68 = getelementptr inbounds i8, i8* %Temp_66, i32 %Temp_67
  %Temp_69 = bitcast i8* %Temp_68 to i8**
;load temp temp;
%Temp_init_ptr_29 = bitcast i8** %Temp_69 to i32*
%init_state_29 = load i32, i32* %Temp_init_ptr_29,align 4
%is_init_29 = icmp eq i32  %init_state_29, 0
br i1 %is_init_29 , label %error_init_29, label %good_init_29
error_init_29:
call void @InvalidPointer()
br label %good_init_29
good_init_29:
%Temp_actual_ptr_29 = getelementptr inbounds i32, i32* %Temp_init_ptr_29, i32 1
%Temp_actual_29 = bitcast i32* %Temp_actual_ptr_29 to i8**
  %Temp_70 = load i8*, i8** %Temp_actual_29 , align 8
  call void @PrintString(i8* %Temp_70 )
call void @exit(i32 0)
  ret void
}
