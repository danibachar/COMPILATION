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
  %local_3 = alloca i32**, align 8
  %local_2 = alloca i8**, align 8
  %local_0 = alloca i32*, align 8
  %local_1 = alloca i8**, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 3
  %Temp_2 = add nsw i32 %Temp_1,1
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 8
  %Temp_4 = mul nsw i32 %Temp_2, %Temp_3
  %Temp_5 = call i32* @malloc(i32 %Temp_4)
  %Temp_0 = bitcast i32* %Temp_5 to i32*
  %Temp_6 = getelementptr inbounds i32, i32* %Temp_5, i32 0
;store TYPES.TYPE_INT@7530d0a dst src;
  store i32 %Temp_1, i32* %Temp_6, align 4
  store i32* %Temp_0, i32** %local_0, align 8
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_2, 3
  %Temp_9 = add nsw i32 %Temp_8,1
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_3, 8
  %Temp_11 = mul nsw i32 %Temp_9, %Temp_10
  %Temp_12 = call i32* @malloc(i32 %Temp_11)
  %Temp_7 = bitcast i32* %Temp_12 to i8**
  %Temp_13 = getelementptr inbounds i32, i32* %Temp_12, i32 0
;store TYPES.TYPE_INT@7530d0a dst src;
  store i32 %Temp_8, i32* %Temp_13, align 4
  store i8** %Temp_7, i8*** %local_1, align 8
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_4, 3
  %Temp_16 = add nsw i32 %Temp_15,1
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_5, 8
  %Temp_18 = mul nsw i32 %Temp_16, %Temp_17
  %Temp_19 = call i32* @malloc(i32 %Temp_18)
  %Temp_14 = bitcast i32* %Temp_19 to i8**
  %Temp_20 = getelementptr inbounds i32, i32* %Temp_19, i32 0
;store TYPES.TYPE_INT@7530d0a dst src;
  store i32 %Temp_15, i32* %Temp_20, align 4
  store i8** %Temp_14, i8*** %local_2, align 8
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_6, 3
  %Temp_23 = add nsw i32 %Temp_22,1
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_7, 8
  %Temp_25 = mul nsw i32 %Temp_23, %Temp_24
  %Temp_26 = call i32* @malloc(i32 %Temp_25)
  %Temp_21 = bitcast i32* %Temp_26 to i32**
  %Temp_27 = getelementptr inbounds i32, i32* %Temp_26, i32 0
;store TYPES.TYPE_INT@7530d0a dst src;
  store i32 %Temp_22, i32* %Temp_27, align 4
  store i32** %Temp_21, i32*** %local_3, align 8
call void @exit(i32 0)
  ret void
}
