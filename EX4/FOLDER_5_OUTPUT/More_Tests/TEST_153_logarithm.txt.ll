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

define void @PrintPtr(i32* %p)
{
  %Temp1_66  = ptrtoint i32* %p to i32
  call void @PrintInt(i32 %Temp1_66 )
  ret void
}

@.str1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
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

define i32 @log2(i32)
 { 
  %k = alloca i32, align 4
  %local_0 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  store i32 %0, i32* %k, align 4
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_1 = load i32, i32* %k, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_0, 1
  %Temp_0 = icmp eq i32 %Temp_1, %Temp_2
  %Temp_3 = zext i1 %Temp_0 to i32
  %equal_zero_1 = icmp eq i32 %Temp_3, 0
  br i1 %equal_zero_1, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_2, 0
  ret i32 %Temp_4
  br label %Label_2_if.exit

Label_2_if.exit:

  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_3, 2
  store i32 %Temp_5, i32* %local_0, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_4, 1
  store i32 %Temp_6, i32* %local_1, align 4
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_9 = load i32, i32* %local_0, align 4
  %Temp_10 = load i32, i32* %local_0, align 4
  %Temp_8 = mul nsw i32 %Temp_9, %Temp_10
%Temp_11 = call i32 @CheckOverflow(i32 %Temp_8)
  %Temp_12 = load i32, i32* %k, align 4
  %Temp_7 = icmp slt i32 %Temp_11, %Temp_12
  %Temp_13 = zext i1 %Temp_7 to i32
  %equal_zero_5 = icmp eq i32 %Temp_13, 0
  br i1 %equal_zero_5, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  %Temp_15 = load i32, i32* %local_0, align 4
  %Temp_16 = load i32, i32* %local_0, align 4
  %Temp_14 = mul nsw i32 %Temp_15, %Temp_16
%Temp_17 = call i32 @CheckOverflow(i32 %Temp_14)
  store i32 %Temp_17, i32* %local_0, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_6, 2
  %Temp_20 = load i32, i32* %local_1, align 4
  %Temp_18 = mul nsw i32 %Temp_19, %Temp_20
%Temp_21 = call i32 @CheckOverflow(i32 %Temp_18)
  store i32 %Temp_21, i32* %local_1, align 4
  br label %Label_5_while.cond

Label_3_while.end:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_23 = load i32, i32* %local_0, align 4
  %Temp_24 = load i32, i32* %k, align 4
  %Temp_22 = icmp eq i32 %Temp_23, %Temp_24
  %Temp_25 = zext i1 %Temp_22 to i32
  %equal_zero_7 = icmp eq i32 %Temp_25, 0
  br i1 %equal_zero_7, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %Temp_26 = load i32, i32* %local_1, align 4
  ret i32 %Temp_26
  br label %Label_8_if.exit

Label_8_if.exit:

  %Temp_29 = load i32, i32* %k, align 4
  %Temp_30 = load i32, i32* %local_0, align 4
%is_div_zero_0 = icmp eq i32  %Temp_30, 0
br i1 %is_div_zero_0 , label %div_by_zero_0, label %good_div_0
div_by_zero_0:
call void @DivideByZero()
br label %good_div_0
good_div_0:
  %Temp_28 = sdiv i32 %Temp_29, %Temp_30
%Temp_31 = call i32 @CheckOverflow(i32 %Temp_28)
%Temp_32 =call i32 @log2(i32 %Temp_31 )
  %Temp_33 = load i32, i32* %local_1, align 4
  %Temp_27 = add nsw i32 %Temp_32, %Temp_33
%Temp_34 = call i32 @CheckOverflow(i32 %Temp_27)
  ret i32 %Temp_34
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i32, align 4
  %local_2 = alloca i32, align 4
  %local_4 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_3 = alloca i32, align 4
  call void @init_globals()
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_35 = add nsw i32 %zero_8, 512
  store i32 %Temp_35, i32* %local_0, align 4
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_9, 2048
  store i32 %Temp_36, i32* %local_1, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_10, 4
  store i32 %Temp_37, i32* %local_2, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_11, 8
  store i32 %Temp_38, i32* %local_3, align 4
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_12, 1
  store i32 %Temp_39, i32* %local_4, align 4
  %Temp_40 = load i32, i32* %local_0, align 4
%Temp_41 =call i32 @log2(i32 %Temp_40 )
  call void @PrintInt(i32 %Temp_41 )
  %Temp_42 = load i32, i32* %local_1, align 4
%Temp_43 =call i32 @log2(i32 %Temp_42 )
  call void @PrintInt(i32 %Temp_43 )
  %Temp_44 = load i32, i32* %local_2, align 4
%Temp_45 =call i32 @log2(i32 %Temp_44 )
  call void @PrintInt(i32 %Temp_45 )
  %Temp_46 = load i32, i32* %local_3, align 4
%Temp_47 =call i32 @log2(i32 %Temp_46 )
  call void @PrintInt(i32 %Temp_47 )
  %Temp_48 = load i32, i32* %local_4, align 4
%Temp_49 =call i32 @log2(i32 %Temp_48 )
  call void @PrintInt(i32 %Temp_49 )
  ret void
}
