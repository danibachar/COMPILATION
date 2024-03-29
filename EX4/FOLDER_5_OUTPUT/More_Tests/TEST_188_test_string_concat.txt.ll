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

@STR.That = constant [5 x i8] c"That\00", align 1
@STR.C = constant [2 x i8] c"C\00", align 1
@STR.Be = constant [3 x i8] c"Be\00", align 1
@STR.d = constant [2 x i8] c"d\00", align 1
@STR.e = constant [2 x i8] c"e\00", align 1
@STR.Long = constant [5 x i8] c"Long\00", align 1
@STR.Why = constant [4 x i8] c"Why\00", align 1
@STR.MIPS = constant [5 x i8] c"MIPS\00", align 1
@STR.Must = constant [5 x i8] c"Must\00", align 1
@STR.o = constant [2 x i8] c"o\00", align 1
define i8* @code()
 { 
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.C, i32 0, i32 0), i8** %str_0, align 8
  %Temp_3 = load i8*, i8** %str_0, align 8
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.o, i32 0, i32 0), i8** %str_1, align 8
  %Temp_4 = load i8*, i8** %str_1, align 8
%oprnd1_size_0 = call i32 @strlen(i8* %Temp_3)
%oprnd2_size_0 = call i32 @strlen(i8* %Temp_4)
%new_size_0 = add nsw i32 %oprnd1_size_0, %oprnd2_size_0
%allocated_i32_0 = call i32* @malloc(i32 %new_size_0)
%allocated_0 = bitcast i32* %allocated_i32_0 to i8*
%new_0 = call i8* @strcpy(i8* %allocated_0, i8* %Temp_3)
%Temp_2 = call i8* @strcat(i8* %new_0, i8* %Temp_4)
  %str_2 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.d, i32 0, i32 0), i8** %str_2, align 8
  %Temp_5 = load i8*, i8** %str_2, align 8
%oprnd1_size_1 = call i32 @strlen(i8* %Temp_2)
%oprnd2_size_1 = call i32 @strlen(i8* %Temp_5)
%new_size_1 = add nsw i32 %oprnd1_size_1, %oprnd2_size_1
%allocated_i32_1 = call i32* @malloc(i32 %new_size_1)
%allocated_1 = bitcast i32* %allocated_i32_1 to i8*
%new_1 = call i8* @strcpy(i8* %allocated_1, i8* %Temp_2)
%Temp_1 = call i8* @strcat(i8* %new_1, i8* %Temp_5)
  %str_3 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.e, i32 0, i32 0), i8** %str_3, align 8
  %Temp_6 = load i8*, i8** %str_3, align 8
%oprnd1_size_2 = call i32 @strlen(i8* %Temp_1)
%oprnd2_size_2 = call i32 @strlen(i8* %Temp_6)
%new_size_2 = add nsw i32 %oprnd1_size_2, %oprnd2_size_2
%allocated_i32_2 = call i32* @malloc(i32 %new_size_2)
%allocated_2 = bitcast i32* %allocated_i32_2 to i8*
%new_2 = call i8* @strcpy(i8* %allocated_2, i8* %Temp_1)
%Temp_0 = call i8* @strcat(i8* %new_2, i8* %Temp_6)
  ret i8* %Temp_0
}
define i8* @that(i8*)
 { 
  %long = alloca i8*, align 8
  store i8* %0, i8** %long, align 8
  %str_4 = alloca i8*
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @STR.That, i32 0, i32 0), i8** %str_4, align 8
  %Temp_8 = load i8*, i8** %str_4, align 8
  %Temp_9 = load i8*, i8** %long, align 8
%oprnd1_size_3 = call i32 @strlen(i8* %Temp_8)
%oprnd2_size_3 = call i32 @strlen(i8* %Temp_9)
%new_size_3 = add nsw i32 %oprnd1_size_3, %oprnd2_size_3
%allocated_i32_3 = call i32* @malloc(i32 %new_size_3)
%allocated_3 = bitcast i32* %allocated_i32_3 to i8*
%new_3 = call i8* @strcpy(i8* %allocated_3, i8* %Temp_8)
%Temp_7 = call i8* @strcat(i8* %new_3, i8* %Temp_9)
  ret i8* %Temp_7
}
define i8* @be()
 { 
  %local_0 = alloca i8*, align 8
  %str_5 = alloca i8*
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @STR.Be, i32 0, i32 0), i8** %str_5, align 8
  %Temp_10 = load i8*, i8** %str_5, align 8
  store i8* %Temp_10, i8** %local_0, align 8
  %Temp_11 = load i8*, i8** %local_0, align 8
  ret i8* %Temp_11
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_1 = alloca i8*, align 8
  %local_0 = alloca i8*, align 8
  %local_2 = alloca i8*, align 8
  call void @init_globals()
  %str_6 = alloca i8*
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @STR.Why, i32 0, i32 0), i8** %str_6, align 8
  %Temp_12 = load i8*, i8** %str_6, align 8
  store i8* %Temp_12, i8** %local_0, align 8
  %str_7 = alloca i8*
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @STR.MIPS, i32 0, i32 0), i8** %str_7, align 8
  %Temp_13 = load i8*, i8** %str_7, align 8
  store i8* %Temp_13, i8** %local_1, align 8
  %str_8 = alloca i8*
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @STR.Must, i32 0, i32 0), i8** %str_8, align 8
  %Temp_14 = load i8*, i8** %str_8, align 8
  store i8* %Temp_14, i8** %local_2, align 8
  %Temp_20 = load i8*, i8** %local_0, align 8
  %Temp_21 = load i8*, i8** %local_1, align 8
%oprnd1_size_4 = call i32 @strlen(i8* %Temp_20)
%oprnd2_size_4 = call i32 @strlen(i8* %Temp_21)
%new_size_4 = add nsw i32 %oprnd1_size_4, %oprnd2_size_4
%allocated_i32_4 = call i32* @malloc(i32 %new_size_4)
%allocated_4 = bitcast i32* %allocated_i32_4 to i8*
%new_4 = call i8* @strcpy(i8* %allocated_4, i8* %Temp_20)
%Temp_19 = call i8* @strcat(i8* %new_4, i8* %Temp_21)
%Temp_22 =call i8* @code()
%oprnd1_size_5 = call i32 @strlen(i8* %Temp_19)
%oprnd2_size_5 = call i32 @strlen(i8* %Temp_22)
%new_size_5 = add nsw i32 %oprnd1_size_5, %oprnd2_size_5
%allocated_i32_5 = call i32* @malloc(i32 %new_size_5)
%allocated_5 = bitcast i32* %allocated_i32_5 to i8*
%new_5 = call i8* @strcpy(i8* %allocated_5, i8* %Temp_19)
%Temp_18 = call i8* @strcat(i8* %new_5, i8* %Temp_22)
  %Temp_23 = load i8*, i8** %local_2, align 8
%oprnd1_size_6 = call i32 @strlen(i8* %Temp_18)
%oprnd2_size_6 = call i32 @strlen(i8* %Temp_23)
%new_size_6 = add nsw i32 %oprnd1_size_6, %oprnd2_size_6
%allocated_i32_6 = call i32* @malloc(i32 %new_size_6)
%allocated_6 = bitcast i32* %allocated_i32_6 to i8*
%new_6 = call i8* @strcpy(i8* %allocated_6, i8* %Temp_18)
%Temp_17 = call i8* @strcat(i8* %new_6, i8* %Temp_23)
%Temp_24 =call i8* @be()
%oprnd1_size_7 = call i32 @strlen(i8* %Temp_17)
%oprnd2_size_7 = call i32 @strlen(i8* %Temp_24)
%new_size_7 = add nsw i32 %oprnd1_size_7, %oprnd2_size_7
%allocated_i32_7 = call i32* @malloc(i32 %new_size_7)
%allocated_7 = bitcast i32* %allocated_i32_7 to i8*
%new_7 = call i8* @strcpy(i8* %allocated_7, i8* %Temp_17)
%Temp_16 = call i8* @strcat(i8* %new_7, i8* %Temp_24)
  %str_9 = alloca i8*
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @STR.Long, i32 0, i32 0), i8** %str_9, align 8
  %Temp_25 = load i8*, i8** %str_9, align 8
%Temp_26 =call i8* @that(i8* %Temp_25 )
%oprnd1_size_8 = call i32 @strlen(i8* %Temp_16)
%oprnd2_size_8 = call i32 @strlen(i8* %Temp_26)
%new_size_8 = add nsw i32 %oprnd1_size_8, %oprnd2_size_8
%allocated_i32_8 = call i32* @malloc(i32 %new_size_8)
%allocated_8 = bitcast i32* %allocated_i32_8 to i8*
%new_8 = call i8* @strcpy(i8* %allocated_8, i8* %Temp_16)
%Temp_15 = call i8* @strcat(i8* %new_8, i8* %Temp_26)
  call void @PrintString(i8* %Temp_15 )
call void @exit(i32 0)
  ret void
}
