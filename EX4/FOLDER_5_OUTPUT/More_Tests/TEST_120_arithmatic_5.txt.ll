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
  %local_0 = alloca i32*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_0, 256
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 256
  %Temp_1 = mul nsw i32 %Temp_2, %Temp_3
%Temp_4 = call i32 @CheckOverflow(i32 %Temp_1)
  %Temp_5 = add nsw i32 %Temp_4,1
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_2, 8
  %Temp_7 = mul nsw i32 %Temp_5, %Temp_6
  %Temp_8 = call i32* @malloc(i32 %Temp_7)
  %Temp_0 = bitcast i32* %Temp_8 to i32*
  %Temp_9 = getelementptr inbounds i32, i32* %Temp_8, i32 0
;store TYPES.TYPE_INT@254989ff dst src;
  store i32 %Temp_4, i32* %Temp_9, align 4
  store i32* %Temp_0, i32** %local_0, align 8
  %Temp_10 = load i32*, i32** %local_0, align 8
%Temp_null_0 = bitcast i32* %Temp_10 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_3, 256
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_4, 128
  %Temp_12 = mul nsw i32 %Temp_13, %Temp_14
%Temp_15 = call i32 @CheckOverflow(i32 %Temp_12)
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_5, 1
  %Temp_11 = sub nsw i32 %Temp_15, %Temp_16
%Temp_17 = call i32 @CheckOverflow(i32 %Temp_11)
%Temp_i32_1 = bitcast i32* %Temp_10 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_17, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_17, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_18 = add nsw i32 %Temp_17,1
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i32, i32* %Temp_10, i32 %Temp_18
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_6, 777
;store TYPES.TYPE_INT@254989ff dst src;
  store i32 %Temp_20, i32* %Temp_19, align 4
  %Temp_21 = load i32*, i32** %local_0, align 8
%Temp_null_2 = bitcast i32* %Temp_21 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_7, 256
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_8, 128
  %Temp_23 = mul nsw i32 %Temp_24, %Temp_25
%Temp_26 = call i32 @CheckOverflow(i32 %Temp_23)
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_9, 1
  %Temp_22 = sub nsw i32 %Temp_26, %Temp_27
%Temp_28 = call i32 @CheckOverflow(i32 %Temp_22)
%Temp_i32_3 = bitcast i32* %Temp_21 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_28, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_28, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_29 = add nsw i32 %Temp_28,1
;getlement temp temp temp;
  %Temp_30 = getelementptr inbounds i32, i32* %Temp_21, i32 %Temp_29
;load temp temp;
  %Temp_31 = load i32, i32* %Temp_30, align 4
  call void @PrintInt(i32 %Temp_31 )
  %Temp_32 = load i32*, i32** %local_0, align 8
%Temp_null_4 = bitcast i32* %Temp_32 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_10, 256
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_35 = add nsw i32 %zero_11, 128
  %Temp_33 = mul nsw i32 %Temp_34, %Temp_35
%Temp_36 = call i32 @CheckOverflow(i32 %Temp_33)
%Temp_i32_5 = bitcast i32* %Temp_32 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_36, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_36, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_37 = add nsw i32 %Temp_36,1
;getlement temp temp temp;
  %Temp_38 = getelementptr inbounds i32, i32* %Temp_32, i32 %Temp_37
;load temp temp;
  %Temp_39 = load i32, i32* %Temp_38, align 4
  call void @PrintInt(i32 %Temp_39 )
call void @exit(i32 0)
  ret void
}
