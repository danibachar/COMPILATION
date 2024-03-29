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

@STR.Hello = constant [6 x i8] c"Hello\00", align 1
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_4 = alloca i8*, align 8
  %local_1 = alloca i32, align 4
  %local_3 = alloca i32, align 4
  %local_5 = alloca i8*, align 8
  %local_0 = alloca i32, align 4
  %local_2 = alloca i32, align 4
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 3
  store i32 %Temp_0, i32* %local_0, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_1, 4
  store i32 %Temp_1, i32* %local_1, align 4
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_2, 6
  store i32 %Temp_2, i32* %local_2, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_3, 7
  store i32 %Temp_3, i32* %local_3, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_4, 28
  %Temp_6 = call i32* @malloc(i32 %Temp_5)
  %Temp_4 = bitcast i32* %Temp_6 to i8*
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_5, 12
;getlement temp temp temp;
  %Temp_8 = getelementptr inbounds i8, i8* %Temp_4, i32 %Temp_7
  %Temp_9 = bitcast i8* %Temp_8 to i32*
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_6, 5
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_9 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_10, i32* %Temp_actual_0, align 4
  store i8* %Temp_4, i8** %local_4, align 8
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_7, 48
  %Temp_13 = call i32* @malloc(i32 %Temp_12)
  %Temp_11 = bitcast i32* %Temp_13 to i8*
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_8, 28
;getlement temp temp temp;
  %Temp_15 = getelementptr inbounds i8, i8* %Temp_11, i32 %Temp_14
  %Temp_16 = bitcast i8* %Temp_15 to i8**
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @STR.Hello, i32 0, i32 0), i8** %str_0, align 8
  %Temp_17 = load i8*, i8** %str_0, align 8
;store TYPES.TYPE_STRING@1d56ce6a dst src;
%Temp_init_ptr_1 = bitcast i8** %Temp_16 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i8**
  store i8* %Temp_17, i8** %Temp_actual_1, align 8
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_9, 40
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_11, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i32*
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_10, 30
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_2 = bitcast i32* %Temp_20 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  store i32 %Temp_21, i32* %Temp_actual_2, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_11, 12
;getlement temp temp temp;
  %Temp_23 = getelementptr inbounds i8, i8* %Temp_11, i32 %Temp_22
  %Temp_24 = bitcast i8* %Temp_23 to i32*
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_12, 5
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_24 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_25, i32* %Temp_actual_3, align 4
  store i8* %Temp_11, i8** %local_5, align 8
  %Temp_26 = load i8*, i8** %local_5, align 8
%Temp_null_4 = bitcast i8* %Temp_26 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_13, 20
;getlement temp temp temp;
  %Temp_28 = getelementptr inbounds i8, i8* %Temp_26, i32 %Temp_27
  %Temp_29 = bitcast i8* %Temp_28 to i32*
  %Temp_30 = load i32, i32* %local_2, align 4
;store TYPES.TYPE_INT@439f5b3d dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_29 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_30, i32* %Temp_actual_5, align 4
  %Temp_31 = load i8*, i8** %local_5, align 8
%Temp_null_6 = bitcast i8* %Temp_31 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_14, 28
;getlement temp temp temp;
  %Temp_33 = getelementptr inbounds i8, i8* %Temp_31, i32 %Temp_32
  %Temp_34 = bitcast i8* %Temp_33 to i8**
;load temp temp;
%Temp_init_ptr_7 = bitcast i8** %Temp_34 to i32*
%init_state_7 = load i32, i32* %Temp_init_ptr_7,align 4
%is_init_7 = icmp eq i32  %init_state_7, 0
br i1 %is_init_7 , label %error_init_7, label %good_init_7
error_init_7:
call void @InvalidPointer()
br label %good_init_7
good_init_7:
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i8**
  %Temp_35 = load i8*, i8** %Temp_actual_7 , align 8
  call void @PrintString(i8* %Temp_35 )
  %Temp_40 = load i8*, i8** %local_4, align 8
%Temp_null_8 = bitcast i8* %Temp_40 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_15, 20
;getlement temp temp temp;
  %Temp_42 = getelementptr inbounds i8, i8* %Temp_40, i32 %Temp_41
  %Temp_43 = bitcast i8* %Temp_42 to i32*
  %Temp_44 = load i8*, i8** %local_4, align 8
%Temp_null_9 = bitcast i8* %Temp_44 to i32*
%equal_null_9 = icmp eq i32* %Temp_null_9, null
br i1 %equal_null_9, label %null_deref_9, label %continue_9
null_deref_9:
call void @InvalidPointer()
br label %continue_9
continue_9:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_45 = add nsw i32 %zero_16, 12
;getlement temp temp temp;
  %Temp_46 = getelementptr inbounds i8, i8* %Temp_44, i32 %Temp_45
  %Temp_47 = bitcast i8* %Temp_46 to i32*
;load temp temp;
%Temp_init_ptr_10 = bitcast i32* %Temp_47 to i32*
%init_state_10 = load i32, i32* %Temp_init_ptr_10,align 4
%is_init_10 = icmp eq i32  %init_state_10, 0
br i1 %is_init_10 , label %error_init_10, label %good_init_10
error_init_10:
call void @InvalidPointer()
br label %good_init_10
good_init_10:
%Temp_actual_ptr_10 = getelementptr inbounds i32, i32* %Temp_init_ptr_10, i32 1
%Temp_actual_10 = bitcast i32* %Temp_actual_ptr_10 to i32*
  %Temp_48 = load i32, i32* %Temp_actual_10 , align 4
;load temp temp;
%Temp_init_ptr_11 = bitcast i32* %Temp_43 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  %Temp_49 = load i32, i32* %Temp_actual_11 , align 4
  %Temp_39 = add nsw i32 %Temp_49, %Temp_48
%Temp_50 = call i32 @CheckOverflow(i32 %Temp_39)
  %Temp_51 = load i8*, i8** %local_5, align 8
%Temp_null_12 = bitcast i8* %Temp_51 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_52 = add nsw i32 %zero_17, 20
;getlement temp temp temp;
  %Temp_53 = getelementptr inbounds i8, i8* %Temp_51, i32 %Temp_52
  %Temp_54 = bitcast i8* %Temp_53 to i32*
;load temp temp;
%Temp_init_ptr_13 = bitcast i32* %Temp_54 to i32*
%init_state_13 = load i32, i32* %Temp_init_ptr_13,align 4
%is_init_13 = icmp eq i32  %init_state_13, 0
br i1 %is_init_13 , label %error_init_13, label %good_init_13
error_init_13:
call void @InvalidPointer()
br label %good_init_13
good_init_13:
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i32*
  %Temp_55 = load i32, i32* %Temp_actual_13 , align 4
  %Temp_38 = add nsw i32 %Temp_50, %Temp_55
%Temp_56 = call i32 @CheckOverflow(i32 %Temp_38)
  %Temp_57 = load i8*, i8** %local_5, align 8
%Temp_null_14 = bitcast i8* %Temp_57 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_58 = add nsw i32 %zero_18, 12
;getlement temp temp temp;
  %Temp_59 = getelementptr inbounds i8, i8* %Temp_57, i32 %Temp_58
  %Temp_60 = bitcast i8* %Temp_59 to i32*
;load temp temp;
%Temp_init_ptr_15 = bitcast i32* %Temp_60 to i32*
%init_state_15 = load i32, i32* %Temp_init_ptr_15,align 4
%is_init_15 = icmp eq i32  %init_state_15, 0
br i1 %is_init_15 , label %error_init_15, label %good_init_15
error_init_15:
call void @InvalidPointer()
br label %good_init_15
good_init_15:
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  %Temp_61 = load i32, i32* %Temp_actual_15 , align 4
  %Temp_37 = add nsw i32 %Temp_56, %Temp_61
%Temp_62 = call i32 @CheckOverflow(i32 %Temp_37)
  %Temp_63 = load i8*, i8** %local_5, align 8
%Temp_null_16 = bitcast i8* %Temp_63 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_64 = add nsw i32 %zero_19, 40
;getlement temp temp temp;
  %Temp_65 = getelementptr inbounds i8, i8* %Temp_63, i32 %Temp_64
  %Temp_66 = bitcast i8* %Temp_65 to i32*
;load temp temp;
%Temp_init_ptr_17 = bitcast i32* %Temp_66 to i32*
%init_state_17 = load i32, i32* %Temp_init_ptr_17,align 4
%is_init_17 = icmp eq i32  %init_state_17, 0
br i1 %is_init_17 , label %error_init_17, label %good_init_17
error_init_17:
call void @InvalidPointer()
br label %good_init_17
good_init_17:
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  %Temp_67 = load i32, i32* %Temp_actual_17 , align 4
  %Temp_36 = add nsw i32 %Temp_62, %Temp_67
%Temp_68 = call i32 @CheckOverflow(i32 %Temp_36)
  call void @PrintInt(i32 %Temp_68 )
call void @exit(i32 0)
  ret void
}
