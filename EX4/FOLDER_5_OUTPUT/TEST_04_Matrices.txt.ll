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

define i32 @trace3x3(i32**)
 { 
  %A = alloca i32**, align 8
  store i32** %0, i32*** %A, align 8
  %Temp_2 = load i32**, i32*** %A, align 8
%Temp_null_0 = bitcast i32** %Temp_2 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_0, 0
%Temp_i32_1 = bitcast i32** %Temp_2 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_3, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_3, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_4 = add nsw i32 %Temp_3,1
;getlement temp temp temp;
  %Temp_5 = getelementptr inbounds i32*, i32** %Temp_2, i32 %Temp_4
;load temp temp;
  %Temp_6 = load i32*, i32** %Temp_5, align 8
%Temp_null_2 = bitcast i32* %Temp_6 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_1, 0
%Temp_i32_3 = bitcast i32* %Temp_6 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_7, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_7, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_8 = add nsw i32 %Temp_7,1
;getlement temp temp temp;
  %Temp_9 = getelementptr inbounds i32, i32* %Temp_6, i32 %Temp_8
  %Temp_10 = load i32**, i32*** %A, align 8
%Temp_null_4 = bitcast i32** %Temp_10 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_2, 1
%Temp_i32_5 = bitcast i32** %Temp_10 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_11, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_11, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_12 = add nsw i32 %Temp_11,1
;getlement temp temp temp;
  %Temp_13 = getelementptr inbounds i32*, i32** %Temp_10, i32 %Temp_12
;load temp temp;
  %Temp_14 = load i32*, i32** %Temp_13, align 8
%Temp_null_6 = bitcast i32* %Temp_14 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_3, 1
%Temp_i32_7 = bitcast i32* %Temp_14 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_15, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_15, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_16 = add nsw i32 %Temp_15,1
;getlement temp temp temp;
  %Temp_17 = getelementptr inbounds i32, i32* %Temp_14, i32 %Temp_16
;load temp temp;
  %Temp_18 = load i32, i32* %Temp_17, align 4
;load temp temp;
  %Temp_19 = load i32, i32* %Temp_9, align 4
  %Temp_1 = add nsw i32 %Temp_19, %Temp_18
%Temp_20 = call i32 @CheckOverflow(i32 %Temp_1)
  %Temp_21 = load i32**, i32*** %A, align 8
%Temp_null_8 = bitcast i32** %Temp_21 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_4, 2
%Temp_i32_9 = bitcast i32** %Temp_21 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_22, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_22, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_23 = add nsw i32 %Temp_22,1
;getlement temp temp temp;
  %Temp_24 = getelementptr inbounds i32*, i32** %Temp_21, i32 %Temp_23
;load temp temp;
  %Temp_25 = load i32*, i32** %Temp_24, align 8
%Temp_null_10 = bitcast i32* %Temp_25 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_5, 2
%Temp_i32_11 = bitcast i32* %Temp_25 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_26, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_26, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_27 = add nsw i32 %Temp_26,1
;getlement temp temp temp;
  %Temp_28 = getelementptr inbounds i32, i32* %Temp_25, i32 %Temp_27
;load temp temp;
  %Temp_29 = load i32, i32* %Temp_28, align 4
  %Temp_0 = add nsw i32 %Temp_20, %Temp_29
%Temp_30 = call i32 @CheckOverflow(i32 %Temp_0)
  ret i32 %Temp_30
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_2 = alloca i32*, align 8
  %local_0 = alloca i32*, align 8
  %local_3 = alloca i32**, align 8
  %local_1 = alloca i32*, align 8
  call void @init_globals()
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_6, 3
  %Temp_33 = add nsw i32 %Temp_32,1
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_7, 8
  %Temp_35 = mul nsw i32 %Temp_33, %Temp_34
  %Temp_36 = call i32* @malloc(i32 %Temp_35)
  %Temp_31 = bitcast i32* %Temp_36 to i32*
  %Temp_37 = getelementptr inbounds i32, i32* %Temp_36, i32 0
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_32, i32* %Temp_37, align 4
  store i32* %Temp_31, i32** %local_0, align 8
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_8, 3
  %Temp_40 = add nsw i32 %Temp_39,1
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_9, 8
  %Temp_42 = mul nsw i32 %Temp_40, %Temp_41
  %Temp_43 = call i32* @malloc(i32 %Temp_42)
  %Temp_38 = bitcast i32* %Temp_43 to i32*
  %Temp_44 = getelementptr inbounds i32, i32* %Temp_43, i32 0
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_39, i32* %Temp_44, align 4
  store i32* %Temp_38, i32** %local_1, align 8
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_10, 3
  %Temp_47 = add nsw i32 %Temp_46,1
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_48 = add nsw i32 %zero_11, 8
  %Temp_49 = mul nsw i32 %Temp_47, %Temp_48
  %Temp_50 = call i32* @malloc(i32 %Temp_49)
  %Temp_45 = bitcast i32* %Temp_50 to i32*
  %Temp_51 = getelementptr inbounds i32, i32* %Temp_50, i32 0
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_46, i32* %Temp_51, align 4
  store i32* %Temp_45, i32** %local_2, align 8
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_53 = add nsw i32 %zero_12, 3
  %Temp_54 = add nsw i32 %Temp_53,1
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_55 = add nsw i32 %zero_13, 8
  %Temp_56 = mul nsw i32 %Temp_54, %Temp_55
  %Temp_57 = call i32* @malloc(i32 %Temp_56)
  %Temp_52 = bitcast i32* %Temp_57 to i32**
  %Temp_58 = getelementptr inbounds i32, i32* %Temp_57, i32 0
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_53, i32* %Temp_58, align 4
  store i32** %Temp_52, i32*** %local_3, align 8
  %Temp_59 = load i32**, i32*** %local_3, align 8
%Temp_null_12 = bitcast i32** %Temp_59 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_60 = add nsw i32 %zero_14, 0
%Temp_i32_13 = bitcast i32** %Temp_59 to i32*
%Temp_size_ptr_13 = getelementptr inbounds i32, i32* %Temp_i32_13, i32 0
%arr_size_13 = load i32, i32* %Temp_size_ptr_13,align 4
%sub_negative_13 = icmp slt i32  %Temp_60, 0
br i1 %sub_negative_13 , label %error_idx_13, label %positive_idx_13
positive_idx_13:
%out_of_bounds_13 = icmp sge i32 %Temp_60, %arr_size_13
br i1 %out_of_bounds_13 , label %error_idx_13, label %continue_idx_13
error_idx_13:
call void @AccessViolation()
br label %continue_idx_13
continue_idx_13:
  %Temp_61 = add nsw i32 %Temp_60,1
;getlement temp temp temp;
  %Temp_62 = getelementptr inbounds i32*, i32** %Temp_59, i32 %Temp_61
  %Temp_63 = load i32*, i32** %local_0, align 8
;store TYPES.TYPE_ARRAY@31cefde0 dst src;
  store i32* %Temp_63, i32** %Temp_62, align 8
  %Temp_64 = load i32**, i32*** %local_3, align 8
%Temp_null_14 = bitcast i32** %Temp_64 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_65 = add nsw i32 %zero_15, 1
%Temp_i32_15 = bitcast i32** %Temp_64 to i32*
%Temp_size_ptr_15 = getelementptr inbounds i32, i32* %Temp_i32_15, i32 0
%arr_size_15 = load i32, i32* %Temp_size_ptr_15,align 4
%sub_negative_15 = icmp slt i32  %Temp_65, 0
br i1 %sub_negative_15 , label %error_idx_15, label %positive_idx_15
positive_idx_15:
%out_of_bounds_15 = icmp sge i32 %Temp_65, %arr_size_15
br i1 %out_of_bounds_15 , label %error_idx_15, label %continue_idx_15
error_idx_15:
call void @AccessViolation()
br label %continue_idx_15
continue_idx_15:
  %Temp_66 = add nsw i32 %Temp_65,1
;getlement temp temp temp;
  %Temp_67 = getelementptr inbounds i32*, i32** %Temp_64, i32 %Temp_66
  %Temp_68 = load i32*, i32** %local_1, align 8
;store TYPES.TYPE_ARRAY@31cefde0 dst src;
  store i32* %Temp_68, i32** %Temp_67, align 8
  %Temp_69 = load i32**, i32*** %local_3, align 8
%Temp_null_16 = bitcast i32** %Temp_69 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_70 = add nsw i32 %zero_16, 2
%Temp_i32_17 = bitcast i32** %Temp_69 to i32*
%Temp_size_ptr_17 = getelementptr inbounds i32, i32* %Temp_i32_17, i32 0
%arr_size_17 = load i32, i32* %Temp_size_ptr_17,align 4
%sub_negative_17 = icmp slt i32  %Temp_70, 0
br i1 %sub_negative_17 , label %error_idx_17, label %positive_idx_17
positive_idx_17:
%out_of_bounds_17 = icmp sge i32 %Temp_70, %arr_size_17
br i1 %out_of_bounds_17 , label %error_idx_17, label %continue_idx_17
error_idx_17:
call void @AccessViolation()
br label %continue_idx_17
continue_idx_17:
  %Temp_71 = add nsw i32 %Temp_70,1
;getlement temp temp temp;
  %Temp_72 = getelementptr inbounds i32*, i32** %Temp_69, i32 %Temp_71
  %Temp_73 = load i32*, i32** %local_2, align 8
;store TYPES.TYPE_ARRAY@31cefde0 dst src;
  store i32* %Temp_73, i32** %Temp_72, align 8
  %Temp_74 = load i32**, i32*** %local_3, align 8
%Temp_null_18 = bitcast i32** %Temp_74 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_75 = add nsw i32 %zero_17, 0
%Temp_i32_19 = bitcast i32** %Temp_74 to i32*
%Temp_size_ptr_19 = getelementptr inbounds i32, i32* %Temp_i32_19, i32 0
%arr_size_19 = load i32, i32* %Temp_size_ptr_19,align 4
%sub_negative_19 = icmp slt i32  %Temp_75, 0
br i1 %sub_negative_19 , label %error_idx_19, label %positive_idx_19
positive_idx_19:
%out_of_bounds_19 = icmp sge i32 %Temp_75, %arr_size_19
br i1 %out_of_bounds_19 , label %error_idx_19, label %continue_idx_19
error_idx_19:
call void @AccessViolation()
br label %continue_idx_19
continue_idx_19:
  %Temp_76 = add nsw i32 %Temp_75,1
;getlement temp temp temp;
  %Temp_77 = getelementptr inbounds i32*, i32** %Temp_74, i32 %Temp_76
;load temp temp;
  %Temp_78 = load i32*, i32** %Temp_77, align 8
%Temp_null_20 = bitcast i32* %Temp_78 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_79 = add nsw i32 %zero_18, 0
%Temp_i32_21 = bitcast i32* %Temp_78 to i32*
%Temp_size_ptr_21 = getelementptr inbounds i32, i32* %Temp_i32_21, i32 0
%arr_size_21 = load i32, i32* %Temp_size_ptr_21,align 4
%sub_negative_21 = icmp slt i32  %Temp_79, 0
br i1 %sub_negative_21 , label %error_idx_21, label %positive_idx_21
positive_idx_21:
%out_of_bounds_21 = icmp sge i32 %Temp_79, %arr_size_21
br i1 %out_of_bounds_21 , label %error_idx_21, label %continue_idx_21
error_idx_21:
call void @AccessViolation()
br label %continue_idx_21
continue_idx_21:
  %Temp_80 = add nsw i32 %Temp_79,1
;getlement temp temp temp;
  %Temp_81 = getelementptr inbounds i32, i32* %Temp_78, i32 %Temp_80
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_82 = add nsw i32 %zero_19, 0
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_82, i32* %Temp_81, align 4
  %Temp_83 = load i32**, i32*** %local_3, align 8
%Temp_null_22 = bitcast i32** %Temp_83 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_20, 0
%Temp_i32_23 = bitcast i32** %Temp_83 to i32*
%Temp_size_ptr_23 = getelementptr inbounds i32, i32* %Temp_i32_23, i32 0
%arr_size_23 = load i32, i32* %Temp_size_ptr_23,align 4
%sub_negative_23 = icmp slt i32  %Temp_84, 0
br i1 %sub_negative_23 , label %error_idx_23, label %positive_idx_23
positive_idx_23:
%out_of_bounds_23 = icmp sge i32 %Temp_84, %arr_size_23
br i1 %out_of_bounds_23 , label %error_idx_23, label %continue_idx_23
error_idx_23:
call void @AccessViolation()
br label %continue_idx_23
continue_idx_23:
  %Temp_85 = add nsw i32 %Temp_84,1
;getlement temp temp temp;
  %Temp_86 = getelementptr inbounds i32*, i32** %Temp_83, i32 %Temp_85
;load temp temp;
  %Temp_87 = load i32*, i32** %Temp_86, align 8
%Temp_null_24 = bitcast i32* %Temp_87 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_88 = add nsw i32 %zero_21, 1
%Temp_i32_25 = bitcast i32* %Temp_87 to i32*
%Temp_size_ptr_25 = getelementptr inbounds i32, i32* %Temp_i32_25, i32 0
%arr_size_25 = load i32, i32* %Temp_size_ptr_25,align 4
%sub_negative_25 = icmp slt i32  %Temp_88, 0
br i1 %sub_negative_25 , label %error_idx_25, label %positive_idx_25
positive_idx_25:
%out_of_bounds_25 = icmp sge i32 %Temp_88, %arr_size_25
br i1 %out_of_bounds_25 , label %error_idx_25, label %continue_idx_25
error_idx_25:
call void @AccessViolation()
br label %continue_idx_25
continue_idx_25:
  %Temp_89 = add nsw i32 %Temp_88,1
;getlement temp temp temp;
  %Temp_90 = getelementptr inbounds i32, i32* %Temp_87, i32 %Temp_89
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_22, 1
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_91, i32* %Temp_90, align 4
  %Temp_92 = load i32**, i32*** %local_3, align 8
%Temp_null_26 = bitcast i32** %Temp_92 to i32*
%equal_null_26 = icmp eq i32* %Temp_null_26, null
br i1 %equal_null_26, label %null_deref_26, label %continue_26
null_deref_26:
call void @InvalidPointer()
br label %continue_26
continue_26:
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_93 = add nsw i32 %zero_23, 0
%Temp_i32_27 = bitcast i32** %Temp_92 to i32*
%Temp_size_ptr_27 = getelementptr inbounds i32, i32* %Temp_i32_27, i32 0
%arr_size_27 = load i32, i32* %Temp_size_ptr_27,align 4
%sub_negative_27 = icmp slt i32  %Temp_93, 0
br i1 %sub_negative_27 , label %error_idx_27, label %positive_idx_27
positive_idx_27:
%out_of_bounds_27 = icmp sge i32 %Temp_93, %arr_size_27
br i1 %out_of_bounds_27 , label %error_idx_27, label %continue_idx_27
error_idx_27:
call void @AccessViolation()
br label %continue_idx_27
continue_idx_27:
  %Temp_94 = add nsw i32 %Temp_93,1
;getlement temp temp temp;
  %Temp_95 = getelementptr inbounds i32*, i32** %Temp_92, i32 %Temp_94
;load temp temp;
  %Temp_96 = load i32*, i32** %Temp_95, align 8
%Temp_null_28 = bitcast i32* %Temp_96 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_97 = add nsw i32 %zero_24, 2
%Temp_i32_29 = bitcast i32* %Temp_96 to i32*
%Temp_size_ptr_29 = getelementptr inbounds i32, i32* %Temp_i32_29, i32 0
%arr_size_29 = load i32, i32* %Temp_size_ptr_29,align 4
%sub_negative_29 = icmp slt i32  %Temp_97, 0
br i1 %sub_negative_29 , label %error_idx_29, label %positive_idx_29
positive_idx_29:
%out_of_bounds_29 = icmp sge i32 %Temp_97, %arr_size_29
br i1 %out_of_bounds_29 , label %error_idx_29, label %continue_idx_29
error_idx_29:
call void @AccessViolation()
br label %continue_idx_29
continue_idx_29:
  %Temp_98 = add nsw i32 %Temp_97,1
;getlement temp temp temp;
  %Temp_99 = getelementptr inbounds i32, i32* %Temp_96, i32 %Temp_98
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_100 = add nsw i32 %zero_25, 2
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_100, i32* %Temp_99, align 4
  %Temp_101 = load i32**, i32*** %local_3, align 8
%Temp_null_30 = bitcast i32** %Temp_101 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_102 = add nsw i32 %zero_26, 1
%Temp_i32_31 = bitcast i32** %Temp_101 to i32*
%Temp_size_ptr_31 = getelementptr inbounds i32, i32* %Temp_i32_31, i32 0
%arr_size_31 = load i32, i32* %Temp_size_ptr_31,align 4
%sub_negative_31 = icmp slt i32  %Temp_102, 0
br i1 %sub_negative_31 , label %error_idx_31, label %positive_idx_31
positive_idx_31:
%out_of_bounds_31 = icmp sge i32 %Temp_102, %arr_size_31
br i1 %out_of_bounds_31 , label %error_idx_31, label %continue_idx_31
error_idx_31:
call void @AccessViolation()
br label %continue_idx_31
continue_idx_31:
  %Temp_103 = add nsw i32 %Temp_102,1
;getlement temp temp temp;
  %Temp_104 = getelementptr inbounds i32*, i32** %Temp_101, i32 %Temp_103
;load temp temp;
  %Temp_105 = load i32*, i32** %Temp_104, align 8
%Temp_null_32 = bitcast i32* %Temp_105 to i32*
%equal_null_32 = icmp eq i32* %Temp_null_32, null
br i1 %equal_null_32, label %null_deref_32, label %continue_32
null_deref_32:
call void @InvalidPointer()
br label %continue_32
continue_32:
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_106 = add nsw i32 %zero_27, 0
%Temp_i32_33 = bitcast i32* %Temp_105 to i32*
%Temp_size_ptr_33 = getelementptr inbounds i32, i32* %Temp_i32_33, i32 0
%arr_size_33 = load i32, i32* %Temp_size_ptr_33,align 4
%sub_negative_33 = icmp slt i32  %Temp_106, 0
br i1 %sub_negative_33 , label %error_idx_33, label %positive_idx_33
positive_idx_33:
%out_of_bounds_33 = icmp sge i32 %Temp_106, %arr_size_33
br i1 %out_of_bounds_33 , label %error_idx_33, label %continue_idx_33
error_idx_33:
call void @AccessViolation()
br label %continue_idx_33
continue_idx_33:
  %Temp_107 = add nsw i32 %Temp_106,1
;getlement temp temp temp;
  %Temp_108 = getelementptr inbounds i32, i32* %Temp_105, i32 %Temp_107
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_109 = add nsw i32 %zero_28, 3
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_109, i32* %Temp_108, align 4
  %Temp_110 = load i32**, i32*** %local_3, align 8
%Temp_null_34 = bitcast i32** %Temp_110 to i32*
%equal_null_34 = icmp eq i32* %Temp_null_34, null
br i1 %equal_null_34, label %null_deref_34, label %continue_34
null_deref_34:
call void @InvalidPointer()
br label %continue_34
continue_34:
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_29, 1
%Temp_i32_35 = bitcast i32** %Temp_110 to i32*
%Temp_size_ptr_35 = getelementptr inbounds i32, i32* %Temp_i32_35, i32 0
%arr_size_35 = load i32, i32* %Temp_size_ptr_35,align 4
%sub_negative_35 = icmp slt i32  %Temp_111, 0
br i1 %sub_negative_35 , label %error_idx_35, label %positive_idx_35
positive_idx_35:
%out_of_bounds_35 = icmp sge i32 %Temp_111, %arr_size_35
br i1 %out_of_bounds_35 , label %error_idx_35, label %continue_idx_35
error_idx_35:
call void @AccessViolation()
br label %continue_idx_35
continue_idx_35:
  %Temp_112 = add nsw i32 %Temp_111,1
;getlement temp temp temp;
  %Temp_113 = getelementptr inbounds i32*, i32** %Temp_110, i32 %Temp_112
;load temp temp;
  %Temp_114 = load i32*, i32** %Temp_113, align 8
%Temp_null_36 = bitcast i32* %Temp_114 to i32*
%equal_null_36 = icmp eq i32* %Temp_null_36, null
br i1 %equal_null_36, label %null_deref_36, label %continue_36
null_deref_36:
call void @InvalidPointer()
br label %continue_36
continue_36:
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_115 = add nsw i32 %zero_30, 1
%Temp_i32_37 = bitcast i32* %Temp_114 to i32*
%Temp_size_ptr_37 = getelementptr inbounds i32, i32* %Temp_i32_37, i32 0
%arr_size_37 = load i32, i32* %Temp_size_ptr_37,align 4
%sub_negative_37 = icmp slt i32  %Temp_115, 0
br i1 %sub_negative_37 , label %error_idx_37, label %positive_idx_37
positive_idx_37:
%out_of_bounds_37 = icmp sge i32 %Temp_115, %arr_size_37
br i1 %out_of_bounds_37 , label %error_idx_37, label %continue_idx_37
error_idx_37:
call void @AccessViolation()
br label %continue_idx_37
continue_idx_37:
  %Temp_116 = add nsw i32 %Temp_115,1
;getlement temp temp temp;
  %Temp_117 = getelementptr inbounds i32, i32* %Temp_114, i32 %Temp_116
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_118 = add nsw i32 %zero_31, 4
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_118, i32* %Temp_117, align 4
  %Temp_119 = load i32**, i32*** %local_3, align 8
%Temp_null_38 = bitcast i32** %Temp_119 to i32*
%equal_null_38 = icmp eq i32* %Temp_null_38, null
br i1 %equal_null_38, label %null_deref_38, label %continue_38
null_deref_38:
call void @InvalidPointer()
br label %continue_38
continue_38:
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_120 = add nsw i32 %zero_32, 1
%Temp_i32_39 = bitcast i32** %Temp_119 to i32*
%Temp_size_ptr_39 = getelementptr inbounds i32, i32* %Temp_i32_39, i32 0
%arr_size_39 = load i32, i32* %Temp_size_ptr_39,align 4
%sub_negative_39 = icmp slt i32  %Temp_120, 0
br i1 %sub_negative_39 , label %error_idx_39, label %positive_idx_39
positive_idx_39:
%out_of_bounds_39 = icmp sge i32 %Temp_120, %arr_size_39
br i1 %out_of_bounds_39 , label %error_idx_39, label %continue_idx_39
error_idx_39:
call void @AccessViolation()
br label %continue_idx_39
continue_idx_39:
  %Temp_121 = add nsw i32 %Temp_120,1
;getlement temp temp temp;
  %Temp_122 = getelementptr inbounds i32*, i32** %Temp_119, i32 %Temp_121
;load temp temp;
  %Temp_123 = load i32*, i32** %Temp_122, align 8
%Temp_null_40 = bitcast i32* %Temp_123 to i32*
%equal_null_40 = icmp eq i32* %Temp_null_40, null
br i1 %equal_null_40, label %null_deref_40, label %continue_40
null_deref_40:
call void @InvalidPointer()
br label %continue_40
continue_40:
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_124 = add nsw i32 %zero_33, 2
%Temp_i32_41 = bitcast i32* %Temp_123 to i32*
%Temp_size_ptr_41 = getelementptr inbounds i32, i32* %Temp_i32_41, i32 0
%arr_size_41 = load i32, i32* %Temp_size_ptr_41,align 4
%sub_negative_41 = icmp slt i32  %Temp_124, 0
br i1 %sub_negative_41 , label %error_idx_41, label %positive_idx_41
positive_idx_41:
%out_of_bounds_41 = icmp sge i32 %Temp_124, %arr_size_41
br i1 %out_of_bounds_41 , label %error_idx_41, label %continue_idx_41
error_idx_41:
call void @AccessViolation()
br label %continue_idx_41
continue_idx_41:
  %Temp_125 = add nsw i32 %Temp_124,1
;getlement temp temp temp;
  %Temp_126 = getelementptr inbounds i32, i32* %Temp_123, i32 %Temp_125
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_127 = add nsw i32 %zero_34, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_127, i32* %Temp_126, align 4
  %Temp_128 = load i32**, i32*** %local_3, align 8
%Temp_null_42 = bitcast i32** %Temp_128 to i32*
%equal_null_42 = icmp eq i32* %Temp_null_42, null
br i1 %equal_null_42, label %null_deref_42, label %continue_42
null_deref_42:
call void @InvalidPointer()
br label %continue_42
continue_42:
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_129 = add nsw i32 %zero_35, 2
%Temp_i32_43 = bitcast i32** %Temp_128 to i32*
%Temp_size_ptr_43 = getelementptr inbounds i32, i32* %Temp_i32_43, i32 0
%arr_size_43 = load i32, i32* %Temp_size_ptr_43,align 4
%sub_negative_43 = icmp slt i32  %Temp_129, 0
br i1 %sub_negative_43 , label %error_idx_43, label %positive_idx_43
positive_idx_43:
%out_of_bounds_43 = icmp sge i32 %Temp_129, %arr_size_43
br i1 %out_of_bounds_43 , label %error_idx_43, label %continue_idx_43
error_idx_43:
call void @AccessViolation()
br label %continue_idx_43
continue_idx_43:
  %Temp_130 = add nsw i32 %Temp_129,1
;getlement temp temp temp;
  %Temp_131 = getelementptr inbounds i32*, i32** %Temp_128, i32 %Temp_130
;load temp temp;
  %Temp_132 = load i32*, i32** %Temp_131, align 8
%Temp_null_44 = bitcast i32* %Temp_132 to i32*
%equal_null_44 = icmp eq i32* %Temp_null_44, null
br i1 %equal_null_44, label %null_deref_44, label %continue_44
null_deref_44:
call void @InvalidPointer()
br label %continue_44
continue_44:
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_133 = add nsw i32 %zero_36, 0
%Temp_i32_45 = bitcast i32* %Temp_132 to i32*
%Temp_size_ptr_45 = getelementptr inbounds i32, i32* %Temp_i32_45, i32 0
%arr_size_45 = load i32, i32* %Temp_size_ptr_45,align 4
%sub_negative_45 = icmp slt i32  %Temp_133, 0
br i1 %sub_negative_45 , label %error_idx_45, label %positive_idx_45
positive_idx_45:
%out_of_bounds_45 = icmp sge i32 %Temp_133, %arr_size_45
br i1 %out_of_bounds_45 , label %error_idx_45, label %continue_idx_45
error_idx_45:
call void @AccessViolation()
br label %continue_idx_45
continue_idx_45:
  %Temp_134 = add nsw i32 %Temp_133,1
;getlement temp temp temp;
  %Temp_135 = getelementptr inbounds i32, i32* %Temp_132, i32 %Temp_134
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_136 = add nsw i32 %zero_37, 6
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_136, i32* %Temp_135, align 4
  %Temp_137 = load i32**, i32*** %local_3, align 8
%Temp_null_46 = bitcast i32** %Temp_137 to i32*
%equal_null_46 = icmp eq i32* %Temp_null_46, null
br i1 %equal_null_46, label %null_deref_46, label %continue_46
null_deref_46:
call void @InvalidPointer()
br label %continue_46
continue_46:
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_138 = add nsw i32 %zero_38, 2
%Temp_i32_47 = bitcast i32** %Temp_137 to i32*
%Temp_size_ptr_47 = getelementptr inbounds i32, i32* %Temp_i32_47, i32 0
%arr_size_47 = load i32, i32* %Temp_size_ptr_47,align 4
%sub_negative_47 = icmp slt i32  %Temp_138, 0
br i1 %sub_negative_47 , label %error_idx_47, label %positive_idx_47
positive_idx_47:
%out_of_bounds_47 = icmp sge i32 %Temp_138, %arr_size_47
br i1 %out_of_bounds_47 , label %error_idx_47, label %continue_idx_47
error_idx_47:
call void @AccessViolation()
br label %continue_idx_47
continue_idx_47:
  %Temp_139 = add nsw i32 %Temp_138,1
;getlement temp temp temp;
  %Temp_140 = getelementptr inbounds i32*, i32** %Temp_137, i32 %Temp_139
;load temp temp;
  %Temp_141 = load i32*, i32** %Temp_140, align 8
%Temp_null_48 = bitcast i32* %Temp_141 to i32*
%equal_null_48 = icmp eq i32* %Temp_null_48, null
br i1 %equal_null_48, label %null_deref_48, label %continue_48
null_deref_48:
call void @InvalidPointer()
br label %continue_48
continue_48:
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_142 = add nsw i32 %zero_39, 1
%Temp_i32_49 = bitcast i32* %Temp_141 to i32*
%Temp_size_ptr_49 = getelementptr inbounds i32, i32* %Temp_i32_49, i32 0
%arr_size_49 = load i32, i32* %Temp_size_ptr_49,align 4
%sub_negative_49 = icmp slt i32  %Temp_142, 0
br i1 %sub_negative_49 , label %error_idx_49, label %positive_idx_49
positive_idx_49:
%out_of_bounds_49 = icmp sge i32 %Temp_142, %arr_size_49
br i1 %out_of_bounds_49 , label %error_idx_49, label %continue_idx_49
error_idx_49:
call void @AccessViolation()
br label %continue_idx_49
continue_idx_49:
  %Temp_143 = add nsw i32 %Temp_142,1
;getlement temp temp temp;
  %Temp_144 = getelementptr inbounds i32, i32* %Temp_141, i32 %Temp_143
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_145 = add nsw i32 %zero_40, 7
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_145, i32* %Temp_144, align 4
  %Temp_146 = load i32**, i32*** %local_3, align 8
%Temp_null_50 = bitcast i32** %Temp_146 to i32*
%equal_null_50 = icmp eq i32* %Temp_null_50, null
br i1 %equal_null_50, label %null_deref_50, label %continue_50
null_deref_50:
call void @InvalidPointer()
br label %continue_50
continue_50:
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_147 = add nsw i32 %zero_41, 2
%Temp_i32_51 = bitcast i32** %Temp_146 to i32*
%Temp_size_ptr_51 = getelementptr inbounds i32, i32* %Temp_i32_51, i32 0
%arr_size_51 = load i32, i32* %Temp_size_ptr_51,align 4
%sub_negative_51 = icmp slt i32  %Temp_147, 0
br i1 %sub_negative_51 , label %error_idx_51, label %positive_idx_51
positive_idx_51:
%out_of_bounds_51 = icmp sge i32 %Temp_147, %arr_size_51
br i1 %out_of_bounds_51 , label %error_idx_51, label %continue_idx_51
error_idx_51:
call void @AccessViolation()
br label %continue_idx_51
continue_idx_51:
  %Temp_148 = add nsw i32 %Temp_147,1
;getlement temp temp temp;
  %Temp_149 = getelementptr inbounds i32*, i32** %Temp_146, i32 %Temp_148
;load temp temp;
  %Temp_150 = load i32*, i32** %Temp_149, align 8
%Temp_null_52 = bitcast i32* %Temp_150 to i32*
%equal_null_52 = icmp eq i32* %Temp_null_52, null
br i1 %equal_null_52, label %null_deref_52, label %continue_52
null_deref_52:
call void @InvalidPointer()
br label %continue_52
continue_52:
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_151 = add nsw i32 %zero_42, 2
%Temp_i32_53 = bitcast i32* %Temp_150 to i32*
%Temp_size_ptr_53 = getelementptr inbounds i32, i32* %Temp_i32_53, i32 0
%arr_size_53 = load i32, i32* %Temp_size_ptr_53,align 4
%sub_negative_53 = icmp slt i32  %Temp_151, 0
br i1 %sub_negative_53 , label %error_idx_53, label %positive_idx_53
positive_idx_53:
%out_of_bounds_53 = icmp sge i32 %Temp_151, %arr_size_53
br i1 %out_of_bounds_53 , label %error_idx_53, label %continue_idx_53
error_idx_53:
call void @AccessViolation()
br label %continue_idx_53
continue_idx_53:
  %Temp_152 = add nsw i32 %Temp_151,1
;getlement temp temp temp;
  %Temp_153 = getelementptr inbounds i32, i32* %Temp_150, i32 %Temp_152
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_154 = add nsw i32 %zero_43, 8
;store TYPES.TYPE_INT@20ad9418 dst src;
  store i32 %Temp_154, i32* %Temp_153, align 4
  %Temp_155 = load i32**, i32*** %local_3, align 8
%Temp_156 =call i32 @trace3x3(i32** %Temp_155 )
  call void @PrintInt(i32 %Temp_156 )
call void @exit(i32 0)
  ret void
}
