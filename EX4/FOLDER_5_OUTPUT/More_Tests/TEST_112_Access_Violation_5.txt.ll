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
  %local_1 = alloca i32*, align 8
  %local_0 = alloca i32*, align 8
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
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_1, i32* %Temp_6, align 4
  store i32* %Temp_0, i32** %local_0, align 8
  %Temp_7 = load i32*, i32** %local_0, align 8
  store i32* %Temp_7, i32** %local_1, align 8
  %Temp_8 = load i32*, i32** %local_0, align 8
%Temp_null_0 = bitcast i32* %Temp_8 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_2, 0
%Temp_i32_1 = bitcast i32* %Temp_8 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_9, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_9, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_10 = add nsw i32 %Temp_9,1
;getlement temp temp temp;
  %Temp_11 = getelementptr inbounds i32, i32* %Temp_8, i32 %Temp_10
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_3, 5
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_12, i32* %Temp_11, align 4
  %Temp_13 = load i32*, i32** %local_0, align 8
%Temp_null_2 = bitcast i32* %Temp_13 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_4, 1
%Temp_i32_3 = bitcast i32* %Temp_13 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_14, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_14, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_15 = add nsw i32 %Temp_14,1
;getlement temp temp temp;
  %Temp_16 = getelementptr inbounds i32, i32* %Temp_13, i32 %Temp_15
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_5, 25
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_17, i32* %Temp_16, align 4
  %Temp_18 = load i32*, i32** %local_0, align 8
%Temp_null_4 = bitcast i32* %Temp_18 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_6, 2
%Temp_i32_5 = bitcast i32* %Temp_18 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_19, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_19, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_20 = add nsw i32 %Temp_19,1
;getlement temp temp temp;
  %Temp_21 = getelementptr inbounds i32, i32* %Temp_18, i32 %Temp_20
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_7, 125
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_22, i32* %Temp_21, align 4
  %Temp_23 = load i32*, i32** %local_1, align 8
%Temp_null_6 = bitcast i32* %Temp_23 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_8, 0
%Temp_i32_7 = bitcast i32* %Temp_23 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_24, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_24, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_25 = add nsw i32 %Temp_24,1
;getlement temp temp temp;
  %Temp_26 = getelementptr inbounds i32, i32* %Temp_23, i32 %Temp_25
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_9, 2
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_27, i32* %Temp_26, align 4
  %Temp_28 = load i32*, i32** %local_1, align 8
%Temp_null_8 = bitcast i32* %Temp_28 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_10, 1
%Temp_i32_9 = bitcast i32* %Temp_28 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_29, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_29, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_30 = add nsw i32 %Temp_29,1
;getlement temp temp temp;
  %Temp_31 = getelementptr inbounds i32, i32* %Temp_28, i32 %Temp_30
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_11, 4
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_32, i32* %Temp_31, align 4
  %Temp_33 = load i32*, i32** %local_1, align 8
%Temp_null_10 = bitcast i32* %Temp_33 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_12, 3
%Temp_i32_11 = bitcast i32* %Temp_33 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_34, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_34, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_35 = add nsw i32 %Temp_34,1
;getlement temp temp temp;
  %Temp_36 = getelementptr inbounds i32, i32* %Temp_33, i32 %Temp_35
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_13, 8
;store TYPES.TYPE_INT@4783da3f dst src;
  store i32 %Temp_37, i32* %Temp_36, align 4
  %Temp_38 = load i32*, i32** %local_0, align 8
%Temp_null_12 = bitcast i32* %Temp_38 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_14, 0
%Temp_i32_13 = bitcast i32* %Temp_38 to i32*
%Temp_size_ptr_13 = getelementptr inbounds i32, i32* %Temp_i32_13, i32 0
%arr_size_13 = load i32, i32* %Temp_size_ptr_13,align 4
%sub_negative_13 = icmp slt i32  %Temp_39, 0
br i1 %sub_negative_13 , label %error_idx_13, label %positive_idx_13
positive_idx_13:
%out_of_bounds_13 = icmp sge i32 %Temp_39, %arr_size_13
br i1 %out_of_bounds_13 , label %error_idx_13, label %continue_idx_13
error_idx_13:
call void @AccessViolation()
br label %continue_idx_13
continue_idx_13:
  %Temp_40 = add nsw i32 %Temp_39,1
;getlement temp temp temp;
  %Temp_41 = getelementptr inbounds i32, i32* %Temp_38, i32 %Temp_40
;load temp temp;
  %Temp_42 = load i32, i32* %Temp_41, align 4
  call void @PrintInt(i32 %Temp_42 )
  %Temp_43 = load i32*, i32** %local_0, align 8
%Temp_null_14 = bitcast i32* %Temp_43 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_15, 1
%Temp_i32_15 = bitcast i32* %Temp_43 to i32*
%Temp_size_ptr_15 = getelementptr inbounds i32, i32* %Temp_i32_15, i32 0
%arr_size_15 = load i32, i32* %Temp_size_ptr_15,align 4
%sub_negative_15 = icmp slt i32  %Temp_44, 0
br i1 %sub_negative_15 , label %error_idx_15, label %positive_idx_15
positive_idx_15:
%out_of_bounds_15 = icmp sge i32 %Temp_44, %arr_size_15
br i1 %out_of_bounds_15 , label %error_idx_15, label %continue_idx_15
error_idx_15:
call void @AccessViolation()
br label %continue_idx_15
continue_idx_15:
  %Temp_45 = add nsw i32 %Temp_44,1
;getlement temp temp temp;
  %Temp_46 = getelementptr inbounds i32, i32* %Temp_43, i32 %Temp_45
;load temp temp;
  %Temp_47 = load i32, i32* %Temp_46, align 4
  call void @PrintInt(i32 %Temp_47 )
  %Temp_48 = load i32*, i32** %local_0, align 8
%Temp_null_16 = bitcast i32* %Temp_48 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_49 = add nsw i32 %zero_16, 2
%Temp_i32_17 = bitcast i32* %Temp_48 to i32*
%Temp_size_ptr_17 = getelementptr inbounds i32, i32* %Temp_i32_17, i32 0
%arr_size_17 = load i32, i32* %Temp_size_ptr_17,align 4
%sub_negative_17 = icmp slt i32  %Temp_49, 0
br i1 %sub_negative_17 , label %error_idx_17, label %positive_idx_17
positive_idx_17:
%out_of_bounds_17 = icmp sge i32 %Temp_49, %arr_size_17
br i1 %out_of_bounds_17 , label %error_idx_17, label %continue_idx_17
error_idx_17:
call void @AccessViolation()
br label %continue_idx_17
continue_idx_17:
  %Temp_50 = add nsw i32 %Temp_49,1
;getlement temp temp temp;
  %Temp_51 = getelementptr inbounds i32, i32* %Temp_48, i32 %Temp_50
;load temp temp;
  %Temp_52 = load i32, i32* %Temp_51, align 4
  call void @PrintInt(i32 %Temp_52 )
call void @exit(i32 0)
  ret void
}
