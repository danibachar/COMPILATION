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

define void @PrintPtr(i32* %p)
{
  %Temp1_66  = ptrtoint i32* %p to i32
  call void @PrintInt(i32 %Temp1_66 )
  ret void
}

@.str1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
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

define i32 @sum()
 { 
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 4
  ret i32 %Temp_0
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8*, align 8
  call void @init_globals()
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_1, 256
  %Temp_3 = call i32* @malloc(i32 %Temp_2)
  %Temp_1 = bitcast i32* %Temp_3 to i8*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_2, 0
;getlement temp temp temp;
  %Temp_5 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_4
  %Temp_6 = bitcast i8* %Temp_5 to i32*
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_3, 32
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_6 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_7, i32* %Temp_actual_0, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_4, 8
;getlement temp temp temp;
  %Temp_9 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_8
  %Temp_10 = bitcast i8* %Temp_9 to i32*
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_5, 31
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_10 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_11, i32* %Temp_actual_1, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_6, 16
;getlement temp temp temp;
  %Temp_13 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_12
  %Temp_14 = bitcast i8* %Temp_13 to i32*
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_7, 30
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_2 = bitcast i32* %Temp_14 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  store i32 %Temp_15, i32* %Temp_actual_2, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_8, 24
;getlement temp temp temp;
  %Temp_17 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_16
  %Temp_18 = bitcast i8* %Temp_17 to i32*
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_9, 29
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_3 = bitcast i32* %Temp_18 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  store i32 %Temp_19, i32* %Temp_actual_3, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_10, 32
;getlement temp temp temp;
  %Temp_21 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_20
  %Temp_22 = bitcast i8* %Temp_21 to i32*
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_11, 28
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_4 = bitcast i32* %Temp_22 to i32*
store i32 1, i32* %Temp_init_ptr_4,align 4
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  store i32 %Temp_23, i32* %Temp_actual_4, align 4
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_12, 40
;getlement temp temp temp;
  %Temp_25 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_24
  %Temp_26 = bitcast i8* %Temp_25 to i32*
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_13, 27
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_5 = bitcast i32* %Temp_26 to i32*
store i32 1, i32* %Temp_init_ptr_5,align 4
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  store i32 %Temp_27, i32* %Temp_actual_5, align 4
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_14, 48
;getlement temp temp temp;
  %Temp_29 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_28
  %Temp_30 = bitcast i8* %Temp_29 to i32*
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_15, 26
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_6 = bitcast i32* %Temp_30 to i32*
store i32 1, i32* %Temp_init_ptr_6,align 4
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i32*
  store i32 %Temp_31, i32* %Temp_actual_6, align 4
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_16, 56
;getlement temp temp temp;
  %Temp_33 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_32
  %Temp_34 = bitcast i8* %Temp_33 to i32*
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_35 = add nsw i32 %zero_17, 25
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_7 = bitcast i32* %Temp_34 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i32*
  store i32 %Temp_35, i32* %Temp_actual_7, align 4
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_18, 64
;getlement temp temp temp;
  %Temp_37 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_36
  %Temp_38 = bitcast i8* %Temp_37 to i32*
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_19, 24
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_8 = bitcast i32* %Temp_38 to i32*
store i32 1, i32* %Temp_init_ptr_8,align 4
%Temp_actual_ptr_8 = getelementptr inbounds i32, i32* %Temp_init_ptr_8, i32 1
%Temp_actual_8 = bitcast i32* %Temp_actual_ptr_8 to i32*
  store i32 %Temp_39, i32* %Temp_actual_8, align 4
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_20, 72
;getlement temp temp temp;
  %Temp_41 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_40
  %Temp_42 = bitcast i8* %Temp_41 to i32*
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_43 = add nsw i32 %zero_21, 23
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_9 = bitcast i32* %Temp_42 to i32*
store i32 1, i32* %Temp_init_ptr_9,align 4
%Temp_actual_ptr_9 = getelementptr inbounds i32, i32* %Temp_init_ptr_9, i32 1
%Temp_actual_9 = bitcast i32* %Temp_actual_ptr_9 to i32*
  store i32 %Temp_43, i32* %Temp_actual_9, align 4
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_22, 80
;getlement temp temp temp;
  %Temp_45 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_44
  %Temp_46 = bitcast i8* %Temp_45 to i32*
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_47 = add nsw i32 %zero_23, 22
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_10 = bitcast i32* %Temp_46 to i32*
store i32 1, i32* %Temp_init_ptr_10,align 4
%Temp_actual_ptr_10 = getelementptr inbounds i32, i32* %Temp_init_ptr_10, i32 1
%Temp_actual_10 = bitcast i32* %Temp_actual_ptr_10 to i32*
  store i32 %Temp_47, i32* %Temp_actual_10, align 4
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_48 = add nsw i32 %zero_24, 88
;getlement temp temp temp;
  %Temp_49 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_48
  %Temp_50 = bitcast i8* %Temp_49 to i32*
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_25, 21
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_11 = bitcast i32* %Temp_50 to i32*
store i32 1, i32* %Temp_init_ptr_11,align 4
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  store i32 %Temp_51, i32* %Temp_actual_11, align 4
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_52 = add nsw i32 %zero_26, 96
;getlement temp temp temp;
  %Temp_53 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_52
  %Temp_54 = bitcast i8* %Temp_53 to i32*
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_55 = add nsw i32 %zero_27, 20
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_12 = bitcast i32* %Temp_54 to i32*
store i32 1, i32* %Temp_init_ptr_12,align 4
%Temp_actual_ptr_12 = getelementptr inbounds i32, i32* %Temp_init_ptr_12, i32 1
%Temp_actual_12 = bitcast i32* %Temp_actual_ptr_12 to i32*
  store i32 %Temp_55, i32* %Temp_actual_12, align 4
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_28, 104
;getlement temp temp temp;
  %Temp_57 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_56
  %Temp_58 = bitcast i8* %Temp_57 to i32*
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_59 = add nsw i32 %zero_29, 19
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_13 = bitcast i32* %Temp_58 to i32*
store i32 1, i32* %Temp_init_ptr_13,align 4
%Temp_actual_ptr_13 = getelementptr inbounds i32, i32* %Temp_init_ptr_13, i32 1
%Temp_actual_13 = bitcast i32* %Temp_actual_ptr_13 to i32*
  store i32 %Temp_59, i32* %Temp_actual_13, align 4
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_60 = add nsw i32 %zero_30, 112
;getlement temp temp temp;
  %Temp_61 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_60
  %Temp_62 = bitcast i8* %Temp_61 to i32*
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_63 = add nsw i32 %zero_31, 18
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_14 = bitcast i32* %Temp_62 to i32*
store i32 1, i32* %Temp_init_ptr_14,align 4
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i32*
  store i32 %Temp_63, i32* %Temp_actual_14, align 4
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_64 = add nsw i32 %zero_32, 120
;getlement temp temp temp;
  %Temp_65 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_64
  %Temp_66 = bitcast i8* %Temp_65 to i32*
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_67 = add nsw i32 %zero_33, 17
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_15 = bitcast i32* %Temp_66 to i32*
store i32 1, i32* %Temp_init_ptr_15,align 4
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i32*
  store i32 %Temp_67, i32* %Temp_actual_15, align 4
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_68 = add nsw i32 %zero_34, 128
;getlement temp temp temp;
  %Temp_69 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_68
  %Temp_70 = bitcast i8* %Temp_69 to i32*
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_35, 16
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_16 = bitcast i32* %Temp_70 to i32*
store i32 1, i32* %Temp_init_ptr_16,align 4
%Temp_actual_ptr_16 = getelementptr inbounds i32, i32* %Temp_init_ptr_16, i32 1
%Temp_actual_16 = bitcast i32* %Temp_actual_ptr_16 to i32*
  store i32 %Temp_71, i32* %Temp_actual_16, align 4
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_72 = add nsw i32 %zero_36, 136
;getlement temp temp temp;
  %Temp_73 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_72
  %Temp_74 = bitcast i8* %Temp_73 to i32*
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_75 = add nsw i32 %zero_37, 15
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_17 = bitcast i32* %Temp_74 to i32*
store i32 1, i32* %Temp_init_ptr_17,align 4
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  store i32 %Temp_75, i32* %Temp_actual_17, align 4
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_76 = add nsw i32 %zero_38, 144
;getlement temp temp temp;
  %Temp_77 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_76
  %Temp_78 = bitcast i8* %Temp_77 to i32*
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_79 = add nsw i32 %zero_39, 14
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_18 = bitcast i32* %Temp_78 to i32*
store i32 1, i32* %Temp_init_ptr_18,align 4
%Temp_actual_ptr_18 = getelementptr inbounds i32, i32* %Temp_init_ptr_18, i32 1
%Temp_actual_18 = bitcast i32* %Temp_actual_ptr_18 to i32*
  store i32 %Temp_79, i32* %Temp_actual_18, align 4
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_80 = add nsw i32 %zero_40, 152
;getlement temp temp temp;
  %Temp_81 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_80
  %Temp_82 = bitcast i8* %Temp_81 to i32*
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_83 = add nsw i32 %zero_41, 13
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_19 = bitcast i32* %Temp_82 to i32*
store i32 1, i32* %Temp_init_ptr_19,align 4
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32*
  store i32 %Temp_83, i32* %Temp_actual_19, align 4
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_42, 160
;getlement temp temp temp;
  %Temp_85 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_84
  %Temp_86 = bitcast i8* %Temp_85 to i32*
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_87 = add nsw i32 %zero_43, 12
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_20 = bitcast i32* %Temp_86 to i32*
store i32 1, i32* %Temp_init_ptr_20,align 4
%Temp_actual_ptr_20 = getelementptr inbounds i32, i32* %Temp_init_ptr_20, i32 1
%Temp_actual_20 = bitcast i32* %Temp_actual_ptr_20 to i32*
  store i32 %Temp_87, i32* %Temp_actual_20, align 4
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_88 = add nsw i32 %zero_44, 168
;getlement temp temp temp;
  %Temp_89 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_88
  %Temp_90 = bitcast i8* %Temp_89 to i32*
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_91 = add nsw i32 %zero_45, 11
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_21 = bitcast i32* %Temp_90 to i32*
store i32 1, i32* %Temp_init_ptr_21,align 4
%Temp_actual_ptr_21 = getelementptr inbounds i32, i32* %Temp_init_ptr_21, i32 1
%Temp_actual_21 = bitcast i32* %Temp_actual_ptr_21 to i32*
  store i32 %Temp_91, i32* %Temp_actual_21, align 4
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_92 = add nsw i32 %zero_46, 176
;getlement temp temp temp;
  %Temp_93 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_92
  %Temp_94 = bitcast i8* %Temp_93 to i32*
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_47, 10
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_22 = bitcast i32* %Temp_94 to i32*
store i32 1, i32* %Temp_init_ptr_22,align 4
%Temp_actual_ptr_22 = getelementptr inbounds i32, i32* %Temp_init_ptr_22, i32 1
%Temp_actual_22 = bitcast i32* %Temp_actual_ptr_22 to i32*
  store i32 %Temp_95, i32* %Temp_actual_22, align 4
  %zero_48 = load i32, i32* @my_zero, align 4
  %Temp_96 = add nsw i32 %zero_48, 184
;getlement temp temp temp;
  %Temp_97 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_96
  %Temp_98 = bitcast i8* %Temp_97 to i32*
  %zero_49 = load i32, i32* @my_zero, align 4
  %Temp_99 = add nsw i32 %zero_49, 9
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_23 = bitcast i32* %Temp_98 to i32*
store i32 1, i32* %Temp_init_ptr_23,align 4
%Temp_actual_ptr_23 = getelementptr inbounds i32, i32* %Temp_init_ptr_23, i32 1
%Temp_actual_23 = bitcast i32* %Temp_actual_ptr_23 to i32*
  store i32 %Temp_99, i32* %Temp_actual_23, align 4
  %zero_50 = load i32, i32* @my_zero, align 4
  %Temp_100 = add nsw i32 %zero_50, 192
;getlement temp temp temp;
  %Temp_101 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_100
  %Temp_102 = bitcast i8* %Temp_101 to i32*
  %zero_51 = load i32, i32* @my_zero, align 4
  %Temp_103 = add nsw i32 %zero_51, 8
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_24 = bitcast i32* %Temp_102 to i32*
store i32 1, i32* %Temp_init_ptr_24,align 4
%Temp_actual_ptr_24 = getelementptr inbounds i32, i32* %Temp_init_ptr_24, i32 1
%Temp_actual_24 = bitcast i32* %Temp_actual_ptr_24 to i32*
  store i32 %Temp_103, i32* %Temp_actual_24, align 4
  %zero_52 = load i32, i32* @my_zero, align 4
  %Temp_104 = add nsw i32 %zero_52, 200
;getlement temp temp temp;
  %Temp_105 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_104
  %Temp_106 = bitcast i8* %Temp_105 to i32*
  %zero_53 = load i32, i32* @my_zero, align 4
  %Temp_107 = add nsw i32 %zero_53, 7
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_25 = bitcast i32* %Temp_106 to i32*
store i32 1, i32* %Temp_init_ptr_25,align 4
%Temp_actual_ptr_25 = getelementptr inbounds i32, i32* %Temp_init_ptr_25, i32 1
%Temp_actual_25 = bitcast i32* %Temp_actual_ptr_25 to i32*
  store i32 %Temp_107, i32* %Temp_actual_25, align 4
  %zero_54 = load i32, i32* @my_zero, align 4
  %Temp_108 = add nsw i32 %zero_54, 208
;getlement temp temp temp;
  %Temp_109 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_108
  %Temp_110 = bitcast i8* %Temp_109 to i32*
  %zero_55 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_55, 6
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_26 = bitcast i32* %Temp_110 to i32*
store i32 1, i32* %Temp_init_ptr_26,align 4
%Temp_actual_ptr_26 = getelementptr inbounds i32, i32* %Temp_init_ptr_26, i32 1
%Temp_actual_26 = bitcast i32* %Temp_actual_ptr_26 to i32*
  store i32 %Temp_111, i32* %Temp_actual_26, align 4
  %zero_56 = load i32, i32* @my_zero, align 4
  %Temp_112 = add nsw i32 %zero_56, 216
;getlement temp temp temp;
  %Temp_113 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_112
  %Temp_114 = bitcast i8* %Temp_113 to i32*
  %zero_57 = load i32, i32* @my_zero, align 4
  %Temp_115 = add nsw i32 %zero_57, 5
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_27 = bitcast i32* %Temp_114 to i32*
store i32 1, i32* %Temp_init_ptr_27,align 4
%Temp_actual_ptr_27 = getelementptr inbounds i32, i32* %Temp_init_ptr_27, i32 1
%Temp_actual_27 = bitcast i32* %Temp_actual_ptr_27 to i32*
  store i32 %Temp_115, i32* %Temp_actual_27, align 4
  %zero_58 = load i32, i32* @my_zero, align 4
  %Temp_116 = add nsw i32 %zero_58, 224
;getlement temp temp temp;
  %Temp_117 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_116
  %Temp_118 = bitcast i8* %Temp_117 to i32*
  %zero_59 = load i32, i32* @my_zero, align 4
  %Temp_119 = add nsw i32 %zero_59, 4
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_28 = bitcast i32* %Temp_118 to i32*
store i32 1, i32* %Temp_init_ptr_28,align 4
%Temp_actual_ptr_28 = getelementptr inbounds i32, i32* %Temp_init_ptr_28, i32 1
%Temp_actual_28 = bitcast i32* %Temp_actual_ptr_28 to i32*
  store i32 %Temp_119, i32* %Temp_actual_28, align 4
  %zero_60 = load i32, i32* @my_zero, align 4
  %Temp_120 = add nsw i32 %zero_60, 232
;getlement temp temp temp;
  %Temp_121 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_120
  %Temp_122 = bitcast i8* %Temp_121 to i32*
  %zero_61 = load i32, i32* @my_zero, align 4
  %Temp_123 = add nsw i32 %zero_61, 3
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_29 = bitcast i32* %Temp_122 to i32*
store i32 1, i32* %Temp_init_ptr_29,align 4
%Temp_actual_ptr_29 = getelementptr inbounds i32, i32* %Temp_init_ptr_29, i32 1
%Temp_actual_29 = bitcast i32* %Temp_actual_ptr_29 to i32*
  store i32 %Temp_123, i32* %Temp_actual_29, align 4
  %zero_62 = load i32, i32* @my_zero, align 4
  %Temp_124 = add nsw i32 %zero_62, 240
;getlement temp temp temp;
  %Temp_125 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_124
  %Temp_126 = bitcast i8* %Temp_125 to i32*
  %zero_63 = load i32, i32* @my_zero, align 4
  %Temp_127 = add nsw i32 %zero_63, 2
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_30 = bitcast i32* %Temp_126 to i32*
store i32 1, i32* %Temp_init_ptr_30,align 4
%Temp_actual_ptr_30 = getelementptr inbounds i32, i32* %Temp_init_ptr_30, i32 1
%Temp_actual_30 = bitcast i32* %Temp_actual_ptr_30 to i32*
  store i32 %Temp_127, i32* %Temp_actual_30, align 4
  %zero_64 = load i32, i32* @my_zero, align 4
  %Temp_128 = add nsw i32 %zero_64, 248
;getlement temp temp temp;
  %Temp_129 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_128
  %Temp_130 = bitcast i8* %Temp_129 to i32*
  %zero_65 = load i32, i32* @my_zero, align 4
  %Temp_131 = add nsw i32 %zero_65, 1
;store TYPES.TYPE_INT@179d3b25 dst src;
%Temp_init_ptr_31 = bitcast i32* %Temp_130 to i32*
store i32 1, i32* %Temp_init_ptr_31,align 4
%Temp_actual_ptr_31 = getelementptr inbounds i32, i32* %Temp_init_ptr_31, i32 1
%Temp_actual_31 = bitcast i32* %Temp_actual_ptr_31 to i32*
  store i32 %Temp_131, i32* %Temp_actual_31, align 4
  store i8* %Temp_1, i8** %local_0, align 8
%Temp_132 =call i32 @sum()
  call void @PrintInt(i32 %Temp_132 )
  ret void
}
