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

define i32 @getAge(i8*)
 { 
  %p = alloca i8*, align 8
  store i8* %0, i8** %p, align 8
  %Temp_0 = load i8*, i8** %p, align 8
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
  %Temp_3 = bitcast i8* %Temp_2 to i32*
;load temp temp;
%Temp_init_ptr_1 = bitcast i32* %Temp_3 to i32*
%init_state_1 = load i32, i32* %Temp_init_ptr_1,align 4
%is_init_1 = icmp eq i32  %init_state_1, 0
br i1 %is_init_1 , label %error_init_1, label %good_init_1
error_init_1:
call void @InvalidPointer()
br label %good_init_1
good_init_1:
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  %Temp_4 = load i32, i32* %Temp_actual_1 , align 4
  ret i32 %Temp_4
}
define i32 @birthday(i8*)
 { 
  %p = alloca i8*, align 8
  store i8* %0, i8** %p, align 8
  %Temp_5 = load i8*, i8** %p, align 8
%Temp_null_2 = bitcast i8* %Temp_5 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_1, 12
;getlement temp temp temp;
  %Temp_7 = getelementptr inbounds i8, i8* %Temp_5, i32 %Temp_6
  %Temp_8 = bitcast i8* %Temp_7 to i32*
  %Temp_10 = load i8*, i8** %p, align 8
%Temp_null_3 = bitcast i8* %Temp_10 to i32*
%equal_null_3 = icmp eq i32* %Temp_null_3, null
br i1 %equal_null_3, label %null_deref_3, label %continue_3
null_deref_3:
call void @InvalidPointer()
br label %continue_3
continue_3:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_2, 12
;getlement temp temp temp;
  %Temp_12 = getelementptr inbounds i8, i8* %Temp_10, i32 %Temp_11
  %Temp_13 = bitcast i8* %Temp_12 to i32*
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_3, 1
;load temp temp;
%Temp_init_ptr_4 = bitcast i32* %Temp_13 to i32*
%init_state_4 = load i32, i32* %Temp_init_ptr_4,align 4
%is_init_4 = icmp eq i32  %init_state_4, 0
br i1 %is_init_4 , label %error_init_4, label %good_init_4
error_init_4:
call void @InvalidPointer()
br label %good_init_4
good_init_4:
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  %Temp_15 = load i32, i32* %Temp_actual_4 , align 4
  %Temp_9 = add nsw i32 %Temp_15, %Temp_14
%Temp_16 = call i32 @CheckOverflow(i32 %Temp_9)
;store TYPES.TYPE_INT@5197848c dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_8 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_16, i32* %Temp_actual_5, align 4
  %Temp_17 = load i8*, i8** %p, align 8
%Temp_null_6 = bitcast i8* %Temp_17 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_4, 12
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_17, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i32*
;load temp temp;
%Temp_init_ptr_7 = bitcast i32* %Temp_20 to i32*
%init_state_7 = load i32, i32* %Temp_init_ptr_7,align 4
%is_init_7 = icmp eq i32  %init_state_7, 0
br i1 %is_init_7 , label %error_init_7, label %good_init_7
error_init_7:
call void @InvalidPointer()
br label %good_init_7
good_init_7:
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  %Temp_21 = load i32, i32* %Temp_actual_7 , align 4
  ret i32 %Temp_21
}
define i32 @getAverage(i8*)
 { 
  %s = alloca i8*, align 8
  %local_1 = alloca i32, align 4
  %local_0 = alloca i32, align 4
  store i8* %0, i8** %s, align 8
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_5, 0
  store i32 %Temp_22, i32* %local_0, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_6, 0
  store i32 %Temp_23, i32* %local_1, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_25 = load i32, i32* %local_0, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_7, 10
  %Temp_24 = icmp slt i32 %Temp_25, %Temp_26
  %Temp_27 = zext i1 %Temp_24 to i32
  %equal_zero_8 = icmp eq i32 %Temp_27, 0
  br i1 %equal_zero_8, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_29 = load i32, i32* %local_1, align 4
  %Temp_30 = load i8*, i8** %s, align 8
%Temp_null_8 = bitcast i8* %Temp_30 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_9, 28
;getlement temp temp temp;
  %Temp_32 = getelementptr inbounds i8, i8* %Temp_30, i32 %Temp_31
  %Temp_33 = bitcast i8* %Temp_32 to i32**
;load temp temp;
%Temp_init_ptr_9 = bitcast i32** %Temp_33 to i32*
%init_state_9 = load i32, i32* %Temp_init_ptr_9,align 4
%is_init_9 = icmp eq i32  %init_state_9, 0
br i1 %is_init_9 , label %error_init_9, label %good_init_9
error_init_9:
call void @InvalidPointer()
br label %good_init_9
good_init_9:
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32**
  %Temp_34 = load i32*, i32** %Temp_actual_9 , align 8
%Temp_null_10 = bitcast i32* %Temp_34 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %Temp_35 = load i32, i32* %local_0, align 4
%Temp_i32_11 = bitcast i32* %Temp_34 to i32*
%Temp_size_ptr_11 = getelementptr inbounds i32, i32* %Temp_i32_11, i32 0
%arr_size_11 = load i32, i32* %Temp_size_ptr_11,align 4
%sub_negative_11 = icmp slt i32  %Temp_35, 0
br i1 %sub_negative_11 , label %error_idx_11, label %positive_idx_11
positive_idx_11:
%out_of_bounds_11 = icmp sge i32 %Temp_35, %arr_size_11
br i1 %out_of_bounds_11 , label %error_idx_11, label %continue_idx_11
error_idx_11:
call void @AccessViolation()
br label %continue_idx_11
continue_idx_11:
  %Temp_36 = add nsw i32 %Temp_35,1
;getlement temp temp temp;
  %Temp_37 = getelementptr inbounds i32, i32* %Temp_34, i32 %Temp_36
;load temp temp;
  %Temp_38 = load i32, i32* %Temp_37, align 4
  %Temp_28 = add nsw i32 %Temp_29, %Temp_38
%Temp_39 = call i32 @CheckOverflow(i32 %Temp_28)
  store i32 %Temp_39, i32* %local_1, align 4
  %Temp_41 = load i32, i32* %local_0, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_10, 1
  %Temp_40 = add nsw i32 %Temp_41, %Temp_42
%Temp_43 = call i32 @CheckOverflow(i32 %Temp_40)
  store i32 %Temp_43, i32* %local_0, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %Temp_45 = load i32, i32* %local_1, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_11, 10
%is_div_zero_0 = icmp eq i32  %Temp_46, 0
br i1 %is_div_zero_0 , label %div_by_zero_0, label %good_div_0
div_by_zero_0:
call void @DivideByZero()
br label %good_div_0
good_div_0:
  %Temp_44 = sdiv i32 %Temp_45, %Temp_46
%Temp_47 = call i32 @CheckOverflow(i32 %Temp_44)
  ret i32 %Temp_47
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8*, align 8
  %local_1 = alloca i32, align 4
  %local_2 = alloca i8**, align 8
  call void @init_globals()
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_49 = add nsw i32 %zero_12, 40
  %Temp_50 = call i32* @malloc(i32 %Temp_49)
  %Temp_48 = bitcast i32* %Temp_50 to i8*
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_13, 12
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8, i8* %Temp_48, i32 %Temp_51
  %Temp_53 = bitcast i8* %Temp_52 to i32*
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_14, 18
;store TYPES.TYPE_INT@5197848c dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_53 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_54, i32* %Temp_actual_12, align 4
  store i8* %Temp_48, i8** %local_0, align 8
  %Temp_55 = load i8*, i8** %local_0, align 8
%Temp_null_13 = bitcast i8* %Temp_55 to i32*
%equal_null_13 = icmp eq i32* %Temp_null_13, null
br i1 %equal_null_13, label %null_deref_13, label %continue_13
null_deref_13:
call void @InvalidPointer()
br label %continue_13
continue_13:
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_15, 28
;getlement temp temp temp;
  %Temp_57 = getelementptr inbounds i8, i8* %Temp_55, i32 %Temp_56
  %Temp_58 = bitcast i8* %Temp_57 to i32**
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_60 = add nsw i32 %zero_16, 10
  %Temp_61 = add nsw i32 %Temp_60,1
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_17, 8
  %Temp_63 = mul nsw i32 %Temp_61, %Temp_62
  %Temp_64 = call i32* @malloc(i32 %Temp_63)
  %Temp_59 = bitcast i32* %Temp_64 to i32*
  %Temp_65 = getelementptr inbounds i32, i32* %Temp_64, i32 0
;store TYPES.TYPE_INT@5197848c dst src;
  store i32 %Temp_60, i32* %Temp_65, align 4
;store TYPES.TYPE_ARRAY@17f052a3 dst src;
%Temp_init_ptr_14 = bitcast i32** %Temp_58 to i32*
store i32 1, i32* %Temp_init_ptr_14,align 4
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32**
  store i32* %Temp_59, i32** %Temp_actual_14, align 8
  %Temp_66 = load i8*, i8** %local_0, align 8
%Temp_null_15 = bitcast i8* %Temp_66 to i32*
%equal_null_15 = icmp eq i32* %Temp_null_15, null
br i1 %equal_null_15, label %null_deref_15, label %continue_15
null_deref_15:
call void @InvalidPointer()
br label %continue_15
continue_15:
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_67 = add nsw i32 %zero_18, 0
;getlement temp temp temp;
  %Temp_68 = getelementptr inbounds i8, i8* %Temp_66, i32 %Temp_67
  %Temp_69 = bitcast i8* %Temp_68 to i32**
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_19, 12
  %Temp_72 = add nsw i32 %Temp_71,1
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_73 = add nsw i32 %zero_20, 8
  %Temp_74 = mul nsw i32 %Temp_72, %Temp_73
  %Temp_75 = call i32* @malloc(i32 %Temp_74)
  %Temp_70 = bitcast i32* %Temp_75 to i32*
  %Temp_76 = getelementptr inbounds i32, i32* %Temp_75, i32 0
;store TYPES.TYPE_INT@5197848c dst src;
  store i32 %Temp_71, i32* %Temp_76, align 4
;store TYPES.TYPE_ARRAY@17f052a3 dst src;
%Temp_init_ptr_16 = bitcast i32** %Temp_69 to i32*
store i32 1, i32* %Temp_init_ptr_16,align 4
%Temp_actual_ptr_16 = getelementptr inbounds i32, i32* %Temp_init_ptr_16, i32 1
%Temp_actual_16 = bitcast i32* %Temp_actual_ptr_16 to i32**
  store i32* %Temp_70, i32** %Temp_actual_16, align 8
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_77 = add nsw i32 %zero_21, 6
  store i32 %Temp_77, i32* %local_1, align 4
  %Temp_78 = load i8*, i8** %local_0, align 8
%Temp_null_17 = bitcast i8* %Temp_78 to i32*
%equal_null_17 = icmp eq i32* %Temp_null_17, null
br i1 %equal_null_17, label %null_deref_17, label %continue_17
null_deref_17:
call void @InvalidPointer()
br label %continue_17
continue_17:
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_79 = add nsw i32 %zero_22, 28
;getlement temp temp temp;
  %Temp_80 = getelementptr inbounds i8, i8* %Temp_78, i32 %Temp_79
  %Temp_81 = bitcast i8* %Temp_80 to i32**
;load temp temp;
%Temp_init_ptr_18 = bitcast i32** %Temp_81 to i32*
%init_state_18 = load i32, i32* %Temp_init_ptr_18,align 4
%is_init_18 = icmp eq i32  %init_state_18, 0
br i1 %is_init_18 , label %error_init_18, label %good_init_18
error_init_18:
call void @InvalidPointer()
br label %good_init_18
good_init_18:
%Temp_actual_ptr_18 = getelementptr inbounds i32, i32* %Temp_init_ptr_18, i32 1
%Temp_actual_18 = bitcast i32* %Temp_actual_ptr_18 to i32**
  %Temp_82 = load i32*, i32** %Temp_actual_18 , align 8
%Temp_null_19 = bitcast i32* %Temp_82 to i32*
%equal_null_19 = icmp eq i32* %Temp_null_19, null
br i1 %equal_null_19, label %null_deref_19, label %continue_19
null_deref_19:
call void @InvalidPointer()
br label %continue_19
continue_19:
  %Temp_83 = load i32, i32* %local_1, align 4
%Temp_i32_20 = bitcast i32* %Temp_82 to i32*
%Temp_size_ptr_20 = getelementptr inbounds i32, i32* %Temp_i32_20, i32 0
%arr_size_20 = load i32, i32* %Temp_size_ptr_20,align 4
%sub_negative_20 = icmp slt i32  %Temp_83, 0
br i1 %sub_negative_20 , label %error_idx_20, label %positive_idx_20
positive_idx_20:
%out_of_bounds_20 = icmp sge i32 %Temp_83, %arr_size_20
br i1 %out_of_bounds_20 , label %error_idx_20, label %continue_idx_20
error_idx_20:
call void @AccessViolation()
br label %continue_idx_20
continue_idx_20:
  %Temp_84 = add nsw i32 %Temp_83,1
;getlement temp temp temp;
  %Temp_85 = getelementptr inbounds i32, i32* %Temp_82, i32 %Temp_84
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_23, 99
;store TYPES.TYPE_INT@5197848c dst src;
  store i32 %Temp_86, i32* %Temp_85, align 4
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_88 = add nsw i32 %zero_24, 37
  %Temp_89 = add nsw i32 %Temp_88,1
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_90 = add nsw i32 %zero_25, 8
  %Temp_91 = mul nsw i32 %Temp_89, %Temp_90
  %Temp_92 = call i32* @malloc(i32 %Temp_91)
  %Temp_87 = bitcast i32* %Temp_92 to i8**
  %Temp_93 = getelementptr inbounds i32, i32* %Temp_92, i32 0
;store TYPES.TYPE_INT@5197848c dst src;
  store i32 %Temp_88, i32* %Temp_93, align 4
  store i8** %Temp_87, i8*** %local_2, align 8
  %Temp_94 = load i8**, i8*** %local_2, align 8
%Temp_null_21 = bitcast i8** %Temp_94 to i32*
%equal_null_21 = icmp eq i32* %Temp_null_21, null
br i1 %equal_null_21, label %null_deref_21, label %continue_21
null_deref_21:
call void @InvalidPointer()
br label %continue_21
continue_21:
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_26, 3
%Temp_i32_22 = bitcast i8** %Temp_94 to i32*
%Temp_size_ptr_22 = getelementptr inbounds i32, i32* %Temp_i32_22, i32 0
%arr_size_22 = load i32, i32* %Temp_size_ptr_22,align 4
%sub_negative_22 = icmp slt i32  %Temp_95, 0
br i1 %sub_negative_22 , label %error_idx_22, label %positive_idx_22
positive_idx_22:
%out_of_bounds_22 = icmp sge i32 %Temp_95, %arr_size_22
br i1 %out_of_bounds_22 , label %error_idx_22, label %continue_idx_22
error_idx_22:
call void @AccessViolation()
br label %continue_idx_22
continue_idx_22:
  %Temp_96 = add nsw i32 %Temp_95,1
;getlement temp temp temp;
  %Temp_97 = getelementptr inbounds i8*, i8** %Temp_94, i32 %Temp_96
  %Temp_98 = load i8*, i8** %local_0, align 8
;store TYPES.TYPE_CLASS@2e0fa5d3 dst src;
  store i8* %Temp_98, i8** %Temp_97, align 8
  %Temp_99 = load i8**, i8*** %local_2, align 8
%Temp_null_23 = bitcast i8** %Temp_99 to i32*
%equal_null_23 = icmp eq i32* %Temp_null_23, null
br i1 %equal_null_23, label %null_deref_23, label %continue_23
null_deref_23:
call void @InvalidPointer()
br label %continue_23
continue_23:
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_100 = add nsw i32 %zero_27, 3
%Temp_i32_24 = bitcast i8** %Temp_99 to i32*
%Temp_size_ptr_24 = getelementptr inbounds i32, i32* %Temp_i32_24, i32 0
%arr_size_24 = load i32, i32* %Temp_size_ptr_24,align 4
%sub_negative_24 = icmp slt i32  %Temp_100, 0
br i1 %sub_negative_24 , label %error_idx_24, label %positive_idx_24
positive_idx_24:
%out_of_bounds_24 = icmp sge i32 %Temp_100, %arr_size_24
br i1 %out_of_bounds_24 , label %error_idx_24, label %continue_idx_24
error_idx_24:
call void @AccessViolation()
br label %continue_idx_24
continue_idx_24:
  %Temp_101 = add nsw i32 %Temp_100,1
;getlement temp temp temp;
  %Temp_102 = getelementptr inbounds i8*, i8** %Temp_99, i32 %Temp_101
;load temp temp;
  %Temp_103 = load i8*, i8** %Temp_102, align 8
%Temp_null_25 = bitcast i8* %Temp_103 to i32*
%equal_null_25 = icmp eq i32* %Temp_null_25, null
br i1 %equal_null_25, label %null_deref_25, label %continue_25
null_deref_25:
call void @InvalidPointer()
br label %continue_25
continue_25:
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_104 = add nsw i32 %zero_28, 0
;getlement temp temp temp;
  %Temp_105 = getelementptr inbounds i8, i8* %Temp_103, i32 %Temp_104
  %Temp_106 = bitcast i8* %Temp_105 to i32**
;load temp temp;
%Temp_init_ptr_26 = bitcast i32** %Temp_106 to i32*
%init_state_26 = load i32, i32* %Temp_init_ptr_26,align 4
%is_init_26 = icmp eq i32  %init_state_26, 0
br i1 %is_init_26 , label %error_init_26, label %good_init_26
error_init_26:
call void @InvalidPointer()
br label %good_init_26
good_init_26:
%Temp_actual_ptr_26 = getelementptr inbounds i32, i32* %Temp_init_ptr_26, i32 1
%Temp_actual_26 = bitcast i32* %Temp_actual_ptr_26 to i32**
  %Temp_107 = load i32*, i32** %Temp_actual_26 , align 8
%Temp_null_27 = bitcast i32* %Temp_107 to i32*
%equal_null_27 = icmp eq i32* %Temp_null_27, null
br i1 %equal_null_27, label %null_deref_27, label %continue_27
null_deref_27:
call void @InvalidPointer()
br label %continue_27
continue_27:
  %Temp_108 = load i8**, i8*** %local_2, align 8
%Temp_null_28 = bitcast i8** %Temp_108 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_109 = add nsw i32 %zero_29, 3
%Temp_i32_29 = bitcast i8** %Temp_108 to i32*
%Temp_size_ptr_29 = getelementptr inbounds i32, i32* %Temp_i32_29, i32 0
%arr_size_29 = load i32, i32* %Temp_size_ptr_29,align 4
%sub_negative_29 = icmp slt i32  %Temp_109, 0
br i1 %sub_negative_29 , label %error_idx_29, label %positive_idx_29
positive_idx_29:
%out_of_bounds_29 = icmp sge i32 %Temp_109, %arr_size_29
br i1 %out_of_bounds_29 , label %error_idx_29, label %continue_idx_29
error_idx_29:
call void @AccessViolation()
br label %continue_idx_29
continue_idx_29:
  %Temp_110 = add nsw i32 %Temp_109,1
;getlement temp temp temp;
  %Temp_111 = getelementptr inbounds i8*, i8** %Temp_108, i32 %Temp_110
;load temp temp;
  %Temp_112 = load i8*, i8** %Temp_111, align 8
%Temp_null_30 = bitcast i8* %Temp_112 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_113 = add nsw i32 %zero_30, 28
;getlement temp temp temp;
  %Temp_114 = getelementptr inbounds i8, i8* %Temp_112, i32 %Temp_113
  %Temp_115 = bitcast i8* %Temp_114 to i32**
;load temp temp;
%Temp_init_ptr_31 = bitcast i32** %Temp_115 to i32*
%init_state_31 = load i32, i32* %Temp_init_ptr_31,align 4
%is_init_31 = icmp eq i32  %init_state_31, 0
br i1 %is_init_31 , label %error_init_31, label %good_init_31
error_init_31:
call void @InvalidPointer()
br label %good_init_31
good_init_31:
%Temp_actual_ptr_31 = getelementptr inbounds i32, i32* %Temp_init_ptr_31, i32 1
%Temp_actual_31 = bitcast i32* %Temp_actual_ptr_31 to i32**
  %Temp_116 = load i32*, i32** %Temp_actual_31 , align 8
%Temp_null_32 = bitcast i32* %Temp_116 to i32*
%equal_null_32 = icmp eq i32* %Temp_null_32, null
br i1 %equal_null_32, label %null_deref_32, label %continue_32
null_deref_32:
call void @InvalidPointer()
br label %continue_32
continue_32:
  %Temp_117 = load i32, i32* %local_1, align 4
%Temp_i32_33 = bitcast i32* %Temp_116 to i32*
%Temp_size_ptr_33 = getelementptr inbounds i32, i32* %Temp_i32_33, i32 0
%arr_size_33 = load i32, i32* %Temp_size_ptr_33,align 4
%sub_negative_33 = icmp slt i32  %Temp_117, 0
br i1 %sub_negative_33 , label %error_idx_33, label %positive_idx_33
positive_idx_33:
%out_of_bounds_33 = icmp sge i32 %Temp_117, %arr_size_33
br i1 %out_of_bounds_33 , label %error_idx_33, label %continue_idx_33
error_idx_33:
call void @AccessViolation()
br label %continue_idx_33
continue_idx_33:
  %Temp_118 = add nsw i32 %Temp_117,1
;getlement temp temp temp;
  %Temp_119 = getelementptr inbounds i32, i32* %Temp_116, i32 %Temp_118
;load temp temp;
  %Temp_120 = load i32, i32* %Temp_119, align 4
%Temp_i32_34 = bitcast i32* %Temp_107 to i32*
%Temp_size_ptr_34 = getelementptr inbounds i32, i32* %Temp_i32_34, i32 0
%arr_size_34 = load i32, i32* %Temp_size_ptr_34,align 4
%sub_negative_34 = icmp slt i32  %Temp_120, 0
br i1 %sub_negative_34 , label %error_idx_34, label %positive_idx_34
positive_idx_34:
%out_of_bounds_34 = icmp sge i32 %Temp_120, %arr_size_34
br i1 %out_of_bounds_34 , label %error_idx_34, label %continue_idx_34
error_idx_34:
call void @AccessViolation()
br label %continue_idx_34
continue_idx_34:
  %Temp_121 = add nsw i32 %Temp_120,1
;getlement temp temp temp;
  %Temp_122 = getelementptr inbounds i32, i32* %Temp_107, i32 %Temp_121
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_123 = add nsw i32 %zero_31, 999
;store TYPES.TYPE_INT@5197848c dst src;
  store i32 %Temp_123, i32* %Temp_122, align 4
call void @exit(i32 0)
  ret void
}
