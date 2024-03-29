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

@STR.astring = constant [8 x i8] c"astring\00", align 1
@STR.anotherstring = constant [14 x i8] c"anotherstring\00", align 1
;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@s = global i8* null, align 8

define i32 @IsPrime(i32)
 { 
  %p = alloca i32, align 4
  %local_2 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_0 = alloca i8*, align 8
  store i32 %0, i32* %p, align 4
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @STR.astring, i32 0, i32 0), i8** %str_0, align 8
  %Temp_0 = load i8*, i8** %str_0, align 8
  store i8* %Temp_0, i8** %local_0, align 8
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 2
  store i32 %Temp_1, i32* %local_1, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_1, 2
  store i32 %Temp_2, i32* %local_2, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_4 = load i32, i32* %local_1, align 4
  %Temp_5 = load i32, i32* %p, align 4
  %Temp_3 = icmp slt i32 %Temp_4, %Temp_5
  %Temp_6 = zext i1 %Temp_3 to i32
  %equal_zero_2 = icmp eq i32 %Temp_6, 0
  br i1 %equal_zero_2, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_8 = load i32, i32* %local_2, align 4
  %Temp_9 = load i32, i32* %p, align 4
  %Temp_7 = icmp slt i32 %Temp_8, %Temp_9
  %Temp_10 = zext i1 %Temp_7 to i32
  %equal_zero_3 = icmp eq i32 %Temp_10, 0
  br i1 %equal_zero_3, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_13 = load i32, i32* %local_1, align 4
  %Temp_14 = load i32, i32* %local_2, align 4
  %Temp_12 = mul nsw i32 %Temp_13, %Temp_14
%Temp_15 = call i32 @CheckOverflow(i32 %Temp_12)
  %Temp_16 = load i32, i32* %p, align 4
  %Temp_11 = icmp eq i32 %Temp_15, %Temp_16
  %Temp_17 = zext i1 %Temp_11 to i32
  %equal_zero_4 = icmp eq i32 %Temp_17, 0
  br i1 %equal_zero_4, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_5, 1
  ret i32 %Temp_18
  br label %Label_8_if.exit

Label_8_if.exit:

  %Temp_20 = load i32, i32* %local_2, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_6, 1
  %Temp_19 = add nsw i32 %Temp_20, %Temp_21
%Temp_22 = call i32 @CheckOverflow(i32 %Temp_19)
  store i32 %Temp_22, i32* %local_2, align 4
  br label %Label_5_while.cond

Label_3_while.end:

  %Temp_24 = load i32, i32* %local_1, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_7, 1
  %Temp_23 = add nsw i32 %Temp_24, %Temp_25
%Temp_26 = call i32 @CheckOverflow(i32 %Temp_23)
  store i32 %Temp_26, i32* %local_1, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_8, 0
  ret i32 %Temp_27
}
define void @init_globals()
 { 
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([14 x i8], [14 x i8]* @STR.anotherstring, i32 0, i32 0), i8** %str_1, align 8
  %Temp_28 = load i8*, i8** %str_1, align 8
  store i8* %Temp_28, i8** @s, align 8
  ret void
}
define void @main()
 { 
  %local_1 = alloca i32, align 4
  %local_0 = alloca i32, align 4
  call void @init_globals()
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_9, 2
  store i32 %Temp_29, i32* %local_0, align 4
  br label %Label_11_while.cond

Label_11_while.cond:

  %Temp_31 = load i32, i32* %local_0, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_10, 100
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_11, 1
  %Temp_32 = add nsw i32 %Temp_33, %Temp_34
%Temp_35 = call i32 @CheckOverflow(i32 %Temp_32)
  %Temp_30 = icmp slt i32 %Temp_31, %Temp_35
  %Temp_36 = zext i1 %Temp_30 to i32
  %equal_zero_12 = icmp eq i32 %Temp_36, 0
  br i1 %equal_zero_12, label %Label_9_while.end, label %Label_10_while.body
  
Label_10_while.body:

  %Temp_37 = load i32, i32* %local_0, align 4
%Temp_38 =call i32 @IsPrime(i32 %Temp_37 )
  store i32 %Temp_38, i32* %local_1, align 4
  br label %Label_12_if.cond

Label_12_if.cond:

  %Temp_40 = load i32, i32* %local_1, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_13, 0
  %Temp_39 = icmp eq i32 %Temp_40, %Temp_41
  %Temp_42 = zext i1 %Temp_39 to i32
  %equal_zero_14 = icmp eq i32 %Temp_42, 0
  br i1 %equal_zero_14, label %Label_14_if.exit, label %Label_13_if.body
  
Label_13_if.body:

  %Temp_43 = load i32, i32* %local_0, align 4
  call void @PrintInt(i32 %Temp_43 )
  br label %Label_14_if.exit

Label_14_if.exit:

  %Temp_45 = load i32, i32* %local_0, align 4
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_15, 1
  %Temp_44 = add nsw i32 %Temp_45, %Temp_46
%Temp_47 = call i32 @CheckOverflow(i32 %Temp_44)
  store i32 %Temp_47, i32* %local_0, align 4
  br label %Label_11_while.cond

Label_9_while.end:

call void @exit(i32 0)
  ret void
}
