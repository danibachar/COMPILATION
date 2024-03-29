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
  %local_1 = alloca i8*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 32
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  store i8* %Temp_0, i8** %local_0, align 8
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_1, 32
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
  %Temp_9 = bitcast i8* %Temp_8 to i32*
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_3, 1
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_9 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_10, i32* %Temp_actual_1, align 4
  %Temp_11 = load i8*, i8** %local_1, align 8
%Temp_null_2 = bitcast i8* %Temp_11 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_4, 0
;getlement temp temp temp;
  %Temp_13 = getelementptr inbounds i8, i8* %Temp_11, i32 %Temp_12
  %Temp_14 = bitcast i8* %Temp_13 to i32*
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_5, 2
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_14 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_15, i32* %Temp_actual_3, align 4
  %Temp_16 = load i8*, i8** %local_1, align 8
%Temp_null_4 = bitcast i8* %Temp_16 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_6, 8
;getlement temp temp temp;
  %Temp_18 = getelementptr inbounds i8, i8* %Temp_16, i32 %Temp_17
  %Temp_19 = bitcast i8* %Temp_18 to i32*
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_7, 3
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_19 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_20, i32* %Temp_actual_5, align 4
  %Temp_21 = load i8*, i8** %local_1, align 8
%Temp_null_6 = bitcast i8* %Temp_21 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_8, 16
;getlement temp temp temp;
  %Temp_23 = getelementptr inbounds i8, i8* %Temp_21, i32 %Temp_22
  %Temp_24 = bitcast i8* %Temp_23 to i32*
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_9, 4
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_7 = bitcast i32* %Temp_24 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  store i32 %Temp_25, i32* %Temp_actual_7, align 4
  %Temp_26 = load i8*, i8** %local_1, align 8
%Temp_null_8 = bitcast i8* %Temp_26 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_10, 24
;getlement temp temp temp;
  %Temp_28 = getelementptr inbounds i8, i8* %Temp_26, i32 %Temp_27
  %Temp_29 = bitcast i8* %Temp_28 to i32*
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_30 = add nsw i32 %zero_11, 5
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_9 = bitcast i32* %Temp_29 to i32*
store i32 1, i32* %Temp_init_ptr_9,align 4
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  store i32 %Temp_30, i32* %Temp_actual_9, align 4
  %Temp_31 = load i8*, i8** %local_0, align 8
%Temp_null_10 = bitcast i8* %Temp_31 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_12, 0
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
  call void @PrintInt(i32 %Temp_35 )
  %Temp_39 = load i8*, i8** %local_1, align 8
%Temp_null_12 = bitcast i8* %Temp_39 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_13, 0
;getlement temp temp temp;
  %Temp_41 = getelementptr inbounds i8, i8* %Temp_39, i32 %Temp_40
  %Temp_42 = bitcast i8* %Temp_41 to i32*
  %Temp_43 = load i8*, i8** %local_1, align 8
%Temp_null_13 = bitcast i8* %Temp_43 to i32*
%equal_null_13 = icmp eq i32* %Temp_null_13, null
br i1 %equal_null_13, label %null_deref_13, label %continue_13
null_deref_13:
call void @InvalidPointer()
br label %continue_13
continue_13:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_14, 8
;getlement temp temp temp;
  %Temp_45 = getelementptr inbounds i8, i8* %Temp_43, i32 %Temp_44
  %Temp_46 = bitcast i8* %Temp_45 to i32*
;load temp temp;
%Temp_init_ptr_14 = bitcast i32* %Temp_46 to i32*
%init_state_14 = load i32, i32* %Temp_init_ptr_14,align 4
%is_init_14 = icmp eq i32  %init_state_14, 0
br i1 %is_init_14 , label %error_init_14, label %good_init_14
error_init_14:
call void @InvalidPointer()
br label %good_init_14
good_init_14:
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32*
  %Temp_47 = load i32, i32* %Temp_actual_14 , align 4
;load temp temp;
%Temp_init_ptr_15 = bitcast i32* %Temp_42 to i32*
%init_state_15 = load i32, i32* %Temp_init_ptr_15,align 4
%is_init_15 = icmp eq i32  %init_state_15, 0
br i1 %is_init_15 , label %error_init_15, label %good_init_15
error_init_15:
call void @InvalidPointer()
br label %good_init_15
good_init_15:
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  %Temp_48 = load i32, i32* %Temp_actual_15 , align 4
  %Temp_38 = add nsw i32 %Temp_48, %Temp_47
%Temp_49 = call i32 @CheckOverflow(i32 %Temp_38)
  %Temp_50 = load i8*, i8** %local_1, align 8
%Temp_null_16 = bitcast i8* %Temp_50 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_15, 16
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8, i8* %Temp_50, i32 %Temp_51
  %Temp_53 = bitcast i8* %Temp_52 to i32*
;load temp temp;
%Temp_init_ptr_17 = bitcast i32* %Temp_53 to i32*
%init_state_17 = load i32, i32* %Temp_init_ptr_17,align 4
%is_init_17 = icmp eq i32  %init_state_17, 0
br i1 %is_init_17 , label %error_init_17, label %good_init_17
error_init_17:
call void @InvalidPointer()
br label %good_init_17
good_init_17:
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  %Temp_54 = load i32, i32* %Temp_actual_17 , align 4
  %Temp_37 = add nsw i32 %Temp_49, %Temp_54
%Temp_55 = call i32 @CheckOverflow(i32 %Temp_37)
  %Temp_56 = load i8*, i8** %local_1, align 8
%Temp_null_18 = bitcast i8* %Temp_56 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_57 = add nsw i32 %zero_16, 24
;getlement temp temp temp;
  %Temp_58 = getelementptr inbounds i8, i8* %Temp_56, i32 %Temp_57
  %Temp_59 = bitcast i8* %Temp_58 to i32*
;load temp temp;
%Temp_init_ptr_19 = bitcast i32* %Temp_59 to i32*
%init_state_19 = load i32, i32* %Temp_init_ptr_19,align 4
%is_init_19 = icmp eq i32  %init_state_19, 0
br i1 %is_init_19 , label %error_init_19, label %good_init_19
error_init_19:
call void @InvalidPointer()
br label %good_init_19
good_init_19:
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32*
  %Temp_60 = load i32, i32* %Temp_actual_19 , align 4
  %Temp_36 = add nsw i32 %Temp_55, %Temp_60
%Temp_61 = call i32 @CheckOverflow(i32 %Temp_36)
  call void @PrintInt(i32 %Temp_61 )
call void @exit(i32 0)
  ret void
}
