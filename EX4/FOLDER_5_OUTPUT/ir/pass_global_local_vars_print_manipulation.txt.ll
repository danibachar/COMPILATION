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

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@i1 = global i32 0, align 4

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@i2 = global i32 0, align 4

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@i3 = global i32 0, align 4

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@i4 = global i32 0, align 4

define void @init_globals()
 { 
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 101
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 2
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_2, 3
  %Temp_2 = mul nsw i32 %Temp_3, %Temp_4
%Temp_5 = call i32 @CheckOverflow(i32 %Temp_2)
  %Temp_0 = add nsw i32 %Temp_1, %Temp_5
%Temp_6 = call i32 @CheckOverflow(i32 %Temp_0)
  store i32 %Temp_6, i32* @i1, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_3, 15
  store i32 %Temp_7, i32* @i2, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_4, 17
  store i32 %Temp_8, i32* @i3, align 4
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_5, 62
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_6, 2
  %Temp_9 = add nsw i32 %Temp_10, %Temp_11
%Temp_12 = call i32 @CheckOverflow(i32 %Temp_9)
  store i32 %Temp_12, i32* @i4, align 4
  ret void
}
define void @main()
 { 
  %local_0 = alloca i32, align 4
  call void @init_globals()
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_7, 3
  store i32 %Temp_13, i32* %local_0, align 4
  %Temp_14 = load i32, i32* %local_0, align 4
  call void @PrintInt(i32 %Temp_14 )
  %Temp_15 = load i32, i32* @i2, align 4
  call void @PrintInt(i32 %Temp_15 )
  %Temp_17 = load i32, i32* @i2, align 4
  %Temp_18 = load i32, i32* %local_0, align 4
  %Temp_16 = add nsw i32 %Temp_17, %Temp_18
%Temp_19 = call i32 @CheckOverflow(i32 %Temp_16)
  call void @PrintInt(i32 %Temp_19 )
  %Temp_21 = load i32, i32* @i2, align 4
  %Temp_22 = load i32, i32* @i3, align 4
  %Temp_20 = add nsw i32 %Temp_21, %Temp_22
%Temp_23 = call i32 @CheckOverflow(i32 %Temp_20)
  call void @PrintInt(i32 %Temp_23 )
  %Temp_25 = load i32, i32* @i2, align 4
  %Temp_27 = load i32, i32* @i3, align 4
  %Temp_28 = load i32, i32* @i4, align 4
  %Temp_26 = mul nsw i32 %Temp_27, %Temp_28
%Temp_29 = call i32 @CheckOverflow(i32 %Temp_26)
  %Temp_24 = add nsw i32 %Temp_25, %Temp_29
%Temp_30 = call i32 @CheckOverflow(i32 %Temp_24)
  call void @PrintInt(i32 %Temp_30 )
  %Temp_33 = load i32, i32* @i2, align 4
  %Temp_34 = load i32, i32* @i3, align 4
  %Temp_32 = add nsw i32 %Temp_33, %Temp_34
%Temp_35 = call i32 @CheckOverflow(i32 %Temp_32)
  %Temp_36 = load i32, i32* @i4, align 4
  %Temp_31 = mul nsw i32 %Temp_35, %Temp_36
%Temp_37 = call i32 @CheckOverflow(i32 %Temp_31)
  call void @PrintInt(i32 %Temp_37 )
  ret void
}
