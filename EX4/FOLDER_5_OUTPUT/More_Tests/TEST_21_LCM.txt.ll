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
  %local_2 = alloca i32, align 4
  %local_0 = alloca i32, align 4
  %local_3 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_4 = alloca i32, align 4
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 12
  store i32 %Temp_0, i32* %local_0, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_1, 4
  store i32 %Temp_1, i32* %local_1, align 4
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_3 = load i32, i32* %local_1, align 4
  %Temp_4 = load i32, i32* %local_0, align 4
  %Temp_2 = icmp eq i32 %Temp_3, %Temp_4
  %Temp_5 = zext i1 %Temp_2 to i32
  %equal_zero_2 = icmp eq i32 %Temp_5, 0
  br i1 %equal_zero_2, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %Temp_6 = load i32, i32* %local_0, align 4
  store i32 %Temp_6, i32* %local_2, align 4
  %Temp_7 = load i32, i32* %local_0, align 4
  call void @PrintInt(i32 %Temp_7 )
  ret void
  br label %Label_2_if.exit

Label_2_if.exit:

  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_9 = load i32, i32* %local_1, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_3, 1
  %Temp_8 = icmp eq i32 %Temp_9, %Temp_10
  %Temp_11 = zext i1 %Temp_8 to i32
  %equal_zero_4 = icmp eq i32 %Temp_11, 0
  br i1 %equal_zero_4, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  %Temp_12 = load i32, i32* %local_0, align 4
  store i32 %Temp_12, i32* %local_2, align 4
  %Temp_13 = load i32, i32* %local_0, align 4
  call void @PrintInt(i32 %Temp_13 )
  ret void
  br label %Label_5_if.exit

Label_5_if.exit:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_15 = load i32, i32* %local_0, align 4
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_5, 1
  %Temp_14 = icmp eq i32 %Temp_15, %Temp_16
  %Temp_17 = zext i1 %Temp_14 to i32
  %equal_zero_6 = icmp eq i32 %Temp_17, 0
  br i1 %equal_zero_6, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %Temp_18 = load i32, i32* %local_1, align 4
  store i32 %Temp_18, i32* %local_2, align 4
  %Temp_19 = load i32, i32* %local_1, align 4
  call void @PrintInt(i32 %Temp_19 )
  ret void
  br label %Label_8_if.exit

Label_8_if.exit:

  br label %Label_9_if.cond

Label_9_if.cond:

  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_7, 1
  %Temp_23 = load i32, i32* %local_0, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_8, 1
  %Temp_22 = icmp eq i32 %Temp_23, %Temp_24
  %Temp_25 = zext i1 %Temp_22 to i32
  %Temp_20 = sub nsw i32 %Temp_21, %Temp_25
%Temp_26 = call i32 @CheckOverflow(i32 %Temp_20)
  %equal_zero_9 = icmp eq i32 %Temp_26, 0
  br i1 %equal_zero_9, label %Label_11_if.exit, label %Label_10_if.body
  
Label_10_if.body:

  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_10, 0
  store i32 %Temp_27, i32* %local_2, align 4
  %Temp_28 = load i32, i32* %local_0, align 4
  store i32 %Temp_28, i32* %local_3, align 4
  %Temp_29 = load i32, i32* %local_1, align 4
  store i32 %Temp_29, i32* %local_4, align 4
  br label %Label_14_while.cond

Label_14_while.cond:

  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_11, 1
  %Temp_33 = load i32, i32* %local_3, align 4
  %Temp_34 = load i32, i32* %local_4, align 4
  %Temp_32 = icmp eq i32 %Temp_33, %Temp_34
  %Temp_35 = zext i1 %Temp_32 to i32
  %Temp_30 = sub nsw i32 %Temp_31, %Temp_35
%Temp_36 = call i32 @CheckOverflow(i32 %Temp_30)
  %equal_zero_12 = icmp eq i32 %Temp_36, 0
  br i1 %equal_zero_12, label %Label_12_while.end, label %Label_13_while.body
  
Label_13_while.body:

  br label %Label_17_while.cond

Label_17_while.cond:

  %Temp_38 = load i32, i32* %local_3, align 4
  %Temp_39 = load i32, i32* %local_4, align 4
  %Temp_37 = icmp slt i32 %Temp_38, %Temp_39
  %Temp_40 = zext i1 %Temp_37 to i32
  %equal_zero_13 = icmp eq i32 %Temp_40, 0
  br i1 %equal_zero_13, label %Label_15_while.end, label %Label_16_while.body
  
Label_16_while.body:

  %Temp_42 = load i32, i32* %local_3, align 4
  %Temp_43 = load i32, i32* %local_0, align 4
  %Temp_41 = add nsw i32 %Temp_42, %Temp_43
%Temp_44 = call i32 @CheckOverflow(i32 %Temp_41)
  store i32 %Temp_44, i32* %local_3, align 4
  br label %Label_17_while.cond

Label_15_while.end:

  br label %Label_20_while.cond

Label_20_while.cond:

  %Temp_46 = load i32, i32* %local_4, align 4
  %Temp_47 = load i32, i32* %local_3, align 4
  %Temp_45 = icmp slt i32 %Temp_46, %Temp_47
  %Temp_48 = zext i1 %Temp_45 to i32
  %equal_zero_14 = icmp eq i32 %Temp_48, 0
  br i1 %equal_zero_14, label %Label_18_while.end, label %Label_19_while.body
  
Label_19_while.body:

  %Temp_50 = load i32, i32* %local_4, align 4
  %Temp_51 = load i32, i32* %local_1, align 4
  %Temp_49 = add nsw i32 %Temp_50, %Temp_51
%Temp_52 = call i32 @CheckOverflow(i32 %Temp_49)
  store i32 %Temp_52, i32* %local_4, align 4
  br label %Label_20_while.cond

Label_18_while.end:

  br label %Label_14_while.cond

Label_12_while.end:

  %Temp_53 = load i32, i32* %local_3, align 4
  store i32 %Temp_53, i32* %local_2, align 4
  %Temp_54 = load i32, i32* %local_3, align 4
  call void @PrintInt(i32 %Temp_54 )
  ret void
  br label %Label_11_if.exit

Label_11_if.exit:

call void @exit(i32 0)
  ret void
}
