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

define i32 @monthJuly()
 { 
  %local_0 = alloca i32, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 7
  store i32 %Temp_0, i32* %local_0, align 4
  %Temp_1 = load i32, i32* %local_0, align 4
  ret i32 %Temp_1
}
define i32 @getAge(i8*)
 { 
  %p = alloca i8*, align 8
  store i8* %0, i8** %p, align 8
  %Temp_2 = load i8*, i8** %p, align 8
%Temp_null_0 = bitcast i8* %Temp_2 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 12
;getlement temp temp temp;
  %Temp_4 = getelementptr inbounds i8, i8* %Temp_2, i32 %Temp_3
  %Temp_5 = bitcast i8* %Temp_4 to i32*
;load temp temp;
%Temp_init_ptr_1 = bitcast i32* %Temp_5 to i32*
%init_state_1 = load i32, i32* %Temp_init_ptr_1,align 4
%is_init_1 = icmp eq i32  %init_state_1, 0
br i1 %is_init_1 , label %error_init_1, label %good_init_1
error_init_1:
call void @InvalidPointer()
br label %good_init_1
good_init_1:
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  %Temp_6 = load i32, i32* %Temp_actual_1 , align 4
  ret i32 %Temp_6
}
define i32 @birthday(i8*)
 { 
  %p = alloca i8*, align 8
  store i8* %0, i8** %p, align 8
  %Temp_7 = load i8*, i8** %p, align 8
%Temp_null_2 = bitcast i8* %Temp_7 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_2, 12
;getlement temp temp temp;
  %Temp_9 = getelementptr inbounds i8, i8* %Temp_7, i32 %Temp_8
  %Temp_10 = bitcast i8* %Temp_9 to i32*
  %Temp_12 = load i8*, i8** %p, align 8
%Temp_null_3 = bitcast i8* %Temp_12 to i32*
%equal_null_3 = icmp eq i32* %Temp_null_3, null
br i1 %equal_null_3, label %null_deref_3, label %continue_3
null_deref_3:
call void @InvalidPointer()
br label %continue_3
continue_3:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_3, 12
;getlement temp temp temp;
  %Temp_14 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_13
  %Temp_15 = bitcast i8* %Temp_14 to i32*
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_4, 1
;load temp temp;
%Temp_init_ptr_4 = bitcast i32* %Temp_15 to i32*
%init_state_4 = load i32, i32* %Temp_init_ptr_4,align 4
%is_init_4 = icmp eq i32  %init_state_4, 0
br i1 %is_init_4 , label %error_init_4, label %good_init_4
error_init_4:
call void @InvalidPointer()
br label %good_init_4
good_init_4:
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  %Temp_17 = load i32, i32* %Temp_actual_4 , align 4
  %Temp_11 = add nsw i32 %Temp_17, %Temp_16
%Temp_18 = call i32 @CheckOverflow(i32 %Temp_11)
;store TYPES.TYPE_INT@728938a9 dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_10 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_18, i32* %Temp_actual_5, align 4
  %Temp_19 = load i8*, i8** %p, align 8
%Temp_null_6 = bitcast i8* %Temp_19 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_5, 12
;getlement temp temp temp;
  %Temp_21 = getelementptr inbounds i8, i8* %Temp_19, i32 %Temp_20
  %Temp_22 = bitcast i8* %Temp_21 to i32*
;load temp temp;
%Temp_init_ptr_7 = bitcast i32* %Temp_22 to i32*
%init_state_7 = load i32, i32* %Temp_init_ptr_7,align 4
%is_init_7 = icmp eq i32  %init_state_7, 0
br i1 %is_init_7 , label %error_init_7, label %good_init_7
error_init_7:
call void @InvalidPointer()
br label %good_init_7
good_init_7:
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  %Temp_23 = load i32, i32* %Temp_actual_7 , align 4
  ret i32 %Temp_23
}
define i32 @getAverage(i8*)
 { 
  %s = alloca i8*, align 8
  %local_1 = alloca i32, align 4
  %local_0 = alloca i32, align 4
  store i8* %0, i8** %s, align 8
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_6, 0
  store i32 %Temp_24, i32* %local_0, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_7, 0
  store i32 %Temp_25, i32* %local_1, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_27 = load i32, i32* %local_0, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_8, 10
  %Temp_26 = icmp slt i32 %Temp_27, %Temp_28
  %Temp_29 = zext i1 %Temp_26 to i32
  %equal_zero_9 = icmp eq i32 %Temp_29, 0
  br i1 %equal_zero_9, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_31 = load i32, i32* %local_1, align 4
  %Temp_32 = load i8*, i8** %s, align 8
%Temp_null_8 = bitcast i8* %Temp_32 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_10, 28
;getlement temp temp temp;
  %Temp_34 = getelementptr inbounds i8, i8* %Temp_32, i32 %Temp_33
  %Temp_35 = bitcast i8* %Temp_34 to i32**
;load temp temp;
%Temp_init_ptr_9 = bitcast i32** %Temp_35 to i32*
%init_state_9 = load i32, i32* %Temp_init_ptr_9,align 4
%is_init_9 = icmp eq i32  %init_state_9, 0
br i1 %is_init_9 , label %error_init_9, label %good_init_9
error_init_9:
call void @InvalidPointer()
br label %good_init_9
good_init_9:
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32**
  %Temp_36 = load i32*, i32** %Temp_actual_9 , align 8
%Temp_null_10 = bitcast i32* %Temp_36 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %Temp_37 = load i32, i32* %local_0, align 4
%Temp_i32_11 = bitcast i32* %Temp_36 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_37, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_37, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_38 = add nsw i32 %Temp_37,1
;getlement temp temp temp;
  %Temp_39 = getelementptr inbounds i32, i32* %Temp_36, i32 %Temp_38
;load temp temp;
  %Temp_40 = load i32, i32* %Temp_39, align 4
  %Temp_30 = add nsw i32 %Temp_31, %Temp_40
%Temp_41 = call i32 @CheckOverflow(i32 %Temp_30)
  store i32 %Temp_41, i32* %local_1, align 4
  %Temp_43 = load i32, i32* %local_0, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_11, 1
  %Temp_42 = add nsw i32 %Temp_43, %Temp_44
%Temp_45 = call i32 @CheckOverflow(i32 %Temp_42)
  store i32 %Temp_45, i32* %local_0, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %Temp_47 = load i32, i32* %local_1, align 4
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_48 = add nsw i32 %zero_12, 10
%is_div_zero_0 = icmp eq i32  %Temp_48, 0
br i1 %is_div_zero_0 , label %div_by_zero_0, label %good_div_0
div_by_zero_0:
call void @DivideByZero()
br label %good_div_0
good_div_0:
  %Temp_46 = sdiv i32 %Temp_47, %Temp_48
%Temp_49 = call i32 @CheckOverflow(i32 %Temp_46)
  ret i32 %Temp_49
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_6 = alloca i32, align 4
  %local_8 = alloca i32, align 4
  %local_0 = alloca i8*, align 8
  %local_5 = alloca i32, align 4
  %local_2 = alloca i32, align 4
  %local_4 = alloca i32, align 4
  %local_9 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_7 = alloca i32, align 4
  %local_3 = alloca i32, align 4
  %local_10 = alloca i32, align 4
  call void @init_globals()
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_13, 40
  %Temp_52 = call i32* @malloc(i32 %Temp_51)
  %Temp_50 = bitcast i32* %Temp_52 to i8*
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_53 = add nsw i32 %zero_14, 12
;getlement temp temp temp;
  %Temp_54 = getelementptr inbounds i8, i8* %Temp_50, i32 %Temp_53
  %Temp_55 = bitcast i8* %Temp_54 to i32*
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_15, 10
;store TYPES.TYPE_INT@728938a9 dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_55 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_56, i32* %Temp_actual_12, align 4
  store i8* %Temp_50, i8** %local_0, align 8
  %Temp_57 = load i8*, i8** %local_0, align 8
%Temp_null_13 = bitcast i8* %Temp_57 to i32*
%equal_null_13 = icmp eq i32* %Temp_null_13, null
br i1 %equal_null_13, label %null_deref_13, label %continue_13
null_deref_13:
call void @InvalidPointer()
br label %continue_13
continue_13:
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_58 = add nsw i32 %zero_16, 28
;getlement temp temp temp;
  %Temp_59 = getelementptr inbounds i8, i8* %Temp_57, i32 %Temp_58
  %Temp_60 = bitcast i8* %Temp_59 to i32**
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_17, 10
  %Temp_63 = add nsw i32 %Temp_62,1
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_64 = add nsw i32 %zero_18, 8
  %Temp_65 = mul nsw i32 %Temp_63, %Temp_64
  %Temp_66 = call i32* @malloc(i32 %Temp_65)
  %Temp_61 = bitcast i32* %Temp_66 to i32*
  %Temp_67 = getelementptr inbounds i32, i32* %Temp_66, i32 0
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_62, i32* %Temp_67, align 4
;store TYPES.TYPE_ARRAY@21b8d17c dst src;
%Temp_init_ptr_14 = bitcast i32** %Temp_60 to i32*
store i32 1, i32* %Temp_init_ptr_14,align 4
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32**
  store i32* %Temp_61, i32** %Temp_actual_14, align 8
  %Temp_68 = load i8*, i8** %local_0, align 8
%Temp_null_15 = bitcast i8* %Temp_68 to i32*
%equal_null_15 = icmp eq i32* %Temp_null_15, null
br i1 %equal_null_15, label %null_deref_15, label %continue_15
null_deref_15:
call void @InvalidPointer()
br label %continue_15
continue_15:
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_69 = add nsw i32 %zero_19, 0
;getlement temp temp temp;
  %Temp_70 = getelementptr inbounds i8, i8* %Temp_68, i32 %Temp_69
  %Temp_71 = bitcast i8* %Temp_70 to i32**
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_73 = add nsw i32 %zero_20, 13
  %Temp_74 = add nsw i32 %Temp_73,1
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_75 = add nsw i32 %zero_21, 8
  %Temp_76 = mul nsw i32 %Temp_74, %Temp_75
  %Temp_77 = call i32* @malloc(i32 %Temp_76)
  %Temp_72 = bitcast i32* %Temp_77 to i32*
  %Temp_78 = getelementptr inbounds i32, i32* %Temp_77, i32 0
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_73, i32* %Temp_78, align 4
;store TYPES.TYPE_ARRAY@21b8d17c dst src;
%Temp_init_ptr_16 = bitcast i32** %Temp_71 to i32*
store i32 1, i32* %Temp_init_ptr_16,align 4
%Temp_actual_ptr_16 = getelementptr inbounds i32, i32* %Temp_init_ptr_16, i32 1
%Temp_actual_16 = bitcast i32* %Temp_actual_ptr_16 to i32**
  store i32* %Temp_72, i32** %Temp_actual_16, align 8
  %Temp_79 = load i8*, i8** %local_0, align 8
%Temp_null_17 = bitcast i8* %Temp_79 to i32*
%equal_null_17 = icmp eq i32* %Temp_null_17, null
br i1 %equal_null_17, label %null_deref_17, label %continue_17
null_deref_17:
call void @InvalidPointer()
br label %continue_17
continue_17:
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_80 = add nsw i32 %zero_22, 0
;getlement temp temp temp;
  %Temp_81 = getelementptr inbounds i8, i8* %Temp_79, i32 %Temp_80
  %Temp_82 = bitcast i8* %Temp_81 to i32**
;load temp temp;
%Temp_init_ptr_18 = bitcast i32** %Temp_82 to i32*
%init_state_18 = load i32, i32* %Temp_init_ptr_18,align 4
%is_init_18 = icmp eq i32  %init_state_18, 0
br i1 %is_init_18 , label %error_init_18, label %good_init_18
error_init_18:
call void @InvalidPointer()
br label %good_init_18
good_init_18:
%Temp_actual_ptr_18 = getelementptr inbounds i32, i32* %Temp_init_ptr_18, i32 1
%Temp_actual_18 = bitcast i32* %Temp_actual_ptr_18 to i32**
  %Temp_83 = load i32*, i32** %Temp_actual_18 , align 8
%Temp_null_19 = bitcast i32* %Temp_83 to i32*
%equal_null_19 = icmp eq i32* %Temp_null_19, null
br i1 %equal_null_19, label %null_deref_19, label %continue_19
null_deref_19:
call void @InvalidPointer()
br label %continue_19
continue_19:
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_23, 0
%Temp_i32_20 = bitcast i32* %Temp_83 to i32*
%Temp_size_ptr_20 = getelementptr inbounds i32, i32* %Temp_i32_20, i32 0
%arr_size_20 = load i32, i32* %Temp_size_ptr_20,align 4
%sub_negative_20 = icmp slt i32  %Temp_84, 0
br i1 %sub_negative_20 , label %error_idx_20, label %positive_idx_20
positive_idx_20:
%out_of_bounds_20 = icmp sge i32 %Temp_84, %arr_size_20
br i1 %out_of_bounds_20 , label %error_idx_20, label %continue_idx_20
error_idx_20:
call void @AccessViolation()
br label %continue_idx_20
continue_idx_20:
  %Temp_85 = add nsw i32 %Temp_84,1
;getlement temp temp temp;
  %Temp_86 = getelementptr inbounds i32, i32* %Temp_83, i32 %Temp_85
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_87 = add nsw i32 %zero_24, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_87, i32* %Temp_86, align 4
  %Temp_88 = load i8*, i8** %local_0, align 8
%Temp_null_21 = bitcast i8* %Temp_88 to i32*
%equal_null_21 = icmp eq i32* %Temp_null_21, null
br i1 %equal_null_21, label %null_deref_21, label %continue_21
null_deref_21:
call void @InvalidPointer()
br label %continue_21
continue_21:
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_89 = add nsw i32 %zero_25, 0
;getlement temp temp temp;
  %Temp_90 = getelementptr inbounds i8, i8* %Temp_88, i32 %Temp_89
  %Temp_91 = bitcast i8* %Temp_90 to i32**
;load temp temp;
%Temp_init_ptr_22 = bitcast i32** %Temp_91 to i32*
%init_state_22 = load i32, i32* %Temp_init_ptr_22,align 4
%is_init_22 = icmp eq i32  %init_state_22, 0
br i1 %is_init_22 , label %error_init_22, label %good_init_22
error_init_22:
call void @InvalidPointer()
br label %good_init_22
good_init_22:
%Temp_actual_ptr_22 = getelementptr inbounds i32, i32* %Temp_init_ptr_22, i32 1
%Temp_actual_22 = bitcast i32* %Temp_actual_ptr_22 to i32**
  %Temp_92 = load i32*, i32** %Temp_actual_22 , align 8
%Temp_null_23 = bitcast i32* %Temp_92 to i32*
%equal_null_23 = icmp eq i32* %Temp_null_23, null
br i1 %equal_null_23, label %null_deref_23, label %continue_23
null_deref_23:
call void @InvalidPointer()
br label %continue_23
continue_23:
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_93 = add nsw i32 %zero_26, 1
%Temp_i32_24 = bitcast i32* %Temp_92 to i32*
%Temp_size_ptr_24 = getelementptr inbounds i32, i32* %Temp_i32_24, i32 0
%arr_size_24 = load i32, i32* %Temp_size_ptr_24,align 4
%sub_negative_24 = icmp slt i32  %Temp_93, 0
br i1 %sub_negative_24 , label %error_idx_24, label %positive_idx_24
positive_idx_24:
%out_of_bounds_24 = icmp sge i32 %Temp_93, %arr_size_24
br i1 %out_of_bounds_24 , label %error_idx_24, label %continue_idx_24
error_idx_24:
call void @AccessViolation()
br label %continue_idx_24
continue_idx_24:
  %Temp_94 = add nsw i32 %Temp_93,1
;getlement temp temp temp;
  %Temp_95 = getelementptr inbounds i32, i32* %Temp_92, i32 %Temp_94
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_96 = add nsw i32 %zero_27, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_96, i32* %Temp_95, align 4
  %Temp_97 = load i8*, i8** %local_0, align 8
%Temp_null_25 = bitcast i8* %Temp_97 to i32*
%equal_null_25 = icmp eq i32* %Temp_null_25, null
br i1 %equal_null_25, label %null_deref_25, label %continue_25
null_deref_25:
call void @InvalidPointer()
br label %continue_25
continue_25:
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_98 = add nsw i32 %zero_28, 0
;getlement temp temp temp;
  %Temp_99 = getelementptr inbounds i8, i8* %Temp_97, i32 %Temp_98
  %Temp_100 = bitcast i8* %Temp_99 to i32**
;load temp temp;
%Temp_init_ptr_26 = bitcast i32** %Temp_100 to i32*
%init_state_26 = load i32, i32* %Temp_init_ptr_26,align 4
%is_init_26 = icmp eq i32  %init_state_26, 0
br i1 %is_init_26 , label %error_init_26, label %good_init_26
error_init_26:
call void @InvalidPointer()
br label %good_init_26
good_init_26:
%Temp_actual_ptr_26 = getelementptr inbounds i32, i32* %Temp_init_ptr_26, i32 1
%Temp_actual_26 = bitcast i32* %Temp_actual_ptr_26 to i32**
  %Temp_101 = load i32*, i32** %Temp_actual_26 , align 8
%Temp_null_27 = bitcast i32* %Temp_101 to i32*
%equal_null_27 = icmp eq i32* %Temp_null_27, null
br i1 %equal_null_27, label %null_deref_27, label %continue_27
null_deref_27:
call void @InvalidPointer()
br label %continue_27
continue_27:
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_102 = add nsw i32 %zero_29, 2
%Temp_i32_28 = bitcast i32* %Temp_101 to i32*
%Temp_size_ptr_28 = getelementptr inbounds i32, i32* %Temp_i32_28, i32 0
%arr_size_28 = load i32, i32* %Temp_size_ptr_28,align 4
%sub_negative_28 = icmp slt i32  %Temp_102, 0
br i1 %sub_negative_28 , label %error_idx_28, label %positive_idx_28
positive_idx_28:
%out_of_bounds_28 = icmp sge i32 %Temp_102, %arr_size_28
br i1 %out_of_bounds_28 , label %error_idx_28, label %continue_idx_28
error_idx_28:
call void @AccessViolation()
br label %continue_idx_28
continue_idx_28:
  %Temp_103 = add nsw i32 %Temp_102,1
;getlement temp temp temp;
  %Temp_104 = getelementptr inbounds i32, i32* %Temp_101, i32 %Temp_103
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_105 = add nsw i32 %zero_30, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_105, i32* %Temp_104, align 4
  %Temp_106 = load i8*, i8** %local_0, align 8
%Temp_null_29 = bitcast i8* %Temp_106 to i32*
%equal_null_29 = icmp eq i32* %Temp_null_29, null
br i1 %equal_null_29, label %null_deref_29, label %continue_29
null_deref_29:
call void @InvalidPointer()
br label %continue_29
continue_29:
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_107 = add nsw i32 %zero_31, 0
;getlement temp temp temp;
  %Temp_108 = getelementptr inbounds i8, i8* %Temp_106, i32 %Temp_107
  %Temp_109 = bitcast i8* %Temp_108 to i32**
;load temp temp;
%Temp_init_ptr_30 = bitcast i32** %Temp_109 to i32*
%init_state_30 = load i32, i32* %Temp_init_ptr_30,align 4
%is_init_30 = icmp eq i32  %init_state_30, 0
br i1 %is_init_30 , label %error_init_30, label %good_init_30
error_init_30:
call void @InvalidPointer()
br label %good_init_30
good_init_30:
%Temp_actual_ptr_30 = getelementptr inbounds i32, i32* %Temp_init_ptr_30, i32 1
%Temp_actual_30 = bitcast i32* %Temp_actual_ptr_30 to i32**
  %Temp_110 = load i32*, i32** %Temp_actual_30 , align 8
%Temp_null_31 = bitcast i32* %Temp_110 to i32*
%equal_null_31 = icmp eq i32* %Temp_null_31, null
br i1 %equal_null_31, label %null_deref_31, label %continue_31
null_deref_31:
call void @InvalidPointer()
br label %continue_31
continue_31:
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_32, 3
%Temp_i32_32 = bitcast i32* %Temp_110 to i32*
%Temp_size_ptr_32 = getelementptr inbounds i32, i32* %Temp_i32_32, i32 0
%arr_size_32 = load i32, i32* %Temp_size_ptr_32,align 4
%sub_negative_32 = icmp slt i32  %Temp_111, 0
br i1 %sub_negative_32 , label %error_idx_32, label %positive_idx_32
positive_idx_32:
%out_of_bounds_32 = icmp sge i32 %Temp_111, %arr_size_32
br i1 %out_of_bounds_32 , label %error_idx_32, label %continue_idx_32
error_idx_32:
call void @AccessViolation()
br label %continue_idx_32
continue_idx_32:
  %Temp_112 = add nsw i32 %Temp_111,1
;getlement temp temp temp;
  %Temp_113 = getelementptr inbounds i32, i32* %Temp_110, i32 %Temp_112
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_114 = add nsw i32 %zero_33, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_114, i32* %Temp_113, align 4
  %Temp_115 = load i8*, i8** %local_0, align 8
%Temp_null_33 = bitcast i8* %Temp_115 to i32*
%equal_null_33 = icmp eq i32* %Temp_null_33, null
br i1 %equal_null_33, label %null_deref_33, label %continue_33
null_deref_33:
call void @InvalidPointer()
br label %continue_33
continue_33:
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_116 = add nsw i32 %zero_34, 0
;getlement temp temp temp;
  %Temp_117 = getelementptr inbounds i8, i8* %Temp_115, i32 %Temp_116
  %Temp_118 = bitcast i8* %Temp_117 to i32**
;load temp temp;
%Temp_init_ptr_34 = bitcast i32** %Temp_118 to i32*
%init_state_34 = load i32, i32* %Temp_init_ptr_34,align 4
%is_init_34 = icmp eq i32  %init_state_34, 0
br i1 %is_init_34 , label %error_init_34, label %good_init_34
error_init_34:
call void @InvalidPointer()
br label %good_init_34
good_init_34:
%Temp_actual_ptr_34 = getelementptr inbounds i32, i32* %Temp_init_ptr_34, i32 1
%Temp_actual_34 = bitcast i32* %Temp_actual_ptr_34 to i32**
  %Temp_119 = load i32*, i32** %Temp_actual_34 , align 8
%Temp_null_35 = bitcast i32* %Temp_119 to i32*
%equal_null_35 = icmp eq i32* %Temp_null_35, null
br i1 %equal_null_35, label %null_deref_35, label %continue_35
null_deref_35:
call void @InvalidPointer()
br label %continue_35
continue_35:
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_120 = add nsw i32 %zero_35, 4
%Temp_i32_36 = bitcast i32* %Temp_119 to i32*
%Temp_size_ptr_36 = getelementptr inbounds i32, i32* %Temp_i32_36, i32 0
%arr_size_36 = load i32, i32* %Temp_size_ptr_36,align 4
%sub_negative_36 = icmp slt i32  %Temp_120, 0
br i1 %sub_negative_36 , label %error_idx_36, label %positive_idx_36
positive_idx_36:
%out_of_bounds_36 = icmp sge i32 %Temp_120, %arr_size_36
br i1 %out_of_bounds_36 , label %error_idx_36, label %continue_idx_36
error_idx_36:
call void @AccessViolation()
br label %continue_idx_36
continue_idx_36:
  %Temp_121 = add nsw i32 %Temp_120,1
;getlement temp temp temp;
  %Temp_122 = getelementptr inbounds i32, i32* %Temp_119, i32 %Temp_121
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_123 = add nsw i32 %zero_36, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_123, i32* %Temp_122, align 4
  %Temp_124 = load i8*, i8** %local_0, align 8
%Temp_null_37 = bitcast i8* %Temp_124 to i32*
%equal_null_37 = icmp eq i32* %Temp_null_37, null
br i1 %equal_null_37, label %null_deref_37, label %continue_37
null_deref_37:
call void @InvalidPointer()
br label %continue_37
continue_37:
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_125 = add nsw i32 %zero_37, 0
;getlement temp temp temp;
  %Temp_126 = getelementptr inbounds i8, i8* %Temp_124, i32 %Temp_125
  %Temp_127 = bitcast i8* %Temp_126 to i32**
;load temp temp;
%Temp_init_ptr_38 = bitcast i32** %Temp_127 to i32*
%init_state_38 = load i32, i32* %Temp_init_ptr_38,align 4
%is_init_38 = icmp eq i32  %init_state_38, 0
br i1 %is_init_38 , label %error_init_38, label %good_init_38
error_init_38:
call void @InvalidPointer()
br label %good_init_38
good_init_38:
%Temp_actual_ptr_38 = getelementptr inbounds i32, i32* %Temp_init_ptr_38, i32 1
%Temp_actual_38 = bitcast i32* %Temp_actual_ptr_38 to i32**
  %Temp_128 = load i32*, i32** %Temp_actual_38 , align 8
%Temp_null_39 = bitcast i32* %Temp_128 to i32*
%equal_null_39 = icmp eq i32* %Temp_null_39, null
br i1 %equal_null_39, label %null_deref_39, label %continue_39
null_deref_39:
call void @InvalidPointer()
br label %continue_39
continue_39:
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_129 = add nsw i32 %zero_38, 5
%Temp_i32_40 = bitcast i32* %Temp_128 to i32*
%Temp_size_ptr_40 = getelementptr inbounds i32, i32* %Temp_i32_40, i32 0
%arr_size_40 = load i32, i32* %Temp_size_ptr_40,align 4
%sub_negative_40 = icmp slt i32  %Temp_129, 0
br i1 %sub_negative_40 , label %error_idx_40, label %positive_idx_40
positive_idx_40:
%out_of_bounds_40 = icmp sge i32 %Temp_129, %arr_size_40
br i1 %out_of_bounds_40 , label %error_idx_40, label %continue_idx_40
error_idx_40:
call void @AccessViolation()
br label %continue_idx_40
continue_idx_40:
  %Temp_130 = add nsw i32 %Temp_129,1
;getlement temp temp temp;
  %Temp_131 = getelementptr inbounds i32, i32* %Temp_128, i32 %Temp_130
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_132 = add nsw i32 %zero_39, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_132, i32* %Temp_131, align 4
  %Temp_133 = load i8*, i8** %local_0, align 8
%Temp_null_41 = bitcast i8* %Temp_133 to i32*
%equal_null_41 = icmp eq i32* %Temp_null_41, null
br i1 %equal_null_41, label %null_deref_41, label %continue_41
null_deref_41:
call void @InvalidPointer()
br label %continue_41
continue_41:
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_134 = add nsw i32 %zero_40, 0
;getlement temp temp temp;
  %Temp_135 = getelementptr inbounds i8, i8* %Temp_133, i32 %Temp_134
  %Temp_136 = bitcast i8* %Temp_135 to i32**
;load temp temp;
%Temp_init_ptr_42 = bitcast i32** %Temp_136 to i32*
%init_state_42 = load i32, i32* %Temp_init_ptr_42,align 4
%is_init_42 = icmp eq i32  %init_state_42, 0
br i1 %is_init_42 , label %error_init_42, label %good_init_42
error_init_42:
call void @InvalidPointer()
br label %good_init_42
good_init_42:
%Temp_actual_ptr_42 = getelementptr inbounds i32, i32* %Temp_init_ptr_42, i32 1
%Temp_actual_42 = bitcast i32* %Temp_actual_ptr_42 to i32**
  %Temp_137 = load i32*, i32** %Temp_actual_42 , align 8
%Temp_null_43 = bitcast i32* %Temp_137 to i32*
%equal_null_43 = icmp eq i32* %Temp_null_43, null
br i1 %equal_null_43, label %null_deref_43, label %continue_43
null_deref_43:
call void @InvalidPointer()
br label %continue_43
continue_43:
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_138 = add nsw i32 %zero_41, 6
%Temp_i32_44 = bitcast i32* %Temp_137 to i32*
%Temp_size_ptr_44 = getelementptr inbounds i32, i32* %Temp_i32_44, i32 0
%arr_size_44 = load i32, i32* %Temp_size_ptr_44,align 4
%sub_negative_44 = icmp slt i32  %Temp_138, 0
br i1 %sub_negative_44 , label %error_idx_44, label %positive_idx_44
positive_idx_44:
%out_of_bounds_44 = icmp sge i32 %Temp_138, %arr_size_44
br i1 %out_of_bounds_44 , label %error_idx_44, label %continue_idx_44
error_idx_44:
call void @AccessViolation()
br label %continue_idx_44
continue_idx_44:
  %Temp_139 = add nsw i32 %Temp_138,1
;getlement temp temp temp;
  %Temp_140 = getelementptr inbounds i32, i32* %Temp_137, i32 %Temp_139
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_141 = add nsw i32 %zero_42, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_141, i32* %Temp_140, align 4
  %Temp_142 = load i8*, i8** %local_0, align 8
%Temp_null_45 = bitcast i8* %Temp_142 to i32*
%equal_null_45 = icmp eq i32* %Temp_null_45, null
br i1 %equal_null_45, label %null_deref_45, label %continue_45
null_deref_45:
call void @InvalidPointer()
br label %continue_45
continue_45:
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_143 = add nsw i32 %zero_43, 0
;getlement temp temp temp;
  %Temp_144 = getelementptr inbounds i8, i8* %Temp_142, i32 %Temp_143
  %Temp_145 = bitcast i8* %Temp_144 to i32**
;load temp temp;
%Temp_init_ptr_46 = bitcast i32** %Temp_145 to i32*
%init_state_46 = load i32, i32* %Temp_init_ptr_46,align 4
%is_init_46 = icmp eq i32  %init_state_46, 0
br i1 %is_init_46 , label %error_init_46, label %good_init_46
error_init_46:
call void @InvalidPointer()
br label %good_init_46
good_init_46:
%Temp_actual_ptr_46 = getelementptr inbounds i32, i32* %Temp_init_ptr_46, i32 1
%Temp_actual_46 = bitcast i32* %Temp_actual_ptr_46 to i32**
  %Temp_146 = load i32*, i32** %Temp_actual_46 , align 8
%Temp_null_47 = bitcast i32* %Temp_146 to i32*
%equal_null_47 = icmp eq i32* %Temp_null_47, null
br i1 %equal_null_47, label %null_deref_47, label %continue_47
null_deref_47:
call void @InvalidPointer()
br label %continue_47
continue_47:
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_147 = add nsw i32 %zero_44, 7
%Temp_i32_48 = bitcast i32* %Temp_146 to i32*
%Temp_size_ptr_48 = getelementptr inbounds i32, i32* %Temp_i32_48, i32 0
%arr_size_48 = load i32, i32* %Temp_size_ptr_48,align 4
%sub_negative_48 = icmp slt i32  %Temp_147, 0
br i1 %sub_negative_48 , label %error_idx_48, label %positive_idx_48
positive_idx_48:
%out_of_bounds_48 = icmp sge i32 %Temp_147, %arr_size_48
br i1 %out_of_bounds_48 , label %error_idx_48, label %continue_idx_48
error_idx_48:
call void @AccessViolation()
br label %continue_idx_48
continue_idx_48:
  %Temp_148 = add nsw i32 %Temp_147,1
;getlement temp temp temp;
  %Temp_149 = getelementptr inbounds i32, i32* %Temp_146, i32 %Temp_148
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_150 = add nsw i32 %zero_45, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_150, i32* %Temp_149, align 4
  %Temp_151 = load i8*, i8** %local_0, align 8
%Temp_null_49 = bitcast i8* %Temp_151 to i32*
%equal_null_49 = icmp eq i32* %Temp_null_49, null
br i1 %equal_null_49, label %null_deref_49, label %continue_49
null_deref_49:
call void @InvalidPointer()
br label %continue_49
continue_49:
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_152 = add nsw i32 %zero_46, 0
;getlement temp temp temp;
  %Temp_153 = getelementptr inbounds i8, i8* %Temp_151, i32 %Temp_152
  %Temp_154 = bitcast i8* %Temp_153 to i32**
;load temp temp;
%Temp_init_ptr_50 = bitcast i32** %Temp_154 to i32*
%init_state_50 = load i32, i32* %Temp_init_ptr_50,align 4
%is_init_50 = icmp eq i32  %init_state_50, 0
br i1 %is_init_50 , label %error_init_50, label %good_init_50
error_init_50:
call void @InvalidPointer()
br label %good_init_50
good_init_50:
%Temp_actual_ptr_50 = getelementptr inbounds i32, i32* %Temp_init_ptr_50, i32 1
%Temp_actual_50 = bitcast i32* %Temp_actual_ptr_50 to i32**
  %Temp_155 = load i32*, i32** %Temp_actual_50 , align 8
%Temp_null_51 = bitcast i32* %Temp_155 to i32*
%equal_null_51 = icmp eq i32* %Temp_null_51, null
br i1 %equal_null_51, label %null_deref_51, label %continue_51
null_deref_51:
call void @InvalidPointer()
br label %continue_51
continue_51:
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_156 = add nsw i32 %zero_47, 8
%Temp_i32_52 = bitcast i32* %Temp_155 to i32*
%Temp_size_ptr_52 = getelementptr inbounds i32, i32* %Temp_i32_52, i32 0
%arr_size_52 = load i32, i32* %Temp_size_ptr_52,align 4
%sub_negative_52 = icmp slt i32  %Temp_156, 0
br i1 %sub_negative_52 , label %error_idx_52, label %positive_idx_52
positive_idx_52:
%out_of_bounds_52 = icmp sge i32 %Temp_156, %arr_size_52
br i1 %out_of_bounds_52 , label %error_idx_52, label %continue_idx_52
error_idx_52:
call void @AccessViolation()
br label %continue_idx_52
continue_idx_52:
  %Temp_157 = add nsw i32 %Temp_156,1
;getlement temp temp temp;
  %Temp_158 = getelementptr inbounds i32, i32* %Temp_155, i32 %Temp_157
  %zero_48 = load i32, i32* @my_zero, align 4
  %Temp_159 = add nsw i32 %zero_48, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_159, i32* %Temp_158, align 4
  %Temp_160 = load i8*, i8** %local_0, align 8
%Temp_null_53 = bitcast i8* %Temp_160 to i32*
%equal_null_53 = icmp eq i32* %Temp_null_53, null
br i1 %equal_null_53, label %null_deref_53, label %continue_53
null_deref_53:
call void @InvalidPointer()
br label %continue_53
continue_53:
  %zero_49 = load i32, i32* @my_zero, align 4
  %Temp_161 = add nsw i32 %zero_49, 0
;getlement temp temp temp;
  %Temp_162 = getelementptr inbounds i8, i8* %Temp_160, i32 %Temp_161
  %Temp_163 = bitcast i8* %Temp_162 to i32**
;load temp temp;
%Temp_init_ptr_54 = bitcast i32** %Temp_163 to i32*
%init_state_54 = load i32, i32* %Temp_init_ptr_54,align 4
%is_init_54 = icmp eq i32  %init_state_54, 0
br i1 %is_init_54 , label %error_init_54, label %good_init_54
error_init_54:
call void @InvalidPointer()
br label %good_init_54
good_init_54:
%Temp_actual_ptr_54 = getelementptr inbounds i32, i32* %Temp_init_ptr_54, i32 1
%Temp_actual_54 = bitcast i32* %Temp_actual_ptr_54 to i32**
  %Temp_164 = load i32*, i32** %Temp_actual_54 , align 8
%Temp_null_55 = bitcast i32* %Temp_164 to i32*
%equal_null_55 = icmp eq i32* %Temp_null_55, null
br i1 %equal_null_55, label %null_deref_55, label %continue_55
null_deref_55:
call void @InvalidPointer()
br label %continue_55
continue_55:
  %zero_50 = load i32, i32* @my_zero, align 4
  %Temp_165 = add nsw i32 %zero_50, 9
%Temp_i32_56 = bitcast i32* %Temp_164 to i32*
%Temp_size_ptr_56 = getelementptr inbounds i32, i32* %Temp_i32_56, i32 0
%arr_size_56 = load i32, i32* %Temp_size_ptr_56,align 4
%sub_negative_56 = icmp slt i32  %Temp_165, 0
br i1 %sub_negative_56 , label %error_idx_56, label %positive_idx_56
positive_idx_56:
%out_of_bounds_56 = icmp sge i32 %Temp_165, %arr_size_56
br i1 %out_of_bounds_56 , label %error_idx_56, label %continue_idx_56
error_idx_56:
call void @AccessViolation()
br label %continue_idx_56
continue_idx_56:
  %Temp_166 = add nsw i32 %Temp_165,1
;getlement temp temp temp;
  %Temp_167 = getelementptr inbounds i32, i32* %Temp_164, i32 %Temp_166
  %zero_51 = load i32, i32* @my_zero, align 4
  %Temp_168 = add nsw i32 %zero_51, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_168, i32* %Temp_167, align 4
  %Temp_169 = load i8*, i8** %local_0, align 8
%Temp_null_57 = bitcast i8* %Temp_169 to i32*
%equal_null_57 = icmp eq i32* %Temp_null_57, null
br i1 %equal_null_57, label %null_deref_57, label %continue_57
null_deref_57:
call void @InvalidPointer()
br label %continue_57
continue_57:
  %zero_52 = load i32, i32* @my_zero, align 4
  %Temp_170 = add nsw i32 %zero_52, 0
;getlement temp temp temp;
  %Temp_171 = getelementptr inbounds i8, i8* %Temp_169, i32 %Temp_170
  %Temp_172 = bitcast i8* %Temp_171 to i32**
;load temp temp;
%Temp_init_ptr_58 = bitcast i32** %Temp_172 to i32*
%init_state_58 = load i32, i32* %Temp_init_ptr_58,align 4
%is_init_58 = icmp eq i32  %init_state_58, 0
br i1 %is_init_58 , label %error_init_58, label %good_init_58
error_init_58:
call void @InvalidPointer()
br label %good_init_58
good_init_58:
%Temp_actual_ptr_58 = getelementptr inbounds i32, i32* %Temp_init_ptr_58, i32 1
%Temp_actual_58 = bitcast i32* %Temp_actual_ptr_58 to i32**
  %Temp_173 = load i32*, i32** %Temp_actual_58 , align 8
%Temp_null_59 = bitcast i32* %Temp_173 to i32*
%equal_null_59 = icmp eq i32* %Temp_null_59, null
br i1 %equal_null_59, label %null_deref_59, label %continue_59
null_deref_59:
call void @InvalidPointer()
br label %continue_59
continue_59:
  %zero_53 = load i32, i32* @my_zero, align 4
  %Temp_174 = add nsw i32 %zero_53, 10
%Temp_i32_60 = bitcast i32* %Temp_173 to i32*
%Temp_size_ptr_60 = getelementptr inbounds i32, i32* %Temp_i32_60, i32 0
%arr_size_60 = load i32, i32* %Temp_size_ptr_60,align 4
%sub_negative_60 = icmp slt i32  %Temp_174, 0
br i1 %sub_negative_60 , label %error_idx_60, label %positive_idx_60
positive_idx_60:
%out_of_bounds_60 = icmp sge i32 %Temp_174, %arr_size_60
br i1 %out_of_bounds_60 , label %error_idx_60, label %continue_idx_60
error_idx_60:
call void @AccessViolation()
br label %continue_idx_60
continue_idx_60:
  %Temp_175 = add nsw i32 %Temp_174,1
;getlement temp temp temp;
  %Temp_176 = getelementptr inbounds i32, i32* %Temp_173, i32 %Temp_175
  %zero_54 = load i32, i32* @my_zero, align 4
  %Temp_177 = add nsw i32 %zero_54, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_177, i32* %Temp_176, align 4
  %Temp_178 = load i8*, i8** %local_0, align 8
%Temp_null_61 = bitcast i8* %Temp_178 to i32*
%equal_null_61 = icmp eq i32* %Temp_null_61, null
br i1 %equal_null_61, label %null_deref_61, label %continue_61
null_deref_61:
call void @InvalidPointer()
br label %continue_61
continue_61:
  %zero_55 = load i32, i32* @my_zero, align 4
  %Temp_179 = add nsw i32 %zero_55, 0
;getlement temp temp temp;
  %Temp_180 = getelementptr inbounds i8, i8* %Temp_178, i32 %Temp_179
  %Temp_181 = bitcast i8* %Temp_180 to i32**
;load temp temp;
%Temp_init_ptr_62 = bitcast i32** %Temp_181 to i32*
%init_state_62 = load i32, i32* %Temp_init_ptr_62,align 4
%is_init_62 = icmp eq i32  %init_state_62, 0
br i1 %is_init_62 , label %error_init_62, label %good_init_62
error_init_62:
call void @InvalidPointer()
br label %good_init_62
good_init_62:
%Temp_actual_ptr_62 = getelementptr inbounds i32, i32* %Temp_init_ptr_62, i32 1
%Temp_actual_62 = bitcast i32* %Temp_actual_ptr_62 to i32**
  %Temp_182 = load i32*, i32** %Temp_actual_62 , align 8
%Temp_null_63 = bitcast i32* %Temp_182 to i32*
%equal_null_63 = icmp eq i32* %Temp_null_63, null
br i1 %equal_null_63, label %null_deref_63, label %continue_63
null_deref_63:
call void @InvalidPointer()
br label %continue_63
continue_63:
  %zero_56 = load i32, i32* @my_zero, align 4
  %Temp_183 = add nsw i32 %zero_56, 11
%Temp_i32_64 = bitcast i32* %Temp_182 to i32*
%Temp_size_ptr_64 = getelementptr inbounds i32, i32* %Temp_i32_64, i32 0
%arr_size_64 = load i32, i32* %Temp_size_ptr_64,align 4
%sub_negative_64 = icmp slt i32  %Temp_183, 0
br i1 %sub_negative_64 , label %error_idx_64, label %positive_idx_64
positive_idx_64:
%out_of_bounds_64 = icmp sge i32 %Temp_183, %arr_size_64
br i1 %out_of_bounds_64 , label %error_idx_64, label %continue_idx_64
error_idx_64:
call void @AccessViolation()
br label %continue_idx_64
continue_idx_64:
  %Temp_184 = add nsw i32 %Temp_183,1
;getlement temp temp temp;
  %Temp_185 = getelementptr inbounds i32, i32* %Temp_182, i32 %Temp_184
  %zero_57 = load i32, i32* @my_zero, align 4
  %Temp_186 = add nsw i32 %zero_57, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_186, i32* %Temp_185, align 4
  %Temp_187 = load i8*, i8** %local_0, align 8
%Temp_null_65 = bitcast i8* %Temp_187 to i32*
%equal_null_65 = icmp eq i32* %Temp_null_65, null
br i1 %equal_null_65, label %null_deref_65, label %continue_65
null_deref_65:
call void @InvalidPointer()
br label %continue_65
continue_65:
  %zero_58 = load i32, i32* @my_zero, align 4
  %Temp_188 = add nsw i32 %zero_58, 0
;getlement temp temp temp;
  %Temp_189 = getelementptr inbounds i8, i8* %Temp_187, i32 %Temp_188
  %Temp_190 = bitcast i8* %Temp_189 to i32**
;load temp temp;
%Temp_init_ptr_66 = bitcast i32** %Temp_190 to i32*
%init_state_66 = load i32, i32* %Temp_init_ptr_66,align 4
%is_init_66 = icmp eq i32  %init_state_66, 0
br i1 %is_init_66 , label %error_init_66, label %good_init_66
error_init_66:
call void @InvalidPointer()
br label %good_init_66
good_init_66:
%Temp_actual_ptr_66 = getelementptr inbounds i32, i32* %Temp_init_ptr_66, i32 1
%Temp_actual_66 = bitcast i32* %Temp_actual_ptr_66 to i32**
  %Temp_191 = load i32*, i32** %Temp_actual_66 , align 8
%Temp_null_67 = bitcast i32* %Temp_191 to i32*
%equal_null_67 = icmp eq i32* %Temp_null_67, null
br i1 %equal_null_67, label %null_deref_67, label %continue_67
null_deref_67:
call void @InvalidPointer()
br label %continue_67
continue_67:
  %zero_59 = load i32, i32* @my_zero, align 4
  %Temp_192 = add nsw i32 %zero_59, 12
%Temp_i32_68 = bitcast i32* %Temp_191 to i32*
%Temp_size_ptr_68 = getelementptr inbounds i32, i32* %Temp_i32_68, i32 0
%arr_size_68 = load i32, i32* %Temp_size_ptr_68,align 4
%sub_negative_68 = icmp slt i32  %Temp_192, 0
br i1 %sub_negative_68 , label %error_idx_68, label %positive_idx_68
positive_idx_68:
%out_of_bounds_68 = icmp sge i32 %Temp_192, %arr_size_68
br i1 %out_of_bounds_68 , label %error_idx_68, label %continue_idx_68
error_idx_68:
call void @AccessViolation()
br label %continue_idx_68
continue_idx_68:
  %Temp_193 = add nsw i32 %Temp_192,1
;getlement temp temp temp;
  %Temp_194 = getelementptr inbounds i32, i32* %Temp_191, i32 %Temp_193
  %zero_60 = load i32, i32* @my_zero, align 4
  %Temp_195 = add nsw i32 %zero_60, 7400
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_195, i32* %Temp_194, align 4
  %zero_61 = load i32, i32* @my_zero, align 4
  %Temp_196 = add nsw i32 %zero_61, 0
  store i32 %Temp_196, i32* %local_1, align 4
  %zero_62 = load i32, i32* @my_zero, align 4
  %Temp_197 = add nsw i32 %zero_62, 1
  store i32 %Temp_197, i32* %local_2, align 4
  %zero_63 = load i32, i32* @my_zero, align 4
  %Temp_198 = add nsw i32 %zero_63, 2
  store i32 %Temp_198, i32* %local_3, align 4
  %zero_64 = load i32, i32* @my_zero, align 4
  %Temp_199 = add nsw i32 %zero_64, 3
  store i32 %Temp_199, i32* %local_4, align 4
  %zero_65 = load i32, i32* @my_zero, align 4
  %Temp_200 = add nsw i32 %zero_65, 4
  store i32 %Temp_200, i32* %local_5, align 4
  %zero_66 = load i32, i32* @my_zero, align 4
  %Temp_201 = add nsw i32 %zero_66, 5
  store i32 %Temp_201, i32* %local_6, align 4
  %zero_67 = load i32, i32* @my_zero, align 4
  %Temp_202 = add nsw i32 %zero_67, 6
  store i32 %Temp_202, i32* %local_7, align 4
  %zero_68 = load i32, i32* @my_zero, align 4
  %Temp_203 = add nsw i32 %zero_68, 7
  store i32 %Temp_203, i32* %local_8, align 4
  %zero_69 = load i32, i32* @my_zero, align 4
  %Temp_204 = add nsw i32 %zero_69, 8
  store i32 %Temp_204, i32* %local_9, align 4
  %zero_70 = load i32, i32* @my_zero, align 4
  %Temp_205 = add nsw i32 %zero_70, 9
  store i32 %Temp_205, i32* %local_10, align 4
  %Temp_206 = load i8*, i8** %local_0, align 8
%Temp_null_69 = bitcast i8* %Temp_206 to i32*
%equal_null_69 = icmp eq i32* %Temp_null_69, null
br i1 %equal_null_69, label %null_deref_69, label %continue_69
null_deref_69:
call void @InvalidPointer()
br label %continue_69
continue_69:
  %zero_71 = load i32, i32* @my_zero, align 4
  %Temp_207 = add nsw i32 %zero_71, 28
;getlement temp temp temp;
  %Temp_208 = getelementptr inbounds i8, i8* %Temp_206, i32 %Temp_207
  %Temp_209 = bitcast i8* %Temp_208 to i32**
;load temp temp;
%Temp_init_ptr_70 = bitcast i32** %Temp_209 to i32*
%init_state_70 = load i32, i32* %Temp_init_ptr_70,align 4
%is_init_70 = icmp eq i32  %init_state_70, 0
br i1 %is_init_70 , label %error_init_70, label %good_init_70
error_init_70:
call void @InvalidPointer()
br label %good_init_70
good_init_70:
%Temp_actual_ptr_70 = getelementptr inbounds i32, i32* %Temp_init_ptr_70, i32 1
%Temp_actual_70 = bitcast i32* %Temp_actual_ptr_70 to i32**
  %Temp_210 = load i32*, i32** %Temp_actual_70 , align 8
%Temp_null_71 = bitcast i32* %Temp_210 to i32*
%equal_null_71 = icmp eq i32* %Temp_null_71, null
br i1 %equal_null_71, label %null_deref_71, label %continue_71
null_deref_71:
call void @InvalidPointer()
br label %continue_71
continue_71:
  %Temp_211 = load i32, i32* %local_1, align 4
%Temp_i32_72 = bitcast i32* %Temp_210 to i32*
%Temp_size_ptr_72 = getelementptr inbounds i32, i32* %Temp_i32_72, i32 0
%arr_size_72 = load i32, i32* %Temp_size_ptr_72,align 4
%sub_negative_72 = icmp slt i32  %Temp_211, 0
br i1 %sub_negative_72 , label %error_idx_72, label %positive_idx_72
positive_idx_72:
%out_of_bounds_72 = icmp sge i32 %Temp_211, %arr_size_72
br i1 %out_of_bounds_72 , label %error_idx_72, label %continue_idx_72
error_idx_72:
call void @AccessViolation()
br label %continue_idx_72
continue_idx_72:
  %Temp_212 = add nsw i32 %Temp_211,1
;getlement temp temp temp;
  %Temp_213 = getelementptr inbounds i32, i32* %Temp_210, i32 %Temp_212
  %zero_72 = load i32, i32* @my_zero, align 4
  %Temp_214 = add nsw i32 %zero_72, 96
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_214, i32* %Temp_213, align 4
  %Temp_215 = load i8*, i8** %local_0, align 8
%Temp_null_73 = bitcast i8* %Temp_215 to i32*
%equal_null_73 = icmp eq i32* %Temp_null_73, null
br i1 %equal_null_73, label %null_deref_73, label %continue_73
null_deref_73:
call void @InvalidPointer()
br label %continue_73
continue_73:
  %zero_73 = load i32, i32* @my_zero, align 4
  %Temp_216 = add nsw i32 %zero_73, 28
;getlement temp temp temp;
  %Temp_217 = getelementptr inbounds i8, i8* %Temp_215, i32 %Temp_216
  %Temp_218 = bitcast i8* %Temp_217 to i32**
;load temp temp;
%Temp_init_ptr_74 = bitcast i32** %Temp_218 to i32*
%init_state_74 = load i32, i32* %Temp_init_ptr_74,align 4
%is_init_74 = icmp eq i32  %init_state_74, 0
br i1 %is_init_74 , label %error_init_74, label %good_init_74
error_init_74:
call void @InvalidPointer()
br label %good_init_74
good_init_74:
%Temp_actual_ptr_74 = getelementptr inbounds i32, i32* %Temp_init_ptr_74, i32 1
%Temp_actual_74 = bitcast i32* %Temp_actual_ptr_74 to i32**
  %Temp_219 = load i32*, i32** %Temp_actual_74 , align 8
%Temp_null_75 = bitcast i32* %Temp_219 to i32*
%equal_null_75 = icmp eq i32* %Temp_null_75, null
br i1 %equal_null_75, label %null_deref_75, label %continue_75
null_deref_75:
call void @InvalidPointer()
br label %continue_75
continue_75:
  %Temp_220 = load i32, i32* %local_2, align 4
%Temp_i32_76 = bitcast i32* %Temp_219 to i32*
%Temp_size_ptr_76 = getelementptr inbounds i32, i32* %Temp_i32_76, i32 0
%arr_size_76 = load i32, i32* %Temp_size_ptr_76,align 4
%sub_negative_76 = icmp slt i32  %Temp_220, 0
br i1 %sub_negative_76 , label %error_idx_76, label %positive_idx_76
positive_idx_76:
%out_of_bounds_76 = icmp sge i32 %Temp_220, %arr_size_76
br i1 %out_of_bounds_76 , label %error_idx_76, label %continue_idx_76
error_idx_76:
call void @AccessViolation()
br label %continue_idx_76
continue_idx_76:
  %Temp_221 = add nsw i32 %Temp_220,1
;getlement temp temp temp;
  %Temp_222 = getelementptr inbounds i32, i32* %Temp_219, i32 %Temp_221
  %zero_74 = load i32, i32* @my_zero, align 4
  %Temp_223 = add nsw i32 %zero_74, 100
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_223, i32* %Temp_222, align 4
  %Temp_224 = load i8*, i8** %local_0, align 8
%Temp_null_77 = bitcast i8* %Temp_224 to i32*
%equal_null_77 = icmp eq i32* %Temp_null_77, null
br i1 %equal_null_77, label %null_deref_77, label %continue_77
null_deref_77:
call void @InvalidPointer()
br label %continue_77
continue_77:
  %zero_75 = load i32, i32* @my_zero, align 4
  %Temp_225 = add nsw i32 %zero_75, 28
;getlement temp temp temp;
  %Temp_226 = getelementptr inbounds i8, i8* %Temp_224, i32 %Temp_225
  %Temp_227 = bitcast i8* %Temp_226 to i32**
;load temp temp;
%Temp_init_ptr_78 = bitcast i32** %Temp_227 to i32*
%init_state_78 = load i32, i32* %Temp_init_ptr_78,align 4
%is_init_78 = icmp eq i32  %init_state_78, 0
br i1 %is_init_78 , label %error_init_78, label %good_init_78
error_init_78:
call void @InvalidPointer()
br label %good_init_78
good_init_78:
%Temp_actual_ptr_78 = getelementptr inbounds i32, i32* %Temp_init_ptr_78, i32 1
%Temp_actual_78 = bitcast i32* %Temp_actual_ptr_78 to i32**
  %Temp_228 = load i32*, i32** %Temp_actual_78 , align 8
%Temp_null_79 = bitcast i32* %Temp_228 to i32*
%equal_null_79 = icmp eq i32* %Temp_null_79, null
br i1 %equal_null_79, label %null_deref_79, label %continue_79
null_deref_79:
call void @InvalidPointer()
br label %continue_79
continue_79:
  %Temp_229 = load i32, i32* %local_3, align 4
%Temp_i32_80 = bitcast i32* %Temp_228 to i32*
%Temp_size_ptr_80 = getelementptr inbounds i32, i32* %Temp_i32_80, i32 0
%arr_size_80 = load i32, i32* %Temp_size_ptr_80,align 4
%sub_negative_80 = icmp slt i32  %Temp_229, 0
br i1 %sub_negative_80 , label %error_idx_80, label %positive_idx_80
positive_idx_80:
%out_of_bounds_80 = icmp sge i32 %Temp_229, %arr_size_80
br i1 %out_of_bounds_80 , label %error_idx_80, label %continue_idx_80
error_idx_80:
call void @AccessViolation()
br label %continue_idx_80
continue_idx_80:
  %Temp_230 = add nsw i32 %Temp_229,1
;getlement temp temp temp;
  %Temp_231 = getelementptr inbounds i32, i32* %Temp_228, i32 %Temp_230
  %zero_76 = load i32, i32* @my_zero, align 4
  %Temp_232 = add nsw i32 %zero_76, 95
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_232, i32* %Temp_231, align 4
  %Temp_233 = load i8*, i8** %local_0, align 8
%Temp_null_81 = bitcast i8* %Temp_233 to i32*
%equal_null_81 = icmp eq i32* %Temp_null_81, null
br i1 %equal_null_81, label %null_deref_81, label %continue_81
null_deref_81:
call void @InvalidPointer()
br label %continue_81
continue_81:
  %zero_77 = load i32, i32* @my_zero, align 4
  %Temp_234 = add nsw i32 %zero_77, 28
;getlement temp temp temp;
  %Temp_235 = getelementptr inbounds i8, i8* %Temp_233, i32 %Temp_234
  %Temp_236 = bitcast i8* %Temp_235 to i32**
;load temp temp;
%Temp_init_ptr_82 = bitcast i32** %Temp_236 to i32*
%init_state_82 = load i32, i32* %Temp_init_ptr_82,align 4
%is_init_82 = icmp eq i32  %init_state_82, 0
br i1 %is_init_82 , label %error_init_82, label %good_init_82
error_init_82:
call void @InvalidPointer()
br label %good_init_82
good_init_82:
%Temp_actual_ptr_82 = getelementptr inbounds i32, i32* %Temp_init_ptr_82, i32 1
%Temp_actual_82 = bitcast i32* %Temp_actual_ptr_82 to i32**
  %Temp_237 = load i32*, i32** %Temp_actual_82 , align 8
%Temp_null_83 = bitcast i32* %Temp_237 to i32*
%equal_null_83 = icmp eq i32* %Temp_null_83, null
br i1 %equal_null_83, label %null_deref_83, label %continue_83
null_deref_83:
call void @InvalidPointer()
br label %continue_83
continue_83:
  %Temp_238 = load i32, i32* %local_4, align 4
%Temp_i32_84 = bitcast i32* %Temp_237 to i32*
%Temp_size_ptr_84 = getelementptr inbounds i32, i32* %Temp_i32_84, i32 0
%arr_size_84 = load i32, i32* %Temp_size_ptr_84,align 4
%sub_negative_84 = icmp slt i32  %Temp_238, 0
br i1 %sub_negative_84 , label %error_idx_84, label %positive_idx_84
positive_idx_84:
%out_of_bounds_84 = icmp sge i32 %Temp_238, %arr_size_84
br i1 %out_of_bounds_84 , label %error_idx_84, label %continue_idx_84
error_idx_84:
call void @AccessViolation()
br label %continue_idx_84
continue_idx_84:
  %Temp_239 = add nsw i32 %Temp_238,1
;getlement temp temp temp;
  %Temp_240 = getelementptr inbounds i32, i32* %Temp_237, i32 %Temp_239
  %zero_78 = load i32, i32* @my_zero, align 4
  %Temp_241 = add nsw i32 %zero_78, 81
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_241, i32* %Temp_240, align 4
  %Temp_242 = load i8*, i8** %local_0, align 8
%Temp_null_85 = bitcast i8* %Temp_242 to i32*
%equal_null_85 = icmp eq i32* %Temp_null_85, null
br i1 %equal_null_85, label %null_deref_85, label %continue_85
null_deref_85:
call void @InvalidPointer()
br label %continue_85
continue_85:
  %zero_79 = load i32, i32* @my_zero, align 4
  %Temp_243 = add nsw i32 %zero_79, 28
;getlement temp temp temp;
  %Temp_244 = getelementptr inbounds i8, i8* %Temp_242, i32 %Temp_243
  %Temp_245 = bitcast i8* %Temp_244 to i32**
;load temp temp;
%Temp_init_ptr_86 = bitcast i32** %Temp_245 to i32*
%init_state_86 = load i32, i32* %Temp_init_ptr_86,align 4
%is_init_86 = icmp eq i32  %init_state_86, 0
br i1 %is_init_86 , label %error_init_86, label %good_init_86
error_init_86:
call void @InvalidPointer()
br label %good_init_86
good_init_86:
%Temp_actual_ptr_86 = getelementptr inbounds i32, i32* %Temp_init_ptr_86, i32 1
%Temp_actual_86 = bitcast i32* %Temp_actual_ptr_86 to i32**
  %Temp_246 = load i32*, i32** %Temp_actual_86 , align 8
%Temp_null_87 = bitcast i32* %Temp_246 to i32*
%equal_null_87 = icmp eq i32* %Temp_null_87, null
br i1 %equal_null_87, label %null_deref_87, label %continue_87
null_deref_87:
call void @InvalidPointer()
br label %continue_87
continue_87:
  %Temp_247 = load i32, i32* %local_5, align 4
%Temp_i32_88 = bitcast i32* %Temp_246 to i32*
%Temp_size_ptr_88 = getelementptr inbounds i32, i32* %Temp_i32_88, i32 0
%arr_size_88 = load i32, i32* %Temp_size_ptr_88,align 4
%sub_negative_88 = icmp slt i32  %Temp_247, 0
br i1 %sub_negative_88 , label %error_idx_88, label %positive_idx_88
positive_idx_88:
%out_of_bounds_88 = icmp sge i32 %Temp_247, %arr_size_88
br i1 %out_of_bounds_88 , label %error_idx_88, label %continue_idx_88
error_idx_88:
call void @AccessViolation()
br label %continue_idx_88
continue_idx_88:
  %Temp_248 = add nsw i32 %Temp_247,1
;getlement temp temp temp;
  %Temp_249 = getelementptr inbounds i32, i32* %Temp_246, i32 %Temp_248
  %zero_80 = load i32, i32* @my_zero, align 4
  %Temp_250 = add nsw i32 %zero_80, 95
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_250, i32* %Temp_249, align 4
  %Temp_251 = load i8*, i8** %local_0, align 8
%Temp_null_89 = bitcast i8* %Temp_251 to i32*
%equal_null_89 = icmp eq i32* %Temp_null_89, null
br i1 %equal_null_89, label %null_deref_89, label %continue_89
null_deref_89:
call void @InvalidPointer()
br label %continue_89
continue_89:
  %zero_81 = load i32, i32* @my_zero, align 4
  %Temp_252 = add nsw i32 %zero_81, 28
;getlement temp temp temp;
  %Temp_253 = getelementptr inbounds i8, i8* %Temp_251, i32 %Temp_252
  %Temp_254 = bitcast i8* %Temp_253 to i32**
;load temp temp;
%Temp_init_ptr_90 = bitcast i32** %Temp_254 to i32*
%init_state_90 = load i32, i32* %Temp_init_ptr_90,align 4
%is_init_90 = icmp eq i32  %init_state_90, 0
br i1 %is_init_90 , label %error_init_90, label %good_init_90
error_init_90:
call void @InvalidPointer()
br label %good_init_90
good_init_90:
%Temp_actual_ptr_90 = getelementptr inbounds i32, i32* %Temp_init_ptr_90, i32 1
%Temp_actual_90 = bitcast i32* %Temp_actual_ptr_90 to i32**
  %Temp_255 = load i32*, i32** %Temp_actual_90 , align 8
%Temp_null_91 = bitcast i32* %Temp_255 to i32*
%equal_null_91 = icmp eq i32* %Temp_null_91, null
br i1 %equal_null_91, label %null_deref_91, label %continue_91
null_deref_91:
call void @InvalidPointer()
br label %continue_91
continue_91:
  %Temp_256 = load i32, i32* %local_6, align 4
%Temp_i32_92 = bitcast i32* %Temp_255 to i32*
%Temp_size_ptr_92 = getelementptr inbounds i32, i32* %Temp_i32_92, i32 0
%arr_size_92 = load i32, i32* %Temp_size_ptr_92,align 4
%sub_negative_92 = icmp slt i32  %Temp_256, 0
br i1 %sub_negative_92 , label %error_idx_92, label %positive_idx_92
positive_idx_92:
%out_of_bounds_92 = icmp sge i32 %Temp_256, %arr_size_92
br i1 %out_of_bounds_92 , label %error_idx_92, label %continue_idx_92
error_idx_92:
call void @AccessViolation()
br label %continue_idx_92
continue_idx_92:
  %Temp_257 = add nsw i32 %Temp_256,1
;getlement temp temp temp;
  %Temp_258 = getelementptr inbounds i32, i32* %Temp_255, i32 %Temp_257
  %zero_82 = load i32, i32* @my_zero, align 4
  %Temp_259 = add nsw i32 %zero_82, 95
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_259, i32* %Temp_258, align 4
  %Temp_260 = load i8*, i8** %local_0, align 8
%Temp_null_93 = bitcast i8* %Temp_260 to i32*
%equal_null_93 = icmp eq i32* %Temp_null_93, null
br i1 %equal_null_93, label %null_deref_93, label %continue_93
null_deref_93:
call void @InvalidPointer()
br label %continue_93
continue_93:
  %zero_83 = load i32, i32* @my_zero, align 4
  %Temp_261 = add nsw i32 %zero_83, 28
;getlement temp temp temp;
  %Temp_262 = getelementptr inbounds i8, i8* %Temp_260, i32 %Temp_261
  %Temp_263 = bitcast i8* %Temp_262 to i32**
;load temp temp;
%Temp_init_ptr_94 = bitcast i32** %Temp_263 to i32*
%init_state_94 = load i32, i32* %Temp_init_ptr_94,align 4
%is_init_94 = icmp eq i32  %init_state_94, 0
br i1 %is_init_94 , label %error_init_94, label %good_init_94
error_init_94:
call void @InvalidPointer()
br label %good_init_94
good_init_94:
%Temp_actual_ptr_94 = getelementptr inbounds i32, i32* %Temp_init_ptr_94, i32 1
%Temp_actual_94 = bitcast i32* %Temp_actual_ptr_94 to i32**
  %Temp_264 = load i32*, i32** %Temp_actual_94 , align 8
%Temp_null_95 = bitcast i32* %Temp_264 to i32*
%equal_null_95 = icmp eq i32* %Temp_null_95, null
br i1 %equal_null_95, label %null_deref_95, label %continue_95
null_deref_95:
call void @InvalidPointer()
br label %continue_95
continue_95:
  %Temp_265 = load i32, i32* %local_7, align 4
%Temp_i32_96 = bitcast i32* %Temp_264 to i32*
%Temp_size_ptr_96 = getelementptr inbounds i32, i32* %Temp_i32_96, i32 0
%arr_size_96 = load i32, i32* %Temp_size_ptr_96,align 4
%sub_negative_96 = icmp slt i32  %Temp_265, 0
br i1 %sub_negative_96 , label %error_idx_96, label %positive_idx_96
positive_idx_96:
%out_of_bounds_96 = icmp sge i32 %Temp_265, %arr_size_96
br i1 %out_of_bounds_96 , label %error_idx_96, label %continue_idx_96
error_idx_96:
call void @AccessViolation()
br label %continue_idx_96
continue_idx_96:
  %Temp_266 = add nsw i32 %Temp_265,1
;getlement temp temp temp;
  %Temp_267 = getelementptr inbounds i32, i32* %Temp_264, i32 %Temp_266
  %zero_84 = load i32, i32* @my_zero, align 4
  %Temp_268 = add nsw i32 %zero_84, 100
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_268, i32* %Temp_267, align 4
  %Temp_269 = load i8*, i8** %local_0, align 8
%Temp_null_97 = bitcast i8* %Temp_269 to i32*
%equal_null_97 = icmp eq i32* %Temp_null_97, null
br i1 %equal_null_97, label %null_deref_97, label %continue_97
null_deref_97:
call void @InvalidPointer()
br label %continue_97
continue_97:
  %zero_85 = load i32, i32* @my_zero, align 4
  %Temp_270 = add nsw i32 %zero_85, 28
;getlement temp temp temp;
  %Temp_271 = getelementptr inbounds i8, i8* %Temp_269, i32 %Temp_270
  %Temp_272 = bitcast i8* %Temp_271 to i32**
;load temp temp;
%Temp_init_ptr_98 = bitcast i32** %Temp_272 to i32*
%init_state_98 = load i32, i32* %Temp_init_ptr_98,align 4
%is_init_98 = icmp eq i32  %init_state_98, 0
br i1 %is_init_98 , label %error_init_98, label %good_init_98
error_init_98:
call void @InvalidPointer()
br label %good_init_98
good_init_98:
%Temp_actual_ptr_98 = getelementptr inbounds i32, i32* %Temp_init_ptr_98, i32 1
%Temp_actual_98 = bitcast i32* %Temp_actual_ptr_98 to i32**
  %Temp_273 = load i32*, i32** %Temp_actual_98 , align 8
%Temp_null_99 = bitcast i32* %Temp_273 to i32*
%equal_null_99 = icmp eq i32* %Temp_null_99, null
br i1 %equal_null_99, label %null_deref_99, label %continue_99
null_deref_99:
call void @InvalidPointer()
br label %continue_99
continue_99:
  %Temp_274 = load i32, i32* %local_8, align 4
%Temp_i32_100 = bitcast i32* %Temp_273 to i32*
%Temp_size_ptr_100 = getelementptr inbounds i32, i32* %Temp_i32_100, i32 0
%arr_size_100 = load i32, i32* %Temp_size_ptr_100,align 4
%sub_negative_100 = icmp slt i32  %Temp_274, 0
br i1 %sub_negative_100 , label %error_idx_100, label %positive_idx_100
positive_idx_100:
%out_of_bounds_100 = icmp sge i32 %Temp_274, %arr_size_100
br i1 %out_of_bounds_100 , label %error_idx_100, label %continue_idx_100
error_idx_100:
call void @AccessViolation()
br label %continue_idx_100
continue_idx_100:
  %Temp_275 = add nsw i32 %Temp_274,1
;getlement temp temp temp;
  %Temp_276 = getelementptr inbounds i32, i32* %Temp_273, i32 %Temp_275
  %zero_86 = load i32, i32* @my_zero, align 4
  %Temp_277 = add nsw i32 %zero_86, 100
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_277, i32* %Temp_276, align 4
  %Temp_278 = load i8*, i8** %local_0, align 8
%Temp_null_101 = bitcast i8* %Temp_278 to i32*
%equal_null_101 = icmp eq i32* %Temp_null_101, null
br i1 %equal_null_101, label %null_deref_101, label %continue_101
null_deref_101:
call void @InvalidPointer()
br label %continue_101
continue_101:
  %zero_87 = load i32, i32* @my_zero, align 4
  %Temp_279 = add nsw i32 %zero_87, 28
;getlement temp temp temp;
  %Temp_280 = getelementptr inbounds i8, i8* %Temp_278, i32 %Temp_279
  %Temp_281 = bitcast i8* %Temp_280 to i32**
;load temp temp;
%Temp_init_ptr_102 = bitcast i32** %Temp_281 to i32*
%init_state_102 = load i32, i32* %Temp_init_ptr_102,align 4
%is_init_102 = icmp eq i32  %init_state_102, 0
br i1 %is_init_102 , label %error_init_102, label %good_init_102
error_init_102:
call void @InvalidPointer()
br label %good_init_102
good_init_102:
%Temp_actual_ptr_102 = getelementptr inbounds i32, i32* %Temp_init_ptr_102, i32 1
%Temp_actual_102 = bitcast i32* %Temp_actual_ptr_102 to i32**
  %Temp_282 = load i32*, i32** %Temp_actual_102 , align 8
%Temp_null_103 = bitcast i32* %Temp_282 to i32*
%equal_null_103 = icmp eq i32* %Temp_null_103, null
br i1 %equal_null_103, label %null_deref_103, label %continue_103
null_deref_103:
call void @InvalidPointer()
br label %continue_103
continue_103:
  %Temp_283 = load i32, i32* %local_9, align 4
%Temp_i32_104 = bitcast i32* %Temp_282 to i32*
%Temp_size_ptr_104 = getelementptr inbounds i32, i32* %Temp_i32_104, i32 0
%arr_size_104 = load i32, i32* %Temp_size_ptr_104,align 4
%sub_negative_104 = icmp slt i32  %Temp_283, 0
br i1 %sub_negative_104 , label %error_idx_104, label %positive_idx_104
positive_idx_104:
%out_of_bounds_104 = icmp sge i32 %Temp_283, %arr_size_104
br i1 %out_of_bounds_104 , label %error_idx_104, label %continue_idx_104
error_idx_104:
call void @AccessViolation()
br label %continue_idx_104
continue_idx_104:
  %Temp_284 = add nsw i32 %Temp_283,1
;getlement temp temp temp;
  %Temp_285 = getelementptr inbounds i32, i32* %Temp_282, i32 %Temp_284
  %zero_88 = load i32, i32* @my_zero, align 4
  %Temp_286 = add nsw i32 %zero_88, 74
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_286, i32* %Temp_285, align 4
  %Temp_287 = load i8*, i8** %local_0, align 8
%Temp_null_105 = bitcast i8* %Temp_287 to i32*
%equal_null_105 = icmp eq i32* %Temp_null_105, null
br i1 %equal_null_105, label %null_deref_105, label %continue_105
null_deref_105:
call void @InvalidPointer()
br label %continue_105
continue_105:
  %zero_89 = load i32, i32* @my_zero, align 4
  %Temp_288 = add nsw i32 %zero_89, 28
;getlement temp temp temp;
  %Temp_289 = getelementptr inbounds i8, i8* %Temp_287, i32 %Temp_288
  %Temp_290 = bitcast i8* %Temp_289 to i32**
;load temp temp;
%Temp_init_ptr_106 = bitcast i32** %Temp_290 to i32*
%init_state_106 = load i32, i32* %Temp_init_ptr_106,align 4
%is_init_106 = icmp eq i32  %init_state_106, 0
br i1 %is_init_106 , label %error_init_106, label %good_init_106
error_init_106:
call void @InvalidPointer()
br label %good_init_106
good_init_106:
%Temp_actual_ptr_106 = getelementptr inbounds i32, i32* %Temp_init_ptr_106, i32 1
%Temp_actual_106 = bitcast i32* %Temp_actual_ptr_106 to i32**
  %Temp_291 = load i32*, i32** %Temp_actual_106 , align 8
%Temp_null_107 = bitcast i32* %Temp_291 to i32*
%equal_null_107 = icmp eq i32* %Temp_null_107, null
br i1 %equal_null_107, label %null_deref_107, label %continue_107
null_deref_107:
call void @InvalidPointer()
br label %continue_107
continue_107:
  %Temp_292 = load i32, i32* %local_10, align 4
%Temp_i32_108 = bitcast i32* %Temp_291 to i32*
%Temp_size_ptr_108 = getelementptr inbounds i32, i32* %Temp_i32_108, i32 0
%arr_size_108 = load i32, i32* %Temp_size_ptr_108,align 4
%sub_negative_108 = icmp slt i32  %Temp_292, 0
br i1 %sub_negative_108 , label %error_idx_108, label %positive_idx_108
positive_idx_108:
%out_of_bounds_108 = icmp sge i32 %Temp_292, %arr_size_108
br i1 %out_of_bounds_108 , label %error_idx_108, label %continue_idx_108
error_idx_108:
call void @AccessViolation()
br label %continue_idx_108
continue_idx_108:
  %Temp_293 = add nsw i32 %Temp_292,1
;getlement temp temp temp;
  %Temp_294 = getelementptr inbounds i32, i32* %Temp_291, i32 %Temp_293
  %zero_90 = load i32, i32* @my_zero, align 4
  %Temp_295 = add nsw i32 %zero_90, 99
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_295, i32* %Temp_294, align 4
  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_297 = load i8*, i8** %local_0, align 8
%Temp_298 =call i32 @getAverage(i8* %Temp_297 )
  %zero_91 = load i32, i32* @my_zero, align 4
  %Temp_299 = add nsw i32 %zero_91, 60
  %Temp_296 = icmp slt i32 %Temp_299, %Temp_298
  %Temp_300 = zext i1 %Temp_296 to i32
  %equal_zero_92 = icmp eq i32 %Temp_300, 0
  br i1 %equal_zero_92, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  %Temp_301 = load i8*, i8** %local_0, align 8
%Temp_null_109 = bitcast i8* %Temp_301 to i32*
%equal_null_109 = icmp eq i32* %Temp_null_109, null
br i1 %equal_null_109, label %null_deref_109, label %continue_109
null_deref_109:
call void @InvalidPointer()
br label %continue_109
continue_109:
  %zero_93 = load i32, i32* @my_zero, align 4
  %Temp_302 = add nsw i32 %zero_93, 0
;getlement temp temp temp;
  %Temp_303 = getelementptr inbounds i8, i8* %Temp_301, i32 %Temp_302
  %Temp_304 = bitcast i8* %Temp_303 to i32**
;load temp temp;
%Temp_init_ptr_110 = bitcast i32** %Temp_304 to i32*
%init_state_110 = load i32, i32* %Temp_init_ptr_110,align 4
%is_init_110 = icmp eq i32  %init_state_110, 0
br i1 %is_init_110 , label %error_init_110, label %good_init_110
error_init_110:
call void @InvalidPointer()
br label %good_init_110
good_init_110:
%Temp_actual_ptr_110 = getelementptr inbounds i32, i32* %Temp_init_ptr_110, i32 1
%Temp_actual_110 = bitcast i32* %Temp_actual_ptr_110 to i32**
  %Temp_305 = load i32*, i32** %Temp_actual_110 , align 8
%Temp_null_111 = bitcast i32* %Temp_305 to i32*
%equal_null_111 = icmp eq i32* %Temp_null_111, null
br i1 %equal_null_111, label %null_deref_111, label %continue_111
null_deref_111:
call void @InvalidPointer()
br label %continue_111
continue_111:
  %Temp_306 = load i8*, i8** %local_0, align 8
%Temp_null_112 = bitcast i8* %Temp_306 to i32*
%equal_null_112 = icmp eq i32* %Temp_null_112, null
br i1 %equal_null_112, label %null_deref_112, label %continue_112
null_deref_112:
call void @InvalidPointer()
br label %continue_112
continue_112:
  %zero_94 = load i32, i32* @my_zero, align 4
  %Temp_307 = add nsw i32 %zero_94, 12
;getlement temp temp temp;
  %Temp_308 = getelementptr inbounds i8, i8* %Temp_306, i32 %Temp_307
  %Temp_309 = bitcast i8* %Temp_308 to i32*
;load temp temp;
%Temp_init_ptr_113 = bitcast i32* %Temp_309 to i32*
%init_state_113 = load i32, i32* %Temp_init_ptr_113,align 4
%is_init_113 = icmp eq i32  %init_state_113, 0
br i1 %is_init_113 , label %error_init_113, label %good_init_113
error_init_113:
call void @InvalidPointer()
br label %good_init_113
good_init_113:
%Temp_actual_ptr_113 = getelementptr inbounds i32, i32* %Temp_init_ptr_113, i32 1
%Temp_actual_113 = bitcast i32* %Temp_actual_ptr_113 to i32*
  %Temp_310 = load i32, i32* %Temp_actual_113 , align 4
%Temp_i32_114 = bitcast i32* %Temp_305 to i32*
%Temp_size_ptr_114 = getelementptr inbounds i32, i32* %Temp_i32_114, i32 0
%arr_size_114 = load i32, i32* %Temp_size_ptr_114,align 4
%sub_negative_114 = icmp slt i32  %Temp_310, 0
br i1 %sub_negative_114 , label %error_idx_114, label %positive_idx_114
positive_idx_114:
%out_of_bounds_114 = icmp sge i32 %Temp_310, %arr_size_114
br i1 %out_of_bounds_114 , label %error_idx_114, label %continue_idx_114
error_idx_114:
call void @AccessViolation()
br label %continue_idx_114
continue_idx_114:
  %Temp_311 = add nsw i32 %Temp_310,1
;getlement temp temp temp;
  %Temp_312 = getelementptr inbounds i32, i32* %Temp_305, i32 %Temp_311
  %Temp_314 = load i8*, i8** %local_0, align 8
%Temp_null_115 = bitcast i8* %Temp_314 to i32*
%equal_null_115 = icmp eq i32* %Temp_null_115, null
br i1 %equal_null_115, label %null_deref_115, label %continue_115
null_deref_115:
call void @InvalidPointer()
br label %continue_115
continue_115:
  %zero_95 = load i32, i32* @my_zero, align 4
  %Temp_315 = add nsw i32 %zero_95, 0
;getlement temp temp temp;
  %Temp_316 = getelementptr inbounds i8, i8* %Temp_314, i32 %Temp_315
  %Temp_317 = bitcast i8* %Temp_316 to i32**
;load temp temp;
%Temp_init_ptr_116 = bitcast i32** %Temp_317 to i32*
%init_state_116 = load i32, i32* %Temp_init_ptr_116,align 4
%is_init_116 = icmp eq i32  %init_state_116, 0
br i1 %is_init_116 , label %error_init_116, label %good_init_116
error_init_116:
call void @InvalidPointer()
br label %good_init_116
good_init_116:
%Temp_actual_ptr_116 = getelementptr inbounds i32, i32* %Temp_init_ptr_116, i32 1
%Temp_actual_116 = bitcast i32* %Temp_actual_ptr_116 to i32**
  %Temp_318 = load i32*, i32** %Temp_actual_116 , align 8
%Temp_null_117 = bitcast i32* %Temp_318 to i32*
%equal_null_117 = icmp eq i32* %Temp_null_117, null
br i1 %equal_null_117, label %null_deref_117, label %continue_117
null_deref_117:
call void @InvalidPointer()
br label %continue_117
continue_117:
  %Temp_319 = load i8*, i8** %local_0, align 8
%Temp_320 =call i32 @birthday(i8* %Temp_319 )
%Temp_i32_118 = bitcast i32* %Temp_318 to i32*
%Temp_size_ptr_118 = getelementptr inbounds i32, i32* %Temp_i32_118, i32 0
%arr_size_118 = load i32, i32* %Temp_size_ptr_118,align 4
%sub_negative_118 = icmp slt i32  %Temp_320, 0
br i1 %sub_negative_118 , label %error_idx_118, label %positive_idx_118
positive_idx_118:
%out_of_bounds_118 = icmp sge i32 %Temp_320, %arr_size_118
br i1 %out_of_bounds_118 , label %error_idx_118, label %continue_idx_118
error_idx_118:
call void @AccessViolation()
br label %continue_idx_118
continue_idx_118:
  %Temp_321 = add nsw i32 %Temp_320,1
;getlement temp temp temp;
  %Temp_322 = getelementptr inbounds i32, i32* %Temp_318, i32 %Temp_321
  %zero_96 = load i32, i32* @my_zero, align 4
  %Temp_323 = add nsw i32 %zero_96, 1000
;load temp temp;
  %Temp_324 = load i32, i32* %Temp_322, align 4
  %Temp_313 = add nsw i32 %Temp_324, %Temp_323
%Temp_325 = call i32 @CheckOverflow(i32 %Temp_313)
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_325, i32* %Temp_312, align 4
  %Temp_326 = load i8*, i8** %local_0, align 8
%Temp_null_119 = bitcast i8* %Temp_326 to i32*
%equal_null_119 = icmp eq i32* %Temp_null_119, null
br i1 %equal_null_119, label %null_deref_119, label %continue_119
null_deref_119:
call void @InvalidPointer()
br label %continue_119
continue_119:
  %zero_97 = load i32, i32* @my_zero, align 4
  %Temp_327 = add nsw i32 %zero_97, 0
;getlement temp temp temp;
  %Temp_328 = getelementptr inbounds i8, i8* %Temp_326, i32 %Temp_327
  %Temp_329 = bitcast i8* %Temp_328 to i32**
;load temp temp;
%Temp_init_ptr_120 = bitcast i32** %Temp_329 to i32*
%init_state_120 = load i32, i32* %Temp_init_ptr_120,align 4
%is_init_120 = icmp eq i32  %init_state_120, 0
br i1 %is_init_120 , label %error_init_120, label %good_init_120
error_init_120:
call void @InvalidPointer()
br label %good_init_120
good_init_120:
%Temp_actual_ptr_120 = getelementptr inbounds i32, i32* %Temp_init_ptr_120, i32 1
%Temp_actual_120 = bitcast i32* %Temp_actual_ptr_120 to i32**
  %Temp_330 = load i32*, i32** %Temp_actual_120 , align 8
%Temp_null_121 = bitcast i32* %Temp_330 to i32*
%equal_null_121 = icmp eq i32* %Temp_null_121, null
br i1 %equal_null_121, label %null_deref_121, label %continue_121
null_deref_121:
call void @InvalidPointer()
br label %continue_121
continue_121:
  %Temp_331 = load i8*, i8** %local_0, align 8
%Temp_null_122 = bitcast i8* %Temp_331 to i32*
%equal_null_122 = icmp eq i32* %Temp_null_122, null
br i1 %equal_null_122, label %null_deref_122, label %continue_122
null_deref_122:
call void @InvalidPointer()
br label %continue_122
continue_122:
  %zero_98 = load i32, i32* @my_zero, align 4
  %Temp_332 = add nsw i32 %zero_98, 12
;getlement temp temp temp;
  %Temp_333 = getelementptr inbounds i8, i8* %Temp_331, i32 %Temp_332
  %Temp_334 = bitcast i8* %Temp_333 to i32*
;load temp temp;
%Temp_init_ptr_123 = bitcast i32* %Temp_334 to i32*
%init_state_123 = load i32, i32* %Temp_init_ptr_123,align 4
%is_init_123 = icmp eq i32  %init_state_123, 0
br i1 %is_init_123 , label %error_init_123, label %good_init_123
error_init_123:
call void @InvalidPointer()
br label %good_init_123
good_init_123:
%Temp_actual_ptr_123 = getelementptr inbounds i32, i32* %Temp_init_ptr_123, i32 1
%Temp_actual_123 = bitcast i32* %Temp_actual_ptr_123 to i32*
  %Temp_335 = load i32, i32* %Temp_actual_123 , align 4
%Temp_i32_124 = bitcast i32* %Temp_330 to i32*
%Temp_size_ptr_124 = getelementptr inbounds i32, i32* %Temp_i32_124, i32 0
%arr_size_124 = load i32, i32* %Temp_size_ptr_124,align 4
%sub_negative_124 = icmp slt i32  %Temp_335, 0
br i1 %sub_negative_124 , label %error_idx_124, label %positive_idx_124
positive_idx_124:
%out_of_bounds_124 = icmp sge i32 %Temp_335, %arr_size_124
br i1 %out_of_bounds_124 , label %error_idx_124, label %continue_idx_124
error_idx_124:
call void @AccessViolation()
br label %continue_idx_124
continue_idx_124:
  %Temp_336 = add nsw i32 %Temp_335,1
;getlement temp temp temp;
  %Temp_337 = getelementptr inbounds i32, i32* %Temp_330, i32 %Temp_336
  %Temp_339 = load i8*, i8** %local_0, align 8
%Temp_null_125 = bitcast i8* %Temp_339 to i32*
%equal_null_125 = icmp eq i32* %Temp_null_125, null
br i1 %equal_null_125, label %null_deref_125, label %continue_125
null_deref_125:
call void @InvalidPointer()
br label %continue_125
continue_125:
  %zero_99 = load i32, i32* @my_zero, align 4
  %Temp_340 = add nsw i32 %zero_99, 0
;getlement temp temp temp;
  %Temp_341 = getelementptr inbounds i8, i8* %Temp_339, i32 %Temp_340
  %Temp_342 = bitcast i8* %Temp_341 to i32**
;load temp temp;
%Temp_init_ptr_126 = bitcast i32** %Temp_342 to i32*
%init_state_126 = load i32, i32* %Temp_init_ptr_126,align 4
%is_init_126 = icmp eq i32  %init_state_126, 0
br i1 %is_init_126 , label %error_init_126, label %good_init_126
error_init_126:
call void @InvalidPointer()
br label %good_init_126
good_init_126:
%Temp_actual_ptr_126 = getelementptr inbounds i32, i32* %Temp_init_ptr_126, i32 1
%Temp_actual_126 = bitcast i32* %Temp_actual_ptr_126 to i32**
  %Temp_343 = load i32*, i32** %Temp_actual_126 , align 8
%Temp_null_127 = bitcast i32* %Temp_343 to i32*
%equal_null_127 = icmp eq i32* %Temp_null_127, null
br i1 %equal_null_127, label %null_deref_127, label %continue_127
null_deref_127:
call void @InvalidPointer()
br label %continue_127
continue_127:
  %Temp_344 = load i8*, i8** %local_0, align 8
%Temp_345 =call i32 @birthday(i8* %Temp_344 )
%Temp_i32_128 = bitcast i32* %Temp_343 to i32*
%Temp_size_ptr_128 = getelementptr inbounds i32, i32* %Temp_i32_128, i32 0
%arr_size_128 = load i32, i32* %Temp_size_ptr_128,align 4
%sub_negative_128 = icmp slt i32  %Temp_345, 0
br i1 %sub_negative_128 , label %error_idx_128, label %positive_idx_128
positive_idx_128:
%out_of_bounds_128 = icmp sge i32 %Temp_345, %arr_size_128
br i1 %out_of_bounds_128 , label %error_idx_128, label %continue_idx_128
error_idx_128:
call void @AccessViolation()
br label %continue_idx_128
continue_idx_128:
  %Temp_346 = add nsw i32 %Temp_345,1
;getlement temp temp temp;
  %Temp_347 = getelementptr inbounds i32, i32* %Temp_343, i32 %Temp_346
  %zero_100 = load i32, i32* @my_zero, align 4
  %Temp_348 = add nsw i32 %zero_100, 1000
;load temp temp;
  %Temp_349 = load i32, i32* %Temp_347, align 4
  %Temp_338 = add nsw i32 %Temp_349, %Temp_348
%Temp_350 = call i32 @CheckOverflow(i32 %Temp_338)
;store TYPES.TYPE_INT@728938a9 dst src;
  store i32 %Temp_350, i32* %Temp_337, align 4
  %Temp_351 = load i8*, i8** %local_0, align 8
%Temp_null_129 = bitcast i8* %Temp_351 to i32*
%equal_null_129 = icmp eq i32* %Temp_null_129, null
br i1 %equal_null_129, label %null_deref_129, label %continue_129
null_deref_129:
call void @InvalidPointer()
br label %continue_129
continue_129:
  %zero_101 = load i32, i32* @my_zero, align 4
  %Temp_352 = add nsw i32 %zero_101, 0
;getlement temp temp temp;
  %Temp_353 = getelementptr inbounds i8, i8* %Temp_351, i32 %Temp_352
  %Temp_354 = bitcast i8* %Temp_353 to i32**
;load temp temp;
%Temp_init_ptr_130 = bitcast i32** %Temp_354 to i32*
%init_state_130 = load i32, i32* %Temp_init_ptr_130,align 4
%is_init_130 = icmp eq i32  %init_state_130, 0
br i1 %is_init_130 , label %error_init_130, label %good_init_130
error_init_130:
call void @InvalidPointer()
br label %good_init_130
good_init_130:
%Temp_actual_ptr_130 = getelementptr inbounds i32, i32* %Temp_init_ptr_130, i32 1
%Temp_actual_130 = bitcast i32* %Temp_actual_ptr_130 to i32**
  %Temp_355 = load i32*, i32** %Temp_actual_130 , align 8
%Temp_null_131 = bitcast i32* %Temp_355 to i32*
%equal_null_131 = icmp eq i32* %Temp_null_131, null
br i1 %equal_null_131, label %null_deref_131, label %continue_131
null_deref_131:
call void @InvalidPointer()
br label %continue_131
continue_131:
  %zero_102 = load i32, i32* @my_zero, align 4
  %Temp_356 = add nsw i32 %zero_102, 10
%Temp_i32_132 = bitcast i32* %Temp_355 to i32*
%Temp_size_ptr_132 = getelementptr inbounds i32, i32* %Temp_i32_132, i32 0
%arr_size_132 = load i32, i32* %Temp_size_ptr_132,align 4
%sub_negative_132 = icmp slt i32  %Temp_356, 0
br i1 %sub_negative_132 , label %error_idx_132, label %positive_idx_132
positive_idx_132:
%out_of_bounds_132 = icmp sge i32 %Temp_356, %arr_size_132
br i1 %out_of_bounds_132 , label %error_idx_132, label %continue_idx_132
error_idx_132:
call void @AccessViolation()
br label %continue_idx_132
continue_idx_132:
  %Temp_357 = add nsw i32 %Temp_356,1
;getlement temp temp temp;
  %Temp_358 = getelementptr inbounds i32, i32* %Temp_355, i32 %Temp_357
;load temp temp;
  %Temp_359 = load i32, i32* %Temp_358, align 4
  call void @PrintInt(i32 %Temp_359 )
  %Temp_360 = load i8*, i8** %local_0, align 8
%Temp_null_133 = bitcast i8* %Temp_360 to i32*
%equal_null_133 = icmp eq i32* %Temp_null_133, null
br i1 %equal_null_133, label %null_deref_133, label %continue_133
null_deref_133:
call void @InvalidPointer()
br label %continue_133
continue_133:
  %zero_103 = load i32, i32* @my_zero, align 4
  %Temp_361 = add nsw i32 %zero_103, 0
;getlement temp temp temp;
  %Temp_362 = getelementptr inbounds i8, i8* %Temp_360, i32 %Temp_361
  %Temp_363 = bitcast i8* %Temp_362 to i32**
;load temp temp;
%Temp_init_ptr_134 = bitcast i32** %Temp_363 to i32*
%init_state_134 = load i32, i32* %Temp_init_ptr_134,align 4
%is_init_134 = icmp eq i32  %init_state_134, 0
br i1 %is_init_134 , label %error_init_134, label %good_init_134
error_init_134:
call void @InvalidPointer()
br label %good_init_134
good_init_134:
%Temp_actual_ptr_134 = getelementptr inbounds i32, i32* %Temp_init_ptr_134, i32 1
%Temp_actual_134 = bitcast i32* %Temp_actual_ptr_134 to i32**
  %Temp_364 = load i32*, i32** %Temp_actual_134 , align 8
%Temp_null_135 = bitcast i32* %Temp_364 to i32*
%equal_null_135 = icmp eq i32* %Temp_null_135, null
br i1 %equal_null_135, label %null_deref_135, label %continue_135
null_deref_135:
call void @InvalidPointer()
br label %continue_135
continue_135:
  %zero_104 = load i32, i32* @my_zero, align 4
  %Temp_365 = add nsw i32 %zero_104, 11
%Temp_i32_136 = bitcast i32* %Temp_364 to i32*
%Temp_size_ptr_136 = getelementptr inbounds i32, i32* %Temp_i32_136, i32 0
%arr_size_136 = load i32, i32* %Temp_size_ptr_136,align 4
%sub_negative_136 = icmp slt i32  %Temp_365, 0
br i1 %sub_negative_136 , label %error_idx_136, label %positive_idx_136
positive_idx_136:
%out_of_bounds_136 = icmp sge i32 %Temp_365, %arr_size_136
br i1 %out_of_bounds_136 , label %error_idx_136, label %continue_idx_136
error_idx_136:
call void @AccessViolation()
br label %continue_idx_136
continue_idx_136:
  %Temp_366 = add nsw i32 %Temp_365,1
;getlement temp temp temp;
  %Temp_367 = getelementptr inbounds i32, i32* %Temp_364, i32 %Temp_366
;load temp temp;
  %Temp_368 = load i32, i32* %Temp_367, align 4
  call void @PrintInt(i32 %Temp_368 )
  br label %Label_5_if.exit

Label_5_if.exit:

call void @exit(i32 0)
  ret void
}
