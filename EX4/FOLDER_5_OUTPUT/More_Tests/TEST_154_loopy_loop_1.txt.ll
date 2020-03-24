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

@STR.xxxxW = constant [6 x i8] c"xxxxW\00", align 1
@STR.W = constant [2 x i8] c"W\00", align 1
@STR.x = constant [2 x i8] c"x\00", align 1
define i8* @addx(i8*)
 { 
  %str = alloca i8*, align 8
  store i8* %0, i8** %str, align 8
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.x, i32 0, i32 0), i8** %str_0, align 8
  %Temp_1 = load i8*, i8** %str_0, align 8
  %Temp_2 = load i8*, i8** %str, align 8
%oprnd1_size_0 = call i32 @strlen(i8* %Temp_1)
%oprnd2_size_0 = call i32 @strlen(i8* %Temp_2)
%new_size_0 = add nsw i32 %oprnd1_size_0, %oprnd2_size_0
%allocated_i32_0 = call i32* @malloc(i32 %new_size_0)
%allocated_0 = bitcast i32* %allocated_i32_0 to i8*
%new_0 = call i8* @strcpy(i8* %allocated_0, i8* %Temp_1)
%Temp_0 = call i8* @strcat(i8* %new_0, i8* %Temp_2)
  ret i8* %Temp_0
}
define void @realMain()
 { 
  %local_0 = alloca i8*, align 8
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.W, i32 0, i32 0), i8** %str_1, align 8
  %Temp_3 = load i8*, i8** %str_1, align 8
  store i8* %Temp_3, i8** %local_0, align 8
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_6 = load i8*, i8** %local_0, align 8
  %str_2 = alloca i8*
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @STR.xxxxW, i32 0, i32 0), i8** %str_2, align 8
  %Temp_7 = load i8*, i8** %str_2, align 8
%str_cmp_0 = call i32 @strcmp(i8* %Temp_6, i8* %Temp_7)
  %Temp_5 = icmp eq i32 %str_cmp_0, 0
  %Temp_8 = zext i1 %Temp_5 to i32
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_0, 1
  %Temp_4 = icmp eq i32 %Temp_8, %Temp_9
  %Temp_10 = zext i1 %Temp_4 to i32
  %equal_zero_1 = icmp eq i32 %Temp_10, 0
  br i1 %equal_zero_1, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_11 = load i8*, i8** %local_0, align 8
  call void @PrintString(i8* %Temp_11 )
  %Temp_12 = load i8*, i8** %local_0, align 8
%Temp_13 =call i8* @addx(i8* %Temp_12 )
  store i8* %Temp_13, i8** %local_0, align 8
  br label %Label_2_while.cond

Label_0_while.end:

  %Temp_14 = load i8*, i8** %local_0, align 8
  call void @PrintString(i8* %Temp_14 )
  ret void
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  call void @init_globals()
  call void @realMain()
call void @exit(i32 0)
  ret void
}
