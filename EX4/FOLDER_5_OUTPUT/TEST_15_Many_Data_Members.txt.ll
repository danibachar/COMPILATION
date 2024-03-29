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

define i32 @sum(i8*)
 { 
  %f = alloca i8*, align 8
  store i8* %0, i8** %f, align 8
  %Temp_1 = load i8*, i8** %f, align 8
%Temp_null_0 = bitcast i8* %Temp_1 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_0, 120
;getlement temp temp temp;
  %Temp_3 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_2
  %Temp_4 = bitcast i8* %Temp_3 to i32*
  %Temp_5 = load i8*, i8** %f, align 8
%Temp_null_1 = bitcast i8* %Temp_5 to i32*
%equal_null_1 = icmp eq i32* %Temp_null_1, null
br i1 %equal_null_1, label %null_deref_1, label %continue_1
null_deref_1:
call void @InvalidPointer()
br label %continue_1
continue_1:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_1, 16
;getlement temp temp temp;
  %Temp_7 = getelementptr inbounds i8, i8* %Temp_5, i32 %Temp_6
  %Temp_8 = bitcast i8* %Temp_7 to i32*
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
  %Temp_9 = load i32, i32* %Temp_actual_2 , align 4
;load temp temp;
%Temp_init_ptr_3 = bitcast i32* %Temp_4 to i32*
%init_state_3 = load i32, i32* %Temp_init_ptr_3,align 4
%is_init_3 = icmp eq i32  %init_state_3, 0
br i1 %is_init_3 , label %error_init_3, label %good_init_3
error_init_3:
call void @InvalidPointer()
br label %good_init_3
good_init_3:
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  %Temp_10 = load i32, i32* %Temp_actual_3 , align 4
  %Temp_0 = add nsw i32 %Temp_10, %Temp_9
%Temp_11 = call i32 @CheckOverflow(i32 %Temp_0)
  ret i32 %Temp_11
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8*, align 8
  call void @init_globals()
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_2, 256
  %Temp_14 = call i32* @malloc(i32 %Temp_13)
  %Temp_12 = bitcast i32* %Temp_14 to i8*
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_3, 0
;getlement temp temp temp;
  %Temp_16 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_15
  %Temp_17 = bitcast i8* %Temp_16 to i32*
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_4, 32
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_4 = bitcast i32* %Temp_17 to i32*
store i32 1, i32* %Temp_init_ptr_4,align 4
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  store i32 %Temp_18, i32* %Temp_actual_4, align 4
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_5, 8
;getlement temp temp temp;
  %Temp_20 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_19
  %Temp_21 = bitcast i8* %Temp_20 to i32*
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_6, 31
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_21 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_22, i32* %Temp_actual_5, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_7, 16
;getlement temp temp temp;
  %Temp_24 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_23
  %Temp_25 = bitcast i8* %Temp_24 to i32*
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_8, 30
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_6 = bitcast i32* %Temp_25 to i32*
store i32 1, i32* %Temp_init_ptr_6,align 4
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  store i32 %Temp_26, i32* %Temp_actual_6, align 4
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_9, 24
;getlement temp temp temp;
  %Temp_28 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_27
  %Temp_29 = bitcast i8* %Temp_28 to i32*
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_30 = add nsw i32 %zero_10, 29
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_7 = bitcast i32* %Temp_29 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  store i32 %Temp_30, i32* %Temp_actual_7, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_11, 32
;getlement temp temp temp;
  %Temp_32 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_31
  %Temp_33 = bitcast i8* %Temp_32 to i32*
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_12, 28
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_8 = bitcast i32* %Temp_33 to i32*
store i32 1, i32* %Temp_init_ptr_8,align 4
%Temp_actual_ptr_8 = getelementptr inbounds i32, i32* %Temp_init_ptr_8, i32 1
%Temp_actual_8 = bitcast i32* %Temp_actual_ptr_8 to i32*
  store i32 %Temp_34, i32* %Temp_actual_8, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_35 = add nsw i32 %zero_13, 40
;getlement temp temp temp;
  %Temp_36 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_35
  %Temp_37 = bitcast i8* %Temp_36 to i32*
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_14, 27
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_9 = bitcast i32* %Temp_37 to i32*
store i32 1, i32* %Temp_init_ptr_9,align 4
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  store i32 %Temp_38, i32* %Temp_actual_9, align 4
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_15, 48
;getlement temp temp temp;
  %Temp_40 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_39
  %Temp_41 = bitcast i8* %Temp_40 to i32*
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_16, 26
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_10 = bitcast i32* %Temp_41 to i32*
store i32 1, i32* %Temp_init_ptr_10,align 4
%Temp_actual_ptr_10 = getelementptr inbounds i32, i32* %Temp_init_ptr_10, i32 1
%Temp_actual_10 = bitcast i32* %Temp_actual_ptr_10 to i32*
  store i32 %Temp_42, i32* %Temp_actual_10, align 4
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_43 = add nsw i32 %zero_17, 56
;getlement temp temp temp;
  %Temp_44 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_43
  %Temp_45 = bitcast i8* %Temp_44 to i32*
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_18, 25
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_11 = bitcast i32* %Temp_45 to i32*
store i32 1, i32* %Temp_init_ptr_11,align 4
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  store i32 %Temp_46, i32* %Temp_actual_11, align 4
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_47 = add nsw i32 %zero_19, 64
;getlement temp temp temp;
  %Temp_48 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_47
  %Temp_49 = bitcast i8* %Temp_48 to i32*
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_50 = add nsw i32 %zero_20, 24
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_49 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_50, i32* %Temp_actual_12, align 4
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_21, 72
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_51
  %Temp_53 = bitcast i8* %Temp_52 to i32*
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_22, 23
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_13 = bitcast i32* %Temp_53 to i32*
store i32 1, i32* %Temp_init_ptr_13,align 4
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i32*
  store i32 %Temp_54, i32* %Temp_actual_13, align 4
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_55 = add nsw i32 %zero_23, 80
;getlement temp temp temp;
  %Temp_56 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_55
  %Temp_57 = bitcast i8* %Temp_56 to i32*
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_58 = add nsw i32 %zero_24, 22
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_14 = bitcast i32* %Temp_57 to i32*
store i32 1, i32* %Temp_init_ptr_14,align 4
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32*
  store i32 %Temp_58, i32* %Temp_actual_14, align 4
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_59 = add nsw i32 %zero_25, 88
;getlement temp temp temp;
  %Temp_60 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_59
  %Temp_61 = bitcast i8* %Temp_60 to i32*
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_26, 21
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_15 = bitcast i32* %Temp_61 to i32*
store i32 1, i32* %Temp_init_ptr_15,align 4
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  store i32 %Temp_62, i32* %Temp_actual_15, align 4
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_63 = add nsw i32 %zero_27, 96
;getlement temp temp temp;
  %Temp_64 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_63
  %Temp_65 = bitcast i8* %Temp_64 to i32*
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_66 = add nsw i32 %zero_28, 20
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_16 = bitcast i32* %Temp_65 to i32*
store i32 1, i32* %Temp_init_ptr_16,align 4
%Temp_actual_ptr_16 = getelementptr inbounds i32, i32* %Temp_init_ptr_16, i32 1
%Temp_actual_16 = bitcast i32* %Temp_actual_ptr_16 to i32*
  store i32 %Temp_66, i32* %Temp_actual_16, align 4
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_67 = add nsw i32 %zero_29, 104
;getlement temp temp temp;
  %Temp_68 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_67
  %Temp_69 = bitcast i8* %Temp_68 to i32*
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_70 = add nsw i32 %zero_30, 19
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_17 = bitcast i32* %Temp_69 to i32*
store i32 1, i32* %Temp_init_ptr_17,align 4
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  store i32 %Temp_70, i32* %Temp_actual_17, align 4
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_31, 112
;getlement temp temp temp;
  %Temp_72 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_71
  %Temp_73 = bitcast i8* %Temp_72 to i32*
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_74 = add nsw i32 %zero_32, 18
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_18 = bitcast i32* %Temp_73 to i32*
store i32 1, i32* %Temp_init_ptr_18,align 4
%Temp_actual_ptr_18 = getelementptr inbounds i32, i32* %Temp_init_ptr_18, i32 1
%Temp_actual_18 = bitcast i32* %Temp_actual_ptr_18 to i32*
  store i32 %Temp_74, i32* %Temp_actual_18, align 4
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_75 = add nsw i32 %zero_33, 120
;getlement temp temp temp;
  %Temp_76 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_75
  %Temp_77 = bitcast i8* %Temp_76 to i32*
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_78 = add nsw i32 %zero_34, 17
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_19 = bitcast i32* %Temp_77 to i32*
store i32 1, i32* %Temp_init_ptr_19,align 4
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32*
  store i32 %Temp_78, i32* %Temp_actual_19, align 4
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_79 = add nsw i32 %zero_35, 128
;getlement temp temp temp;
  %Temp_80 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_79
  %Temp_81 = bitcast i8* %Temp_80 to i32*
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_82 = add nsw i32 %zero_36, 16
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_20 = bitcast i32* %Temp_81 to i32*
store i32 1, i32* %Temp_init_ptr_20,align 4
%Temp_actual_ptr_20 = getelementptr inbounds i32, i32* %Temp_init_ptr_20, i32 1
%Temp_actual_20 = bitcast i32* %Temp_actual_ptr_20 to i32*
  store i32 %Temp_82, i32* %Temp_actual_20, align 4
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_83 = add nsw i32 %zero_37, 136
;getlement temp temp temp;
  %Temp_84 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_83
  %Temp_85 = bitcast i8* %Temp_84 to i32*
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_38, 15
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_21 = bitcast i32* %Temp_85 to i32*
store i32 1, i32* %Temp_init_ptr_21,align 4
%Temp_actual_ptr_21 = getelementptr inbounds i32, i32* %Temp_init_ptr_21, i32 1
%Temp_actual_21 = bitcast i32* %Temp_actual_ptr_21 to i32*
  store i32 %Temp_86, i32* %Temp_actual_21, align 4
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_87 = add nsw i32 %zero_39, 144
;getlement temp temp temp;
  %Temp_88 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_87
  %Temp_89 = bitcast i8* %Temp_88 to i32*
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_90 = add nsw i32 %zero_40, 14
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_22 = bitcast i32* %Temp_89 to i32*
store i32 1, i32* %Temp_init_ptr_22,align 4
%Temp_actual_ptr_22 = getelementptr inbounds i32, i32* %Temp_init_ptr_22, i32 1
%Temp_actual_22 = bitcast i32* %Temp_actual_ptr_22 to i32*
  store i32 %Temp_90, i32* %Temp_actual_22, align 4
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_41, 152
;getlement temp temp temp;
  %Temp_92 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_91
  %Temp_93 = bitcast i8* %Temp_92 to i32*
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_94 = add nsw i32 %zero_42, 13
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_23 = bitcast i32* %Temp_93 to i32*
store i32 1, i32* %Temp_init_ptr_23,align 4
%Temp_actual_ptr_23 = getelementptr inbounds i32, i32* %Temp_init_ptr_23, i32 1
%Temp_actual_23 = bitcast i32* %Temp_actual_ptr_23 to i32*
  store i32 %Temp_94, i32* %Temp_actual_23, align 4
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_43, 160
;getlement temp temp temp;
  %Temp_96 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_95
  %Temp_97 = bitcast i8* %Temp_96 to i32*
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_98 = add nsw i32 %zero_44, 12
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_24 = bitcast i32* %Temp_97 to i32*
store i32 1, i32* %Temp_init_ptr_24,align 4
%Temp_actual_ptr_24 = getelementptr inbounds i32, i32* %Temp_init_ptr_24, i32 1
%Temp_actual_24 = bitcast i32* %Temp_actual_ptr_24 to i32*
  store i32 %Temp_98, i32* %Temp_actual_24, align 4
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_99 = add nsw i32 %zero_45, 168
;getlement temp temp temp;
  %Temp_100 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_99
  %Temp_101 = bitcast i8* %Temp_100 to i32*
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_102 = add nsw i32 %zero_46, 11
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_25 = bitcast i32* %Temp_101 to i32*
store i32 1, i32* %Temp_init_ptr_25,align 4
%Temp_actual_ptr_25 = getelementptr inbounds i32, i32* %Temp_init_ptr_25, i32 1
%Temp_actual_25 = bitcast i32* %Temp_actual_ptr_25 to i32*
  store i32 %Temp_102, i32* %Temp_actual_25, align 4
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_103 = add nsw i32 %zero_47, 176
;getlement temp temp temp;
  %Temp_104 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_103
  %Temp_105 = bitcast i8* %Temp_104 to i32*
  %zero_48 = load i32, i32* @my_zero, align 4
  %Temp_106 = add nsw i32 %zero_48, 10
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_26 = bitcast i32* %Temp_105 to i32*
store i32 1, i32* %Temp_init_ptr_26,align 4
%Temp_actual_ptr_26 = getelementptr inbounds i32, i32* %Temp_init_ptr_26, i32 1
%Temp_actual_26 = bitcast i32* %Temp_actual_ptr_26 to i32*
  store i32 %Temp_106, i32* %Temp_actual_26, align 4
  %zero_49 = load i32, i32* @my_zero, align 4
  %Temp_107 = add nsw i32 %zero_49, 184
;getlement temp temp temp;
  %Temp_108 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_107
  %Temp_109 = bitcast i8* %Temp_108 to i32*
  %zero_50 = load i32, i32* @my_zero, align 4
  %Temp_110 = add nsw i32 %zero_50, 9
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_27 = bitcast i32* %Temp_109 to i32*
store i32 1, i32* %Temp_init_ptr_27,align 4
%Temp_actual_ptr_27 = getelementptr inbounds i32, i32* %Temp_init_ptr_27, i32 1
%Temp_actual_27 = bitcast i32* %Temp_actual_ptr_27 to i32*
  store i32 %Temp_110, i32* %Temp_actual_27, align 4
  %zero_51 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_51, 192
;getlement temp temp temp;
  %Temp_112 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_111
  %Temp_113 = bitcast i8* %Temp_112 to i32*
  %zero_52 = load i32, i32* @my_zero, align 4
  %Temp_114 = add nsw i32 %zero_52, 8
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_28 = bitcast i32* %Temp_113 to i32*
store i32 1, i32* %Temp_init_ptr_28,align 4
%Temp_actual_ptr_28 = getelementptr inbounds i32, i32* %Temp_init_ptr_28, i32 1
%Temp_actual_28 = bitcast i32* %Temp_actual_ptr_28 to i32*
  store i32 %Temp_114, i32* %Temp_actual_28, align 4
  %zero_53 = load i32, i32* @my_zero, align 4
  %Temp_115 = add nsw i32 %zero_53, 200
;getlement temp temp temp;
  %Temp_116 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_115
  %Temp_117 = bitcast i8* %Temp_116 to i32*
  %zero_54 = load i32, i32* @my_zero, align 4
  %Temp_118 = add nsw i32 %zero_54, 7
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_29 = bitcast i32* %Temp_117 to i32*
store i32 1, i32* %Temp_init_ptr_29,align 4
%Temp_actual_ptr_29 = getelementptr inbounds i32, i32* %Temp_init_ptr_29, i32 1
%Temp_actual_29 = bitcast i32* %Temp_actual_ptr_29 to i32*
  store i32 %Temp_118, i32* %Temp_actual_29, align 4
  %zero_55 = load i32, i32* @my_zero, align 4
  %Temp_119 = add nsw i32 %zero_55, 208
;getlement temp temp temp;
  %Temp_120 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_119
  %Temp_121 = bitcast i8* %Temp_120 to i32*
  %zero_56 = load i32, i32* @my_zero, align 4
  %Temp_122 = add nsw i32 %zero_56, 6
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_30 = bitcast i32* %Temp_121 to i32*
store i32 1, i32* %Temp_init_ptr_30,align 4
%Temp_actual_ptr_30 = getelementptr inbounds i32, i32* %Temp_init_ptr_30, i32 1
%Temp_actual_30 = bitcast i32* %Temp_actual_ptr_30 to i32*
  store i32 %Temp_122, i32* %Temp_actual_30, align 4
  %zero_57 = load i32, i32* @my_zero, align 4
  %Temp_123 = add nsw i32 %zero_57, 216
;getlement temp temp temp;
  %Temp_124 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_123
  %Temp_125 = bitcast i8* %Temp_124 to i32*
  %zero_58 = load i32, i32* @my_zero, align 4
  %Temp_126 = add nsw i32 %zero_58, 5
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_31 = bitcast i32* %Temp_125 to i32*
store i32 1, i32* %Temp_init_ptr_31,align 4
%Temp_actual_ptr_31 = getelementptr inbounds i32, i32* %Temp_init_ptr_31, i32 1
%Temp_actual_31 = bitcast i32* %Temp_actual_ptr_31 to i32*
  store i32 %Temp_126, i32* %Temp_actual_31, align 4
  %zero_59 = load i32, i32* @my_zero, align 4
  %Temp_127 = add nsw i32 %zero_59, 224
;getlement temp temp temp;
  %Temp_128 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_127
  %Temp_129 = bitcast i8* %Temp_128 to i32*
  %zero_60 = load i32, i32* @my_zero, align 4
  %Temp_130 = add nsw i32 %zero_60, 4
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_32 = bitcast i32* %Temp_129 to i32*
store i32 1, i32* %Temp_init_ptr_32,align 4
%Temp_actual_ptr_32 = getelementptr inbounds i32, i32* %Temp_init_ptr_32, i32 1
%Temp_actual_32 = bitcast i32* %Temp_actual_ptr_32 to i32*
  store i32 %Temp_130, i32* %Temp_actual_32, align 4
  %zero_61 = load i32, i32* @my_zero, align 4
  %Temp_131 = add nsw i32 %zero_61, 232
;getlement temp temp temp;
  %Temp_132 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_131
  %Temp_133 = bitcast i8* %Temp_132 to i32*
  %zero_62 = load i32, i32* @my_zero, align 4
  %Temp_134 = add nsw i32 %zero_62, 3
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_33 = bitcast i32* %Temp_133 to i32*
store i32 1, i32* %Temp_init_ptr_33,align 4
%Temp_actual_ptr_33 = getelementptr inbounds i32, i32* %Temp_init_ptr_33, i32 1
%Temp_actual_33 = bitcast i32* %Temp_actual_ptr_33 to i32*
  store i32 %Temp_134, i32* %Temp_actual_33, align 4
  %zero_63 = load i32, i32* @my_zero, align 4
  %Temp_135 = add nsw i32 %zero_63, 240
;getlement temp temp temp;
  %Temp_136 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_135
  %Temp_137 = bitcast i8* %Temp_136 to i32*
  %zero_64 = load i32, i32* @my_zero, align 4
  %Temp_138 = add nsw i32 %zero_64, 2
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_34 = bitcast i32* %Temp_137 to i32*
store i32 1, i32* %Temp_init_ptr_34,align 4
%Temp_actual_ptr_34 = getelementptr inbounds i32, i32* %Temp_init_ptr_34, i32 1
%Temp_actual_34 = bitcast i32* %Temp_actual_ptr_34 to i32*
  store i32 %Temp_138, i32* %Temp_actual_34, align 4
  %zero_65 = load i32, i32* @my_zero, align 4
  %Temp_139 = add nsw i32 %zero_65, 248
;getlement temp temp temp;
  %Temp_140 = getelementptr inbounds i8, i8* %Temp_12, i32 %Temp_139
  %Temp_141 = bitcast i8* %Temp_140 to i32*
  %zero_66 = load i32, i32* @my_zero, align 4
  %Temp_142 = add nsw i32 %zero_66, 1
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_35 = bitcast i32* %Temp_141 to i32*
store i32 1, i32* %Temp_init_ptr_35,align 4
%Temp_actual_ptr_35 = getelementptr inbounds i32, i32* %Temp_init_ptr_35, i32 1
%Temp_actual_35 = bitcast i32* %Temp_actual_ptr_35 to i32*
  store i32 %Temp_142, i32* %Temp_actual_35, align 4
  store i8* %Temp_12, i8** %local_0, align 8
  %Temp_143 = load i8*, i8** %local_0, align 8
%Temp_144 =call i32 @sum(i8* %Temp_143 )
  call void @PrintInt(i32 %Temp_144 )
call void @exit(i32 0)
  ret void
}
