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
  %local_1 = alloca i8*, align 8
  %local_3 = alloca i8*, align 8
  %local_5 = alloca i8*, align 8
  %local_0 = alloca i8*, align 8
  %local_2 = alloca i8*, align 8
  %local_4 = alloca i8*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 32
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 0
;getlement temp temp temp;
  %Temp_4 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_3
  %Temp_5 = bitcast i8* %Temp_4 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_2, 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_5 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_6, i32* %Temp_actual_0, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_3, 8
;getlement temp temp temp;
  %Temp_8 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_7
  %Temp_9 = bitcast i8* %Temp_8 to i8**
  %Temp_10 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_1 = bitcast i8** %Temp_9 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32**
  store i32* %Temp_10, i32** %Temp_actual_1, align 8
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_4, 20
;getlement temp temp temp;
  %Temp_12 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_11
  %Temp_13 = bitcast i8* %Temp_12 to i8**
  %Temp_14 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_2 = bitcast i8** %Temp_13 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32**
  store i32* %Temp_14, i32** %Temp_actual_2, align 8
  store i8* %Temp_0, i8** %local_0, align 8
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_5, 32
  %Temp_17 = call i32* @malloc(i32 %Temp_16)
  %Temp_15 = bitcast i32* %Temp_17 to i8*
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_6, 0
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_15, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i32*
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_7, 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_20 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_21, i32* %Temp_actual_3, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_8, 8
;getlement temp temp temp;
  %Temp_23 = getelementptr inbounds i8, i8* %Temp_15, i32 %Temp_22
  %Temp_24 = bitcast i8* %Temp_23 to i8**
  %Temp_25 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_4 = bitcast i8** %Temp_24 to i32*
store i32 1, i32* %Temp_init_ptr_4,align 4
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32**
  store i32* %Temp_25, i32** %Temp_actual_4, align 8
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_9, 20
;getlement temp temp temp;
  %Temp_27 = getelementptr inbounds i8, i8* %Temp_15, i32 %Temp_26
  %Temp_28 = bitcast i8* %Temp_27 to i8**
  %Temp_29 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_5 = bitcast i8** %Temp_28 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32**
  store i32* %Temp_29, i32** %Temp_actual_5, align 8
  store i8* %Temp_15, i8** %local_1, align 8
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_10, 32
  %Temp_32 = call i32* @malloc(i32 %Temp_31)
  %Temp_30 = bitcast i32* %Temp_32 to i8*
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_11, 0
;getlement temp temp temp;
  %Temp_34 = getelementptr inbounds i8, i8* %Temp_30, i32 %Temp_33
  %Temp_35 = bitcast i8* %Temp_34 to i32*
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_12, 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_6 = bitcast i32* %Temp_35 to i32*
store i32 1, i32* %Temp_init_ptr_6,align 4
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  store i32 %Temp_36, i32* %Temp_actual_6, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_13, 8
;getlement temp temp temp;
  %Temp_38 = getelementptr inbounds i8, i8* %Temp_30, i32 %Temp_37
  %Temp_39 = bitcast i8* %Temp_38 to i8**
  %Temp_40 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_7 = bitcast i8** %Temp_39 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32**
  store i32* %Temp_40, i32** %Temp_actual_7, align 8
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_14, 20
;getlement temp temp temp;
  %Temp_42 = getelementptr inbounds i8, i8* %Temp_30, i32 %Temp_41
  %Temp_43 = bitcast i8* %Temp_42 to i8**
  %Temp_44 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_8 = bitcast i8** %Temp_43 to i32*
store i32 1, i32* %Temp_init_ptr_8,align 4
%Temp_actual_ptr_8 = getelementptr inbounds i32, i32* %Temp_init_ptr_8, i32 1
%Temp_actual_8 = bitcast i32* %Temp_actual_ptr_8 to i32**
  store i32* %Temp_44, i32** %Temp_actual_8, align 8
  store i8* %Temp_30, i8** %local_2, align 8
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_46 = add nsw i32 %zero_15, 32
  %Temp_47 = call i32* @malloc(i32 %Temp_46)
  %Temp_45 = bitcast i32* %Temp_47 to i8*
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_48 = add nsw i32 %zero_16, 0
;getlement temp temp temp;
  %Temp_49 = getelementptr inbounds i8, i8* %Temp_45, i32 %Temp_48
  %Temp_50 = bitcast i8* %Temp_49 to i32*
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_17, 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_9 = bitcast i32* %Temp_50 to i32*
store i32 1, i32* %Temp_init_ptr_9,align 4
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  store i32 %Temp_51, i32* %Temp_actual_9, align 4
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_52 = add nsw i32 %zero_18, 8
;getlement temp temp temp;
  %Temp_53 = getelementptr inbounds i8, i8* %Temp_45, i32 %Temp_52
  %Temp_54 = bitcast i8* %Temp_53 to i8**
  %Temp_55 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_10 = bitcast i8** %Temp_54 to i32*
store i32 1, i32* %Temp_init_ptr_10,align 4
%Temp_actual_ptr_10 = getelementptr inbounds i32, i32* %Temp_init_ptr_10, i32 1
%Temp_actual_10 = bitcast i32* %Temp_actual_ptr_10 to i32**
  store i32* %Temp_55, i32** %Temp_actual_10, align 8
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_19, 20
;getlement temp temp temp;
  %Temp_57 = getelementptr inbounds i8, i8* %Temp_45, i32 %Temp_56
  %Temp_58 = bitcast i8* %Temp_57 to i8**
  %Temp_59 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_11 = bitcast i8** %Temp_58 to i32*
store i32 1, i32* %Temp_init_ptr_11,align 4
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32**
  store i32* %Temp_59, i32** %Temp_actual_11, align 8
  store i8* %Temp_45, i8** %local_3, align 8
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_61 = add nsw i32 %zero_20, 32
  %Temp_62 = call i32* @malloc(i32 %Temp_61)
  %Temp_60 = bitcast i32* %Temp_62 to i8*
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_63 = add nsw i32 %zero_21, 0
;getlement temp temp temp;
  %Temp_64 = getelementptr inbounds i8, i8* %Temp_60, i32 %Temp_63
  %Temp_65 = bitcast i8* %Temp_64 to i32*
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_66 = add nsw i32 %zero_22, 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_65 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_66, i32* %Temp_actual_12, align 4
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_67 = add nsw i32 %zero_23, 8
;getlement temp temp temp;
  %Temp_68 = getelementptr inbounds i8, i8* %Temp_60, i32 %Temp_67
  %Temp_69 = bitcast i8* %Temp_68 to i8**
  %Temp_70 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_13 = bitcast i8** %Temp_69 to i32*
store i32 1, i32* %Temp_init_ptr_13,align 4
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i32**
  store i32* %Temp_70, i32** %Temp_actual_13, align 8
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_24, 20
;getlement temp temp temp;
  %Temp_72 = getelementptr inbounds i8, i8* %Temp_60, i32 %Temp_71
  %Temp_73 = bitcast i8* %Temp_72 to i8**
  %Temp_74 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_14 = bitcast i8** %Temp_73 to i32*
store i32 1, i32* %Temp_init_ptr_14,align 4
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32**
  store i32* %Temp_74, i32** %Temp_actual_14, align 8
  store i8* %Temp_60, i8** %local_4, align 8
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_76 = add nsw i32 %zero_25, 32
  %Temp_77 = call i32* @malloc(i32 %Temp_76)
  %Temp_75 = bitcast i32* %Temp_77 to i8*
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_78 = add nsw i32 %zero_26, 0
;getlement temp temp temp;
  %Temp_79 = getelementptr inbounds i8, i8* %Temp_75, i32 %Temp_78
  %Temp_80 = bitcast i8* %Temp_79 to i32*
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_27, 0
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_15 = bitcast i32* %Temp_80 to i32*
store i32 1, i32* %Temp_init_ptr_15,align 4
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  store i32 %Temp_81, i32* %Temp_actual_15, align 4
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_82 = add nsw i32 %zero_28, 8
;getlement temp temp temp;
  %Temp_83 = getelementptr inbounds i8, i8* %Temp_75, i32 %Temp_82
  %Temp_84 = bitcast i8* %Temp_83 to i8**
  %Temp_85 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_16 = bitcast i8** %Temp_84 to i32*
store i32 1, i32* %Temp_init_ptr_16,align 4
%Temp_actual_ptr_16 = getelementptr inbounds i32, i32* %Temp_init_ptr_16, i32 1
%Temp_actual_16 = bitcast i32* %Temp_actual_ptr_16 to i32**
  store i32* %Temp_85, i32** %Temp_actual_16, align 8
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_29, 20
;getlement temp temp temp;
  %Temp_87 = getelementptr inbounds i8, i8* %Temp_75, i32 %Temp_86
  %Temp_88 = bitcast i8* %Temp_87 to i8**
  %Temp_89 = load i32*, i32** @my_null, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_17 = bitcast i8** %Temp_88 to i32*
store i32 1, i32* %Temp_init_ptr_17,align 4
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32**
  store i32* %Temp_89, i32** %Temp_actual_17, align 8
  store i8* %Temp_75, i8** %local_5, align 8
  %Temp_90 = load i8*, i8** %local_0, align 8
%Temp_null_18 = bitcast i8* %Temp_90 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_30, 0
;getlement temp temp temp;
  %Temp_92 = getelementptr inbounds i8, i8* %Temp_90, i32 %Temp_91
  %Temp_93 = bitcast i8* %Temp_92 to i32*
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_94 = add nsw i32 %zero_31, 1
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_19 = bitcast i32* %Temp_93 to i32*
store i32 1, i32* %Temp_init_ptr_19,align 4
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32*
  store i32 %Temp_94, i32* %Temp_actual_19, align 4
  %Temp_95 = load i8*, i8** %local_1, align 8
%Temp_null_20 = bitcast i8* %Temp_95 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_96 = add nsw i32 %zero_32, 0
;getlement temp temp temp;
  %Temp_97 = getelementptr inbounds i8, i8* %Temp_95, i32 %Temp_96
  %Temp_98 = bitcast i8* %Temp_97 to i32*
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_99 = add nsw i32 %zero_33, 3
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_21 = bitcast i32* %Temp_98 to i32*
store i32 1, i32* %Temp_init_ptr_21,align 4
%Temp_actual_ptr_21 = getelementptr inbounds i32, i32* %Temp_init_ptr_21, i32 1
%Temp_actual_21 = bitcast i32* %Temp_actual_ptr_21 to i32*
  store i32 %Temp_99, i32* %Temp_actual_21, align 4
  %Temp_100 = load i8*, i8** %local_2, align 8
%Temp_null_22 = bitcast i8* %Temp_100 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_101 = add nsw i32 %zero_34, 0
;getlement temp temp temp;
  %Temp_102 = getelementptr inbounds i8, i8* %Temp_100, i32 %Temp_101
  %Temp_103 = bitcast i8* %Temp_102 to i32*
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_104 = add nsw i32 %zero_35, 2
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_23 = bitcast i32* %Temp_103 to i32*
store i32 1, i32* %Temp_init_ptr_23,align 4
%Temp_actual_ptr_23 = getelementptr inbounds i32, i32* %Temp_init_ptr_23, i32 1
%Temp_actual_23 = bitcast i32* %Temp_actual_ptr_23 to i32*
  store i32 %Temp_104, i32* %Temp_actual_23, align 4
  %Temp_105 = load i8*, i8** %local_3, align 8
%Temp_null_24 = bitcast i8* %Temp_105 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_106 = add nsw i32 %zero_36, 0
;getlement temp temp temp;
  %Temp_107 = getelementptr inbounds i8, i8* %Temp_105, i32 %Temp_106
  %Temp_108 = bitcast i8* %Temp_107 to i32*
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_109 = add nsw i32 %zero_37, 4
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_25 = bitcast i32* %Temp_108 to i32*
store i32 1, i32* %Temp_init_ptr_25,align 4
%Temp_actual_ptr_25 = getelementptr inbounds i32, i32* %Temp_init_ptr_25, i32 1
%Temp_actual_25 = bitcast i32* %Temp_actual_ptr_25 to i32*
  store i32 %Temp_109, i32* %Temp_actual_25, align 4
  %Temp_110 = load i8*, i8** %local_4, align 8
%Temp_null_26 = bitcast i8* %Temp_110 to i32*
%equal_null_26 = icmp eq i32* %Temp_null_26, null
br i1 %equal_null_26, label %null_deref_26, label %continue_26
null_deref_26:
call void @InvalidPointer()
br label %continue_26
continue_26:
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_38, 0
;getlement temp temp temp;
  %Temp_112 = getelementptr inbounds i8, i8* %Temp_110, i32 %Temp_111
  %Temp_113 = bitcast i8* %Temp_112 to i32*
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_114 = add nsw i32 %zero_39, 5
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_27 = bitcast i32* %Temp_113 to i32*
store i32 1, i32* %Temp_init_ptr_27,align 4
%Temp_actual_ptr_27 = getelementptr inbounds i32, i32* %Temp_init_ptr_27, i32 1
%Temp_actual_27 = bitcast i32* %Temp_actual_ptr_27 to i32*
  store i32 %Temp_114, i32* %Temp_actual_27, align 4
  %Temp_115 = load i8*, i8** %local_5, align 8
%Temp_null_28 = bitcast i8* %Temp_115 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_116 = add nsw i32 %zero_40, 0
;getlement temp temp temp;
  %Temp_117 = getelementptr inbounds i8, i8* %Temp_115, i32 %Temp_116
  %Temp_118 = bitcast i8* %Temp_117 to i32*
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_119 = add nsw i32 %zero_41, 6
;store TYPES.TYPE_INT@2e5d6d97 dst src;
%Temp_init_ptr_29 = bitcast i32* %Temp_118 to i32*
store i32 1, i32* %Temp_init_ptr_29,align 4
%Temp_actual_ptr_29 = getelementptr inbounds i32, i32* %Temp_init_ptr_29, i32 1
%Temp_actual_29 = bitcast i32* %Temp_actual_ptr_29 to i32*
  store i32 %Temp_119, i32* %Temp_actual_29, align 4
  %Temp_120 = load i8*, i8** %local_0, align 8
%Temp_null_30 = bitcast i8* %Temp_120 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_121 = add nsw i32 %zero_42, 20
;getlement temp temp temp;
  %Temp_122 = getelementptr inbounds i8, i8* %Temp_120, i32 %Temp_121
  %Temp_123 = bitcast i8* %Temp_122 to i8**
  %Temp_124 = load i8*, i8** %local_1, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_31 = bitcast i8** %Temp_123 to i32*
store i32 1, i32* %Temp_init_ptr_31,align 4
%Temp_actual_ptr_31 = getelementptr inbounds i32, i32* %Temp_init_ptr_31, i32 1
%Temp_actual_31 = bitcast i32* %Temp_actual_ptr_31 to i8**
  store i8* %Temp_124, i8** %Temp_actual_31, align 8
  %Temp_125 = load i8*, i8** %local_0, align 8
%Temp_null_32 = bitcast i8* %Temp_125 to i32*
%equal_null_32 = icmp eq i32* %Temp_null_32, null
br i1 %equal_null_32, label %null_deref_32, label %continue_32
null_deref_32:
call void @InvalidPointer()
br label %continue_32
continue_32:
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_126 = add nsw i32 %zero_43, 8
;getlement temp temp temp;
  %Temp_127 = getelementptr inbounds i8, i8* %Temp_125, i32 %Temp_126
  %Temp_128 = bitcast i8* %Temp_127 to i8**
  %Temp_129 = load i8*, i8** %local_3, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_33 = bitcast i8** %Temp_128 to i32*
store i32 1, i32* %Temp_init_ptr_33,align 4
%Temp_actual_ptr_33 = getelementptr inbounds i32, i32* %Temp_init_ptr_33, i32 1
%Temp_actual_33 = bitcast i32* %Temp_actual_ptr_33 to i8**
  store i8* %Temp_129, i8** %Temp_actual_33, align 8
  %Temp_130 = load i8*, i8** %local_1, align 8
%Temp_null_34 = bitcast i8* %Temp_130 to i32*
%equal_null_34 = icmp eq i32* %Temp_null_34, null
br i1 %equal_null_34, label %null_deref_34, label %continue_34
null_deref_34:
call void @InvalidPointer()
br label %continue_34
continue_34:
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_131 = add nsw i32 %zero_44, 8
;getlement temp temp temp;
  %Temp_132 = getelementptr inbounds i8, i8* %Temp_130, i32 %Temp_131
  %Temp_133 = bitcast i8* %Temp_132 to i8**
  %Temp_134 = load i8*, i8** %local_2, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_35 = bitcast i8** %Temp_133 to i32*
store i32 1, i32* %Temp_init_ptr_35,align 4
%Temp_actual_ptr_35 = getelementptr inbounds i32, i32* %Temp_init_ptr_35, i32 1
%Temp_actual_35 = bitcast i32* %Temp_actual_ptr_35 to i8**
  store i8* %Temp_134, i8** %Temp_actual_35, align 8
  %Temp_135 = load i8*, i8** %local_3, align 8
%Temp_null_36 = bitcast i8* %Temp_135 to i32*
%equal_null_36 = icmp eq i32* %Temp_null_36, null
br i1 %equal_null_36, label %null_deref_36, label %continue_36
null_deref_36:
call void @InvalidPointer()
br label %continue_36
continue_36:
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_136 = add nsw i32 %zero_45, 20
;getlement temp temp temp;
  %Temp_137 = getelementptr inbounds i8, i8* %Temp_135, i32 %Temp_136
  %Temp_138 = bitcast i8* %Temp_137 to i8**
  %Temp_139 = load i8*, i8** %local_4, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_37 = bitcast i8** %Temp_138 to i32*
store i32 1, i32* %Temp_init_ptr_37,align 4
%Temp_actual_ptr_37 = getelementptr inbounds i32, i32* %Temp_init_ptr_37, i32 1
%Temp_actual_37 = bitcast i32* %Temp_actual_ptr_37 to i8**
  store i8* %Temp_139, i8** %Temp_actual_37, align 8
  %Temp_140 = load i8*, i8** %local_3, align 8
%Temp_null_38 = bitcast i8* %Temp_140 to i32*
%equal_null_38 = icmp eq i32* %Temp_null_38, null
br i1 %equal_null_38, label %null_deref_38, label %continue_38
null_deref_38:
call void @InvalidPointer()
br label %continue_38
continue_38:
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_141 = add nsw i32 %zero_46, 8
;getlement temp temp temp;
  %Temp_142 = getelementptr inbounds i8, i8* %Temp_140, i32 %Temp_141
  %Temp_143 = bitcast i8* %Temp_142 to i8**
  %Temp_144 = load i8*, i8** %local_5, align 8
;store TYPES.TYPE_CLASS@238e0d81 dst src;
%Temp_init_ptr_39 = bitcast i8** %Temp_143 to i32*
store i32 1, i32* %Temp_init_ptr_39,align 4
%Temp_actual_ptr_39 = getelementptr inbounds i32, i32* %Temp_init_ptr_39, i32 1
%Temp_actual_39 = bitcast i32* %Temp_actual_ptr_39 to i8**
  store i8* %Temp_144, i8** %Temp_actual_39, align 8
call void @exit(i32 0)
  ret void
}
