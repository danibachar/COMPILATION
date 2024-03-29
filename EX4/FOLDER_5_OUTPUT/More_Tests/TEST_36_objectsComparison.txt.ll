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
  %local_2 = alloca i8*, align 8
  %local_1 = alloca i8*, align 8
  %local_0 = alloca i8*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 8
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  store i8* %Temp_0, i8** %local_0, align 8
  %Temp_3 = load i8*, i8** %local_0, align 8
  store i8* %Temp_3, i8** %local_1, align 8
  %Temp_4 = load i8*, i8** %local_1, align 8
%Temp_null_0 = bitcast i8* %Temp_4 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_1, 0
;getlement temp temp temp;
  %Temp_6 = getelementptr inbounds i8, i8* %Temp_4, i32 %Temp_5
  %Temp_7 = bitcast i8* %Temp_6 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_2, 100
;store TYPES.TYPE_INT@5197848c dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_7 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_8, i32* %Temp_actual_1, align 4
  %Temp_9 = load i8*, i8** %local_0, align 8
%Temp_null_2 = bitcast i8* %Temp_9 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_3, 0
;getlement temp temp temp;
  %Temp_11 = getelementptr inbounds i8, i8* %Temp_9, i32 %Temp_10
  %Temp_12 = bitcast i8* %Temp_11 to i32*
;load temp temp;
%Temp_init_ptr_3 = bitcast i32* %Temp_12 to i32*
%init_state_3 = load i32, i32* %Temp_init_ptr_3,align 4
%is_init_3 = icmp eq i32  %init_state_3, 0
br i1 %is_init_3 , label %error_init_3, label %good_init_3
error_init_3:
call void @InvalidPointer()
br label %good_init_3
good_init_3:
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  %Temp_13 = load i32, i32* %Temp_actual_3 , align 4
  call void @PrintInt(i32 %Temp_13 )
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_15 = load i8*, i8** %local_0, align 8
  %Temp_16 = load i8*, i8** %local_1, align 8
  %Temp_14 = icmp eq i8* %Temp_15, %Temp_16
  %Temp_17 = zext i1 %Temp_14 to i32
  %equal_zero_4 = icmp eq i32 %Temp_17, 0
  br i1 %equal_zero_4, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_5, 102
  call void @PrintInt(i32 %Temp_18 )
  br label %Label_2_if.exit

Label_2_if.exit:

  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_6, 8
  %Temp_21 = call i32* @malloc(i32 %Temp_20)
  %Temp_19 = bitcast i32* %Temp_21 to i8*
  store i8* %Temp_19, i8** %local_2, align 8
  %Temp_22 = load i8*, i8** %local_2, align 8
%Temp_null_4 = bitcast i8* %Temp_22 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_7, 0
;getlement temp temp temp;
  %Temp_24 = getelementptr inbounds i8, i8* %Temp_22, i32 %Temp_23
  %Temp_25 = bitcast i8* %Temp_24 to i32*
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_8, 100
;store TYPES.TYPE_INT@5197848c dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_25 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_26, i32* %Temp_actual_5, align 4
  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_28 = load i8*, i8** %local_0, align 8
  %Temp_29 = load i8*, i8** %local_2, align 8
  %Temp_27 = icmp eq i8* %Temp_28, %Temp_29
  %Temp_30 = zext i1 %Temp_27 to i32
  %equal_zero_9 = icmp eq i32 %Temp_30, 0
  br i1 %equal_zero_9, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_10, 104
  call void @PrintInt(i32 %Temp_31 )
  br label %Label_5_if.exit

Label_5_if.exit:

call void @exit(i32 0)
  ret void
}
