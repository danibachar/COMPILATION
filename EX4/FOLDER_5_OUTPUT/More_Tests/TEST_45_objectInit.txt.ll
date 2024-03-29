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
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 24
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 0
;getlement temp temp temp;
  %Temp_4 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_3
  %Temp_5 = bitcast i8* %Temp_4 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_2, 11
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_5 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_6, i32* %Temp_actual_0, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_3, 8
;getlement temp temp temp;
  %Temp_8 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_7
  %Temp_9 = bitcast i8* %Temp_8 to i32*
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_4, 9
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_9 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_10, i32* %Temp_actual_1, align 4
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_5, 16
;getlement temp temp temp;
  %Temp_12 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_11
  %Temp_13 = bitcast i8* %Temp_12 to i32*
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_6, 7
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_2 = bitcast i32* %Temp_13 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  store i32 %Temp_14, i32* %Temp_actual_2, align 4
  store i8* %Temp_0, i8** %local_0, align 8
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_16 = load i8*, i8** %local_0, align 8
%Temp_null_3 = bitcast i8* %Temp_16 to i32*
%equal_null_3 = icmp eq i32* %Temp_null_3, null
br i1 %equal_null_3, label %null_deref_3, label %continue_3
null_deref_3:
call void @InvalidPointer()
br label %continue_3
continue_3:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_7, 16
;getlement temp temp temp;
  %Temp_18 = getelementptr inbounds i8, i8* %Temp_16, i32 %Temp_17
  %Temp_19 = bitcast i8* %Temp_18 to i32*
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_8, 7
;load temp temp;
%Temp_init_ptr_4 = bitcast i32* %Temp_19 to i32*
%init_state_4 = load i32, i32* %Temp_init_ptr_4,align 4
%is_init_4 = icmp eq i32  %init_state_4, 0
br i1 %is_init_4 , label %error_init_4, label %good_init_4
error_init_4:
call void @InvalidPointer()
br label %good_init_4
good_init_4:
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  %Temp_21 = load i32, i32* %Temp_actual_4 , align 4
  %Temp_15 = icmp eq i32 %Temp_21, %Temp_20
  %Temp_22 = zext i1 %Temp_15 to i32
  %equal_zero_9 = icmp eq i32 %Temp_22, 0
  br i1 %equal_zero_9, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_24 = load i8*, i8** %local_0, align 8
%Temp_null_5 = bitcast i8* %Temp_24 to i32*
%equal_null_5 = icmp eq i32* %Temp_null_5, null
br i1 %equal_null_5, label %null_deref_5, label %continue_5
null_deref_5:
call void @InvalidPointer()
br label %continue_5
continue_5:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_10, 8
;getlement temp temp temp;
  %Temp_26 = getelementptr inbounds i8, i8* %Temp_24, i32 %Temp_25
  %Temp_27 = bitcast i8* %Temp_26 to i32*
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_11, 9
;load temp temp;
%Temp_init_ptr_6 = bitcast i32* %Temp_27 to i32*
%init_state_6 = load i32, i32* %Temp_init_ptr_6,align 4
%is_init_6 = icmp eq i32  %init_state_6, 0
br i1 %is_init_6 , label %error_init_6, label %good_init_6
error_init_6:
call void @InvalidPointer()
br label %good_init_6
good_init_6:
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  %Temp_29 = load i32, i32* %Temp_actual_6 , align 4
  %Temp_23 = icmp eq i32 %Temp_29, %Temp_28
  %Temp_30 = zext i1 %Temp_23 to i32
  %equal_zero_12 = icmp eq i32 %Temp_30, 0
  br i1 %equal_zero_12, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_32 = load i8*, i8** %local_0, align 8
%Temp_null_7 = bitcast i8* %Temp_32 to i32*
%equal_null_7 = icmp eq i32* %Temp_null_7, null
br i1 %equal_null_7, label %null_deref_7, label %continue_7
null_deref_7:
call void @InvalidPointer()
br label %continue_7
continue_7:
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_13, 0
;getlement temp temp temp;
  %Temp_34 = getelementptr inbounds i8, i8* %Temp_32, i32 %Temp_33
  %Temp_35 = bitcast i8* %Temp_34 to i32*
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_14, 11
;load temp temp;
%Temp_init_ptr_8 = bitcast i32* %Temp_35 to i32*
%init_state_8 = load i32, i32* %Temp_init_ptr_8,align 4
%is_init_8 = icmp eq i32  %init_state_8, 0
br i1 %is_init_8 , label %error_init_8, label %good_init_8
error_init_8:
call void @InvalidPointer()
br label %good_init_8
good_init_8:
%Temp_actual_ptr_8 = getelementptr inbounds i32, i32* %Temp_init_ptr_8, i32 1
%Temp_actual_8 = bitcast i32* %Temp_actual_ptr_8 to i32*
  %Temp_37 = load i32, i32* %Temp_actual_8 , align 4
  %Temp_31 = icmp eq i32 %Temp_37, %Temp_36
  %Temp_38 = zext i1 %Temp_31 to i32
  %equal_zero_15 = icmp eq i32 %Temp_38, 0
  br i1 %equal_zero_15, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_16, 7
  call void @PrintInt(i32 %Temp_39 )
  br label %Label_8_if.exit

Label_8_if.exit:

  br label %Label_5_if.exit

Label_5_if.exit:

  br label %Label_2_if.exit

Label_2_if.exit:

call void @exit(i32 0)
  ret void
}
