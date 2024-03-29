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

@STR.Abraham = constant [8 x i8] c"Abraham\00", align 1
@STR.Issac = constant [6 x i8] c"Issac\00", align 1
define void @foo(i8*)
 { 
  %f = alloca i8*, align 8
  store i8* %0, i8** %f, align 8
  %Temp_0 = load i8*, i8** %f, align 8
%Temp_null_0 = bitcast i8* %Temp_0 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 12
;getlement temp temp temp;
  %Temp_2 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_1
  %Temp_3 = bitcast i8* %Temp_2 to i8**
  %Temp_5 = load i8*, i8** %f, align 8
%Temp_null_1 = bitcast i8* %Temp_5 to i32*
%equal_null_1 = icmp eq i32* %Temp_null_1, null
br i1 %equal_null_1, label %null_deref_1, label %continue_1
null_deref_1:
call void @InvalidPointer()
br label %continue_1
continue_1:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_1, 12
;getlement temp temp temp;
  %Temp_7 = getelementptr inbounds i8, i8* %Temp_5, i32 %Temp_6
  %Temp_8 = bitcast i8* %Temp_7 to i8**
  %Temp_9 = load i8*, i8** %f, align 8
%Temp_null_2 = bitcast i8* %Temp_9 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_2, 0
;getlement temp temp temp;
  %Temp_11 = getelementptr inbounds i8, i8* %Temp_9, i32 %Temp_10
  %Temp_12 = bitcast i8* %Temp_11 to i8**
;load temp temp;
%Temp_init_ptr_3 = bitcast i8** %Temp_12 to i32*
%init_state_3 = load i32, i32* %Temp_init_ptr_3,align 4
%is_init_3 = icmp eq i32  %init_state_3, 0
br i1 %is_init_3 , label %error_init_3, label %good_init_3
error_init_3:
call void @InvalidPointer()
br label %good_init_3
good_init_3:
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i8**
  %Temp_13 = load i8*, i8** %Temp_actual_3 , align 8
;load temp temp;
%Temp_init_ptr_4 = bitcast i8** %Temp_8 to i32*
%init_state_4 = load i32, i32* %Temp_init_ptr_4,align 4
%is_init_4 = icmp eq i32  %init_state_4, 0
br i1 %is_init_4 , label %error_init_4, label %good_init_4
error_init_4:
call void @InvalidPointer()
br label %good_init_4
good_init_4:
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i8**
  %Temp_14 = load i8*, i8** %Temp_actual_4 , align 8
%oprnd1_size_0 = call i32 @strlen(i8* %Temp_14)
%oprnd2_size_0 = call i32 @strlen(i8* %Temp_13)
%new_size_0 = add nsw i32 %oprnd1_size_0, %oprnd2_size_0
%allocated_i32_0 = call i32* @malloc(i32 %new_size_0)
%allocated_0 = bitcast i32* %allocated_i32_0 to i8*
%new_0 = call i8* @strcpy(i8* %allocated_0, i8* %Temp_14)
%Temp_4 = call i8* @strcat(i8* %new_0, i8* %Temp_13)
;store TYPES.TYPE_STRING@5197848c dst src;
%Temp_init_ptr_5 = bitcast i8** %Temp_3 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i8**
  store i8* %Temp_4, i8** %Temp_actual_5, align 8
  ret void
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8*, align 8
  call void @init_globals()
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_3, 24
  %Temp_17 = call i32* @malloc(i32 %Temp_16)
  %Temp_15 = bitcast i32* %Temp_17 to i8*
  store i8* %Temp_15, i8** %local_0, align 8
  %Temp_18 = load i8*, i8** %local_0, align 8
%Temp_null_6 = bitcast i8* %Temp_18 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_4, 12
;getlement temp temp temp;
  %Temp_20 = getelementptr inbounds i8, i8* %Temp_18, i32 %Temp_19
  %Temp_21 = bitcast i8* %Temp_20 to i8**
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @STR.Abraham, i32 0, i32 0), i8** %str_0, align 8
  %Temp_22 = load i8*, i8** %str_0, align 8
;store TYPES.TYPE_STRING@5197848c dst src;
%Temp_init_ptr_7 = bitcast i8** %Temp_21 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i8**
  store i8* %Temp_22, i8** %Temp_actual_7, align 8
  %Temp_23 = load i8*, i8** %local_0, align 8
%Temp_null_8 = bitcast i8* %Temp_23 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_5, 0
;getlement temp temp temp;
  %Temp_25 = getelementptr inbounds i8, i8* %Temp_23, i32 %Temp_24
  %Temp_26 = bitcast i8* %Temp_25 to i8**
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @STR.Issac, i32 0, i32 0), i8** %str_1, align 8
  %Temp_27 = load i8*, i8** %str_1, align 8
;store TYPES.TYPE_STRING@5197848c dst src;
%Temp_init_ptr_9 = bitcast i8** %Temp_26 to i32*
store i32 1, i32* %Temp_init_ptr_9,align 4
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i8**
  store i8* %Temp_27, i8** %Temp_actual_9, align 8
  %Temp_28 = load i8*, i8** %local_0, align 8
  call void @foo(i8* %Temp_28 )
  %Temp_29 = load i8*, i8** %local_0, align 8
%Temp_null_10 = bitcast i8* %Temp_29 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_30 = add nsw i32 %zero_6, 12
;getlement temp temp temp;
  %Temp_31 = getelementptr inbounds i8, i8* %Temp_29, i32 %Temp_30
  %Temp_32 = bitcast i8* %Temp_31 to i8**
;load temp temp;
%Temp_init_ptr_11 = bitcast i8** %Temp_32 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i8**
  %Temp_33 = load i8*, i8** %Temp_actual_11 , align 8
  call void @PrintString(i8* %Temp_33 )
call void @exit(i32 0)
  ret void
}
