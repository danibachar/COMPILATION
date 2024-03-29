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

;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@c = global i8* null, align 8

define i32 @mul()
 { 
  %Temp_0 = load i8*, i8** @c, align 8
%Temp_null_0 = bitcast i8* %Temp_0 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 0
;getlement temp temp temp;
  %Temp_2 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_1
  %Temp_3 = bitcast i8* %Temp_2 to i32*
  %Temp_5 = load i8*, i8** @c, align 8
%Temp_null_1 = bitcast i8* %Temp_5 to i32*
%equal_null_1 = icmp eq i32* %Temp_null_1, null
br i1 %equal_null_1, label %null_deref_1, label %continue_1
null_deref_1:
call void @InvalidPointer()
br label %continue_1
continue_1:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_1, 0
;getlement temp temp temp;
  %Temp_7 = getelementptr inbounds i8, i8* %Temp_5, i32 %Temp_6
  %Temp_8 = bitcast i8* %Temp_7 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_2, 2
;load temp temp;
%Temp_init_ptr_2 = bitcast i32* %Temp_8 to i32*
%init_state_2 = load i32, i32* %Temp_init_ptr_2,align 4
%is_init_2 = icmp eq i32  %init_state_2, 0
br i1 %is_init_2 , label %error_init_2, label %good_init_2
error_init_2:
call void @InvalidPointer()
br label %good_init_2
good_init_2:
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  %Temp_10 = load i32, i32* %Temp_actual_2 , align 4
  %Temp_4 = mul nsw i32 %Temp_10, %Temp_9
%Temp_11 = call i32 @CheckOverflow(i32 %Temp_4)
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_3 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_11, i32* %Temp_actual_3, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_3, 0
  ret i32 %Temp_12
}
define i32 @inc()
 { 
  %Temp_13 = load i8*, i8** @c, align 8
%Temp_null_4 = bitcast i8* %Temp_13 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_4, 0
;getlement temp temp temp;
  %Temp_15 = getelementptr inbounds i8, i8* %Temp_13, i32 %Temp_14
  %Temp_16 = bitcast i8* %Temp_15 to i32*
  %Temp_18 = load i8*, i8** @c, align 8
%Temp_null_5 = bitcast i8* %Temp_18 to i32*
%equal_null_5 = icmp eq i32* %Temp_null_5, null
br i1 %equal_null_5, label %null_deref_5, label %continue_5
null_deref_5:
call void @InvalidPointer()
br label %continue_5
continue_5:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_5, 0
;getlement temp temp temp;
  %Temp_20 = getelementptr inbounds i8, i8* %Temp_18, i32 %Temp_19
  %Temp_21 = bitcast i8* %Temp_20 to i32*
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_6, 1
;load temp temp;
%Temp_init_ptr_6 = bitcast i32* %Temp_21 to i32*
%init_state_6 = load i32, i32* %Temp_init_ptr_6,align 4
%is_init_6 = icmp eq i32  %init_state_6, 0
br i1 %is_init_6 , label %error_init_6, label %good_init_6
error_init_6:
call void @InvalidPointer()
br label %good_init_6
good_init_6:
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  %Temp_23 = load i32, i32* %Temp_actual_6 , align 4
  %Temp_17 = add nsw i32 %Temp_23, %Temp_22
%Temp_24 = call i32 @CheckOverflow(i32 %Temp_17)
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_7 = bitcast i32* %Temp_16 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  store i32 %Temp_24, i32* %Temp_actual_7, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_7, 9
  ret i32 %Temp_25
}
define i32 @foo(i32,i32)
 { 
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, i32* %m, align 4
  store i32 %1, i32* %n, align 4
  %Temp_26 = load i8*, i8** @c, align 8
%Temp_null_8 = bitcast i8* %Temp_26 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_8, 0
;getlement temp temp temp;
  %Temp_28 = getelementptr inbounds i8, i8* %Temp_26, i32 %Temp_27
  %Temp_29 = bitcast i8* %Temp_28 to i32*
;load temp temp;
%Temp_init_ptr_9 = bitcast i32* %Temp_29 to i32*
%init_state_9 = load i32, i32* %Temp_init_ptr_9,align 4
%is_init_9 = icmp eq i32  %init_state_9, 0
br i1 %is_init_9 , label %error_init_9, label %good_init_9
error_init_9:
call void @InvalidPointer()
br label %good_init_9
good_init_9:
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  %Temp_30 = load i32, i32* %Temp_actual_9 , align 4
  ret i32 %Temp_30
}
define i32 @bar(i32,i32,i32,i32)
 { 
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %k = alloca i32, align 4
  %l = alloca i32, align 4
  store i32 %0, i32* %m, align 4
  store i32 %1, i32* %n, align 4
  store i32 %2, i32* %k, align 4
  store i32 %3, i32* %l, align 4
  %Temp_31 = load i8*, i8** @c, align 8
%Temp_null_10 = bitcast i8* %Temp_31 to i32*
%equal_null_10 = icmp eq i32* %Temp_null_10, null
br i1 %equal_null_10, label %null_deref_10, label %continue_10
null_deref_10:
call void @InvalidPointer()
br label %continue_10
continue_10:
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_9, 0
;getlement temp temp temp;
  %Temp_33 = getelementptr inbounds i8, i8* %Temp_31, i32 %Temp_32
  %Temp_34 = bitcast i8* %Temp_33 to i32*
;load temp temp;
%Temp_init_ptr_11 = bitcast i32* %Temp_34 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  %Temp_35 = load i32, i32* %Temp_actual_11 , align 4
  ret i32 %Temp_35
}
define void @init_globals()
 { 
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_10, 8
  %Temp_38 = call i32* @malloc(i32 %Temp_37)
  %Temp_36 = bitcast i32* %Temp_38 to i8*
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_11, 0
;getlement temp temp temp;
  %Temp_40 = getelementptr inbounds i8, i8* %Temp_36, i32 %Temp_39
  %Temp_41 = bitcast i8* %Temp_40 to i32*
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_12, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_41 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_42, i32* %Temp_actual_12, align 4
  store i8* %Temp_36, i8** @c, align 8
  ret void
}
define void @main()
 { 
  call void @init_globals()
%Temp_43 =call i32 @mul()
%Temp_44 =call i32 @inc()
%Temp_45 =call i32 @foo(i32 %Temp_43 ,i32 %Temp_44 )
  call void @PrintInt(i32 %Temp_45 )
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_47 = add nsw i32 %zero_13, 8
  %Temp_48 = call i32* @malloc(i32 %Temp_47)
  %Temp_46 = bitcast i32* %Temp_48 to i8*
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_49 = add nsw i32 %zero_14, 0
;getlement temp temp temp;
  %Temp_50 = getelementptr inbounds i8, i8* %Temp_46, i32 %Temp_49
  %Temp_51 = bitcast i8* %Temp_50 to i32*
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_52 = add nsw i32 %zero_15, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_13 = bitcast i32* %Temp_51 to i32*
store i32 1, i32* %Temp_init_ptr_13,align 4
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i32*
  store i32 %Temp_52, i32* %Temp_actual_13, align 4
  store i8* %Temp_46, i8** @c, align 8
%Temp_53 =call i32 @inc()
%Temp_54 =call i32 @mul()
%Temp_55 =call i32 @foo(i32 %Temp_53 ,i32 %Temp_54 )
  call void @PrintInt(i32 %Temp_55 )
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_57 = add nsw i32 %zero_16, 8
  %Temp_58 = call i32* @malloc(i32 %Temp_57)
  %Temp_56 = bitcast i32* %Temp_58 to i8*
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_59 = add nsw i32 %zero_17, 0
;getlement temp temp temp;
  %Temp_60 = getelementptr inbounds i8, i8* %Temp_56, i32 %Temp_59
  %Temp_61 = bitcast i8* %Temp_60 to i32*
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_18, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_14 = bitcast i32* %Temp_61 to i32*
store i32 1, i32* %Temp_init_ptr_14,align 4
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32*
  store i32 %Temp_62, i32* %Temp_actual_14, align 4
  store i8* %Temp_56, i8** @c, align 8
%Temp_63 =call i32 @inc()
%Temp_64 =call i32 @mul()
%Temp_65 =call i32 @inc()
%Temp_66 =call i32 @mul()
%Temp_67 =call i32 @bar(i32 %Temp_63 ,i32 %Temp_64 ,i32 %Temp_65 ,i32 %Temp_66 )
  call void @PrintInt(i32 %Temp_67 )
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_69 = add nsw i32 %zero_19, 8
  %Temp_70 = call i32* @malloc(i32 %Temp_69)
  %Temp_68 = bitcast i32* %Temp_70 to i8*
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_20, 0
;getlement temp temp temp;
  %Temp_72 = getelementptr inbounds i8, i8* %Temp_68, i32 %Temp_71
  %Temp_73 = bitcast i8* %Temp_72 to i32*
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_74 = add nsw i32 %zero_21, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_15 = bitcast i32* %Temp_73 to i32*
store i32 1, i32* %Temp_init_ptr_15,align 4
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  store i32 %Temp_74, i32* %Temp_actual_15, align 4
  store i8* %Temp_68, i8** @c, align 8
%Temp_75 =call i32 @mul()
%Temp_76 =call i32 @inc()
%Temp_77 =call i32 @mul()
%Temp_78 =call i32 @inc()
%Temp_79 =call i32 @bar(i32 %Temp_75 ,i32 %Temp_76 ,i32 %Temp_77 ,i32 %Temp_78 )
  call void @PrintInt(i32 %Temp_79 )
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_22, 8
  %Temp_82 = call i32* @malloc(i32 %Temp_81)
  %Temp_80 = bitcast i32* %Temp_82 to i8*
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_83 = add nsw i32 %zero_23, 0
;getlement temp temp temp;
  %Temp_84 = getelementptr inbounds i8, i8* %Temp_80, i32 %Temp_83
  %Temp_85 = bitcast i8* %Temp_84 to i32*
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_24, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_16 = bitcast i32* %Temp_85 to i32*
store i32 1, i32* %Temp_init_ptr_16,align 4
%Temp_actual_ptr_16 = getelementptr inbounds i32, i32* %Temp_init_ptr_16, i32 1
%Temp_actual_16 = bitcast i32* %Temp_actual_ptr_16 to i32*
  store i32 %Temp_86, i32* %Temp_actual_16, align 4
  store i8* %Temp_80, i8** @c, align 8
%Temp_87 =call i32 @inc()
%Temp_88 =call i32 @inc()
%Temp_89 =call i32 @inc()
%Temp_90 =call i32 @mul()
%Temp_91 =call i32 @bar(i32 %Temp_87 ,i32 %Temp_88 ,i32 %Temp_89 ,i32 %Temp_90 )
  call void @PrintInt(i32 %Temp_91 )
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_93 = add nsw i32 %zero_25, 8
  %Temp_94 = call i32* @malloc(i32 %Temp_93)
  %Temp_92 = bitcast i32* %Temp_94 to i8*
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_26, 0
;getlement temp temp temp;
  %Temp_96 = getelementptr inbounds i8, i8* %Temp_92, i32 %Temp_95
  %Temp_97 = bitcast i8* %Temp_96 to i32*
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_98 = add nsw i32 %zero_27, 5
;store TYPES.TYPE_INT@20ad9418 dst src;
%Temp_init_ptr_17 = bitcast i32* %Temp_97 to i32*
store i32 1, i32* %Temp_init_ptr_17,align 4
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  store i32 %Temp_98, i32* %Temp_actual_17, align 4
  store i8* %Temp_92, i8** @c, align 8
%Temp_99 =call i32 @mul()
%Temp_100 =call i32 @mul()
%Temp_101 =call i32 @mul()
%Temp_102 =call i32 @inc()
%Temp_103 =call i32 @bar(i32 %Temp_99 ,i32 %Temp_100 ,i32 %Temp_101 ,i32 %Temp_102 )
  call void @PrintInt(i32 %Temp_103 )
call void @exit(i32 0)
  ret void
}
