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
  %local_2 = alloca i32, align 4
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 20
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  store i8* %Temp_0, i8** %local_0, align 8
  %Temp_3 = load i8*, i8** %local_0, align 8
  store i8* %Temp_3, i8** %local_1, align 8
  %Temp_4 = load i8*, i8** %local_0, align 8
%Temp_null_0 = bitcast i8* %Temp_4 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_1, 12
;getlement temp temp temp;
  %Temp_6 = getelementptr inbounds i8, i8* %Temp_4, i32 %Temp_5
  %Temp_7 = bitcast i8* %Temp_6 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_2, 0
;store TYPES.TYPE_INT@685f4c2e dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_7 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_8, i32* %Temp_actual_1, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_3, 0
  store i32 %Temp_9, i32* %local_2, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_11 = load i32, i32* %local_2, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_4, 6
  %Temp_10 = icmp slt i32 %Temp_11, %Temp_12
  %Temp_13 = zext i1 %Temp_10 to i32
  %equal_zero_5 = icmp eq i32 %Temp_13, 0
  br i1 %equal_zero_5, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_14 = load i8*, i8** %local_1, align 8
%Temp_null_2 = bitcast i8* %Temp_14 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_6, 0
;getlement temp temp temp;
  %Temp_16 = getelementptr inbounds i8, i8* %Temp_14, i32 %Temp_15
  %Temp_17 = bitcast i8* %Temp_16 to i8**
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_7, 20
  %Temp_20 = call i32* @malloc(i32 %Temp_19)
  %Temp_18 = bitcast i32* %Temp_20 to i8*
;store TYPES.TYPE_CLASS@7daf6ecc dst src;
%Temp_init_ptr_3 = bitcast i8** %Temp_17 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i8**
  store i8* %Temp_18, i8** %Temp_actual_3, align 8
  %Temp_21 = load i8*, i8** %local_1, align 8
%Temp_null_4 = bitcast i8* %Temp_21 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_8, 12
;getlement temp temp temp;
  %Temp_23 = getelementptr inbounds i8, i8* %Temp_21, i32 %Temp_22
  %Temp_24 = bitcast i8* %Temp_23 to i32*
  %Temp_25 = load i32, i32* %local_2, align 4
;store TYPES.TYPE_INT@685f4c2e dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_24 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_25, i32* %Temp_actual_5, align 4
  %Temp_26 = load i8*, i8** %local_1, align 8
%Temp_null_6 = bitcast i8* %Temp_26 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_9, 0
;getlement temp temp temp;
  %Temp_28 = getelementptr inbounds i8, i8* %Temp_26, i32 %Temp_27
  %Temp_29 = bitcast i8* %Temp_28 to i8**
;load temp temp;
%Temp_init_ptr_7 = bitcast i8** %Temp_29 to i32*
%init_state_7 = load i32, i32* %Temp_init_ptr_7,align 4
%is_init_7 = icmp eq i32  %init_state_7, 0
br i1 %is_init_7 , label %error_init_7, label %good_init_7
error_init_7:
call void @InvalidPointer()
br label %good_init_7
good_init_7:
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i8**
  %Temp_30 = load i8*, i8** %Temp_actual_7 , align 8
  store i8* %Temp_30, i8** %local_1, align 8
  %Temp_32 = load i32, i32* %local_2, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_10, 1
  %Temp_31 = add nsw i32 %Temp_32, %Temp_33
%Temp_34 = call i32 @CheckOverflow(i32 %Temp_31)
  store i32 %Temp_34, i32* %local_2, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_35 = add nsw i32 %zero_11, 0
  store i32 %Temp_35, i32* %local_2, align 4
  %Temp_36 = load i8*, i8** %local_0, align 8
  store i8* %Temp_36, i8** %local_1, align 8
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_39 = load i8*, i8** %local_1, align 8
  %Temp_40 = load i32*, i32** @my_null, align 8
  %Temp_41 = bitcast i8* %Temp_39 to i32*
  %Temp_38 = icmp eq i32* %Temp_41, %Temp_40
  %Temp_42 = zext i1 %Temp_38 to i32
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_43 = add nsw i32 %zero_12, 0
  %Temp_37 = icmp eq i32 %Temp_42, %Temp_43
  %Temp_44 = zext i1 %Temp_37 to i32
  %equal_zero_13 = icmp eq i32 %Temp_44, 0
  br i1 %equal_zero_13, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  %Temp_45 = load i8*, i8** %local_1, align 8
%Temp_null_8 = bitcast i8* %Temp_45 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_14, 12
;getlement temp temp temp;
  %Temp_47 = getelementptr inbounds i8, i8* %Temp_45, i32 %Temp_46
  %Temp_48 = bitcast i8* %Temp_47 to i32*
;load temp temp;
%Temp_init_ptr_9 = bitcast i32* %Temp_48 to i32*
%init_state_9 = load i32, i32* %Temp_init_ptr_9,align 4
%is_init_9 = icmp eq i32  %init_state_9, 0
br i1 %is_init_9 , label %error_init_9, label %good_init_9
error_init_9:
call void @InvalidPointer()
br label %good_init_9
good_init_9:
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  %Temp_49 = load i32, i32* %Temp_actual_9 , align 4
  call void @PrintInt(i32 %Temp_49 )
  %Temp_50 = load i8*, i8** %local_1, align 8
%Temp_null_10 = bitcast i8* %Temp_50 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_15, 0
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8, i8* %Temp_50, i32 %Temp_51
  %Temp_53 = bitcast i8* %Temp_52 to i8**
;load temp temp;
%Temp_init_ptr_11 = bitcast i8** %Temp_53 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i8**
  %Temp_54 = load i8*, i8** %Temp_actual_11 , align 8
  store i8* %Temp_54, i8** %local_1, align 8
  br label %Label_5_while.cond

Label_3_while.end:

call void @exit(i32 0)
  ret void
}
