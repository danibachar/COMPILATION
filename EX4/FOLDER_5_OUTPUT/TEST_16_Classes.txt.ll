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
  %local_0 = alloca i8*, align 8
  %local_1 = alloca i8*, align 8
  %local_2 = alloca i8*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 8
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 0
;getlement temp temp temp;
  %Temp_4 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_3
  %Temp_5 = bitcast i8* %Temp_4 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_2, 6
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_5 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_6, i32* %Temp_actual_0, align 4
  store i8* %Temp_0, i8** %local_0, align 8
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_3, 24
  %Temp_9 = call i32* @malloc(i32 %Temp_8)
  %Temp_7 = bitcast i32* %Temp_9 to i8*
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_4, 8
;getlement temp temp temp;
  %Temp_11 = getelementptr inbounds i8, i8* %Temp_7, i32 %Temp_10
  %Temp_12 = bitcast i8* %Temp_11 to i32*
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_5, 8
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_12 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_13, i32* %Temp_actual_1, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_6, 16
;getlement temp temp temp;
  %Temp_15 = getelementptr inbounds i8, i8* %Temp_7, i32 %Temp_14
  %Temp_16 = bitcast i8* %Temp_15 to i32*
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_7, 7
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_2 = bitcast i32* %Temp_16 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  store i32 %Temp_17, i32* %Temp_actual_2, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_8, 0
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_7, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i32*
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_9, 6
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_20 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_21, i32* %Temp_actual_3, align 4
  store i8* %Temp_7, i8** %local_1, align 8
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_10, 32
  %Temp_24 = call i32* @malloc(i32 %Temp_23)
  %Temp_22 = bitcast i32* %Temp_24 to i8*
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_11, 24
;getlement temp temp temp;
  %Temp_26 = getelementptr inbounds i8, i8* %Temp_22, i32 %Temp_25
  %Temp_27 = bitcast i8* %Temp_26 to i32*
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_12, 9
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_4 = bitcast i32* %Temp_27 to i32*
store i32 1, i32* %Temp_init_ptr_4,align 4
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  store i32 %Temp_28, i32* %Temp_actual_4, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_13, 8
;getlement temp temp temp;
  %Temp_30 = getelementptr inbounds i8, i8* %Temp_22, i32 %Temp_29
  %Temp_31 = bitcast i8* %Temp_30 to i32*
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_14, 8
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_31 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_32, i32* %Temp_actual_5, align 4
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_15, 16
;getlement temp temp temp;
  %Temp_34 = getelementptr inbounds i8, i8* %Temp_22, i32 %Temp_33
  %Temp_35 = bitcast i8* %Temp_34 to i32*
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_16, 7
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_6 = bitcast i32* %Temp_35 to i32*
store i32 1, i32* %Temp_init_ptr_6,align 4
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  store i32 %Temp_36, i32* %Temp_actual_6, align 4
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_17, 0
;getlement temp temp temp;
  %Temp_38 = getelementptr inbounds i8, i8* %Temp_22, i32 %Temp_37
  %Temp_39 = bitcast i8* %Temp_38 to i32*
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_18, 6
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_7 = bitcast i32* %Temp_39 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  store i32 %Temp_40, i32* %Temp_actual_7, align 4
  store i8* %Temp_22, i8** %local_2, align 8
  %Temp_44 = load i8*, i8** %local_0, align 8
%Temp_null_8 = bitcast i8* %Temp_44 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_45 = add nsw i32 %zero_19, 0
;getlement temp temp temp;
  %Temp_46 = getelementptr inbounds i8, i8* %Temp_44, i32 %Temp_45
  %Temp_47 = bitcast i8* %Temp_46 to i32*
  %Temp_48 = load i8*, i8** %local_1, align 8
%Temp_null_9 = bitcast i8* %Temp_48 to i32*
%equal_null_9 = icmp eq i32* %Temp_null_9, null
br i1 %equal_null_9, label %null_deref_9, label %continue_9
null_deref_9:
call void @InvalidPointer()
br label %continue_9
continue_9:
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_49 = add nsw i32 %zero_20, 16
;getlement temp temp temp;
  %Temp_50 = getelementptr inbounds i8, i8* %Temp_48, i32 %Temp_49
  %Temp_51 = bitcast i8* %Temp_50 to i32*
;load temp temp;
%Temp_init_ptr_10 = bitcast i32* %Temp_51 to i32*
%init_state_10 = load i32, i32* %Temp_init_ptr_10,align 4
%is_init_10 = icmp eq i32  %init_state_10, 0
br i1 %is_init_10 , label %error_init_10, label %good_init_10
error_init_10:
call void @InvalidPointer()
br label %good_init_10
good_init_10:
%Temp_actual_ptr_10 = getelementptr inbounds i32, i32* %Temp_init_ptr_10, i32 1
%Temp_actual_10 = bitcast i32* %Temp_actual_ptr_10 to i32*
  %Temp_52 = load i32, i32* %Temp_actual_10 , align 4
;load temp temp;
%Temp_init_ptr_11 = bitcast i32* %Temp_47 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  %Temp_53 = load i32, i32* %Temp_actual_11 , align 4
  %Temp_43 = add nsw i32 %Temp_53, %Temp_52
%Temp_54 = call i32 @CheckOverflow(i32 %Temp_43)
  %Temp_55 = load i8*, i8** %local_1, align 8
%Temp_null_12 = bitcast i8* %Temp_55 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_21, 8
;getlement temp temp temp;
  %Temp_57 = getelementptr inbounds i8, i8* %Temp_55, i32 %Temp_56
  %Temp_58 = bitcast i8* %Temp_57 to i32*
;load temp temp;
%Temp_init_ptr_13 = bitcast i32* %Temp_58 to i32*
%init_state_13 = load i32, i32* %Temp_init_ptr_13,align 4
%is_init_13 = icmp eq i32  %init_state_13, 0
br i1 %is_init_13 , label %error_init_13, label %good_init_13
error_init_13:
call void @InvalidPointer()
br label %good_init_13
good_init_13:
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i32*
  %Temp_59 = load i32, i32* %Temp_actual_13 , align 4
  %Temp_42 = add nsw i32 %Temp_54, %Temp_59
%Temp_60 = call i32 @CheckOverflow(i32 %Temp_42)
  %Temp_61 = load i8*, i8** %local_2, align 8
%Temp_null_14 = bitcast i8* %Temp_61 to i32*
%equal_null_14 = icmp eq i32* %Temp_null_14, null
br i1 %equal_null_14, label %null_deref_14, label %continue_14
null_deref_14:
call void @InvalidPointer()
br label %continue_14
continue_14:
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_22, 24
;getlement temp temp temp;
  %Temp_63 = getelementptr inbounds i8, i8* %Temp_61, i32 %Temp_62
  %Temp_64 = bitcast i8* %Temp_63 to i32*
;load temp temp;
%Temp_init_ptr_15 = bitcast i32* %Temp_64 to i32*
%init_state_15 = load i32, i32* %Temp_init_ptr_15,align 4
%is_init_15 = icmp eq i32  %init_state_15, 0
br i1 %is_init_15 , label %error_init_15, label %good_init_15
error_init_15:
call void @InvalidPointer()
br label %good_init_15
good_init_15:
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  %Temp_65 = load i32, i32* %Temp_actual_15 , align 4
  %Temp_41 = add nsw i32 %Temp_60, %Temp_65
%Temp_66 = call i32 @CheckOverflow(i32 %Temp_41)
  call void @PrintInt(i32 %Temp_66 )
  %Temp_67 = load i8*, i8** %local_2, align 8
%Temp_null_16 = bitcast i8* %Temp_67 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_68 = add nsw i32 %zero_23, 0
;getlement temp temp temp;
  %Temp_69 = getelementptr inbounds i8, i8* %Temp_67, i32 %Temp_68
  %Temp_70 = bitcast i8* %Temp_69 to i32*
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_24, 100
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_17 = bitcast i32* %Temp_70 to i32*
store i32 1, i32* %Temp_init_ptr_17,align 4
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  store i32 %Temp_71, i32* %Temp_actual_17, align 4
  %Temp_72 = load i8*, i8** %local_2, align 8
%Temp_null_18 = bitcast i8* %Temp_72 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_73 = add nsw i32 %zero_25, 16
;getlement temp temp temp;
  %Temp_74 = getelementptr inbounds i8, i8* %Temp_72, i32 %Temp_73
  %Temp_75 = bitcast i8* %Temp_74 to i32*
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_76 = add nsw i32 %zero_26, 200
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_19 = bitcast i32* %Temp_75 to i32*
store i32 1, i32* %Temp_init_ptr_19,align 4
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32*
  store i32 %Temp_76, i32* %Temp_actual_19, align 4
  %Temp_77 = load i8*, i8** %local_2, align 8
%Temp_null_20 = bitcast i8* %Temp_77 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_78 = add nsw i32 %zero_27, 8
;getlement temp temp temp;
  %Temp_79 = getelementptr inbounds i8, i8* %Temp_77, i32 %Temp_78
  %Temp_80 = bitcast i8* %Temp_79 to i32*
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_28, 300
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_21 = bitcast i32* %Temp_80 to i32*
store i32 1, i32* %Temp_init_ptr_21,align 4
%Temp_actual_ptr_21 = getelementptr inbounds i32, i32* %Temp_init_ptr_21, i32 1
%Temp_actual_21 = bitcast i32* %Temp_actual_ptr_21 to i32*
  store i32 %Temp_81, i32* %Temp_actual_21, align 4
  %Temp_82 = load i8*, i8** %local_2, align 8
%Temp_null_22 = bitcast i8* %Temp_82 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_83 = add nsw i32 %zero_29, 24
;getlement temp temp temp;
  %Temp_84 = getelementptr inbounds i8, i8* %Temp_82, i32 %Temp_83
  %Temp_85 = bitcast i8* %Temp_84 to i32*
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_30, 400
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_23 = bitcast i32* %Temp_85 to i32*
store i32 1, i32* %Temp_init_ptr_23,align 4
%Temp_actual_ptr_23 = getelementptr inbounds i32, i32* %Temp_init_ptr_23, i32 1
%Temp_actual_23 = bitcast i32* %Temp_actual_ptr_23 to i32*
  store i32 %Temp_86, i32* %Temp_actual_23, align 4
  %Temp_90 = load i8*, i8** %local_2, align 8
%Temp_null_24 = bitcast i8* %Temp_90 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_31, 0
;getlement temp temp temp;
  %Temp_92 = getelementptr inbounds i8, i8* %Temp_90, i32 %Temp_91
  %Temp_93 = bitcast i8* %Temp_92 to i32*
  %Temp_94 = load i8*, i8** %local_2, align 8
%Temp_null_25 = bitcast i8* %Temp_94 to i32*
%equal_null_25 = icmp eq i32* %Temp_null_25, null
br i1 %equal_null_25, label %null_deref_25, label %continue_25
null_deref_25:
call void @InvalidPointer()
br label %continue_25
continue_25:
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_32, 16
;getlement temp temp temp;
  %Temp_96 = getelementptr inbounds i8, i8* %Temp_94, i32 %Temp_95
  %Temp_97 = bitcast i8* %Temp_96 to i32*
;load temp temp;
%Temp_init_ptr_26 = bitcast i32* %Temp_97 to i32*
%init_state_26 = load i32, i32* %Temp_init_ptr_26,align 4
%is_init_26 = icmp eq i32  %init_state_26, 0
br i1 %is_init_26 , label %error_init_26, label %good_init_26
error_init_26:
call void @InvalidPointer()
br label %good_init_26
good_init_26:
%Temp_actual_ptr_26 = getelementptr inbounds i32, i32* %Temp_init_ptr_26, i32 1
%Temp_actual_26 = bitcast i32* %Temp_actual_ptr_26 to i32*
  %Temp_98 = load i32, i32* %Temp_actual_26 , align 4
;load temp temp;
%Temp_init_ptr_27 = bitcast i32* %Temp_93 to i32*
%init_state_27 = load i32, i32* %Temp_init_ptr_27,align 4
%is_init_27 = icmp eq i32  %init_state_27, 0
br i1 %is_init_27 , label %error_init_27, label %good_init_27
error_init_27:
call void @InvalidPointer()
br label %good_init_27
good_init_27:
%Temp_actual_ptr_27 = getelementptr inbounds i32, i32* %Temp_init_ptr_27, i32 1
%Temp_actual_27 = bitcast i32* %Temp_actual_ptr_27 to i32*
  %Temp_99 = load i32, i32* %Temp_actual_27 , align 4
  %Temp_89 = add nsw i32 %Temp_99, %Temp_98
%Temp_100 = call i32 @CheckOverflow(i32 %Temp_89)
  %Temp_101 = load i8*, i8** %local_2, align 8
%Temp_null_28 = bitcast i8* %Temp_101 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_102 = add nsw i32 %zero_33, 8
;getlement temp temp temp;
  %Temp_103 = getelementptr inbounds i8, i8* %Temp_101, i32 %Temp_102
  %Temp_104 = bitcast i8* %Temp_103 to i32*
;load temp temp;
%Temp_init_ptr_29 = bitcast i32* %Temp_104 to i32*
%init_state_29 = load i32, i32* %Temp_init_ptr_29,align 4
%is_init_29 = icmp eq i32  %init_state_29, 0
br i1 %is_init_29 , label %error_init_29, label %good_init_29
error_init_29:
call void @InvalidPointer()
br label %good_init_29
good_init_29:
%Temp_actual_ptr_29 = getelementptr inbounds i32, i32* %Temp_init_ptr_29, i32 1
%Temp_actual_29 = bitcast i32* %Temp_actual_ptr_29 to i32*
  %Temp_105 = load i32, i32* %Temp_actual_29 , align 4
  %Temp_88 = add nsw i32 %Temp_100, %Temp_105
%Temp_106 = call i32 @CheckOverflow(i32 %Temp_88)
  %Temp_107 = load i8*, i8** %local_2, align 8
%Temp_null_30 = bitcast i8* %Temp_107 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_108 = add nsw i32 %zero_34, 24
;getlement temp temp temp;
  %Temp_109 = getelementptr inbounds i8, i8* %Temp_107, i32 %Temp_108
  %Temp_110 = bitcast i8* %Temp_109 to i32*
;load temp temp;
%Temp_init_ptr_31 = bitcast i32* %Temp_110 to i32*
%init_state_31 = load i32, i32* %Temp_init_ptr_31,align 4
%is_init_31 = icmp eq i32  %init_state_31, 0
br i1 %is_init_31 , label %error_init_31, label %good_init_31
error_init_31:
call void @InvalidPointer()
br label %good_init_31
good_init_31:
%Temp_actual_ptr_31 = getelementptr inbounds i32, i32* %Temp_init_ptr_31, i32 1
%Temp_actual_31 = bitcast i32* %Temp_actual_ptr_31 to i32*
  %Temp_111 = load i32, i32* %Temp_actual_31 , align 4
  %Temp_87 = add nsw i32 %Temp_106, %Temp_111
%Temp_112 = call i32 @CheckOverflow(i32 %Temp_87)
  call void @PrintInt(i32 %Temp_112 )
call void @exit(i32 0)
  ret void
}
