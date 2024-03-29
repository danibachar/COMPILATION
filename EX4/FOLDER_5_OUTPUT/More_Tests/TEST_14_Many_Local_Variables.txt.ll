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

define i32 @foo()
 { 
  %local_8 = alloca i32, align 4
  %local_26 = alloca i32, align 4
  %local_13 = alloca i32, align 4
  %local_31 = alloca i32, align 4
  %local_0 = alloca i32, align 4
  %local_18 = alloca i32, align 4
  %local_5 = alloca i32, align 4
  %local_23 = alloca i32, align 4
  %local_10 = alloca i32, align 4
  %local_28 = alloca i32, align 4
  %local_15 = alloca i32, align 4
  %local_2 = alloca i32, align 4
  %local_20 = alloca i32, align 4
  %local_7 = alloca i32, align 4
  %local_25 = alloca i32, align 4
  %local_12 = alloca i32, align 4
  %local_30 = alloca i32, align 4
  %local_17 = alloca i32, align 4
  %local_4 = alloca i32, align 4
  %local_22 = alloca i32, align 4
  %local_9 = alloca i32, align 4
  %local_27 = alloca i32, align 4
  %local_14 = alloca i32, align 4
  %local_1 = alloca i32, align 4
  %local_19 = alloca i32, align 4
  %local_6 = alloca i32, align 4
  %local_24 = alloca i32, align 4
  %local_11 = alloca i32, align 4
  %local_29 = alloca i32, align 4
  %local_16 = alloca i32, align 4
  %local_3 = alloca i32, align 4
  %local_21 = alloca i32, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 1
  store i32 %Temp_0, i32* %local_0, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_1, 2
  store i32 %Temp_1, i32* %local_1, align 4
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_2, 3
  store i32 %Temp_2, i32* %local_2, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_3, 4
  store i32 %Temp_3, i32* %local_3, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_4, 5
  store i32 %Temp_4, i32* %local_4, align 4
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_5, 6
  store i32 %Temp_5, i32* %local_5, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_6, 7
  store i32 %Temp_6, i32* %local_6, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_7, 8
  store i32 %Temp_7, i32* %local_7, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_8, 9
  store i32 %Temp_8, i32* %local_8, align 4
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_9, 10
  store i32 %Temp_9, i32* %local_9, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_10, 11
  store i32 %Temp_10, i32* %local_10, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_11, 12
  store i32 %Temp_11, i32* %local_11, align 4
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_12, 13
  store i32 %Temp_12, i32* %local_12, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_13, 14
  store i32 %Temp_13, i32* %local_13, align 4
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_14, 15
  store i32 %Temp_14, i32* %local_14, align 4
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_15, 16
  store i32 %Temp_15, i32* %local_15, align 4
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_16, 17
  store i32 %Temp_16, i32* %local_16, align 4
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_17, 18
  store i32 %Temp_17, i32* %local_17, align 4
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_18, 19
  store i32 %Temp_18, i32* %local_18, align 4
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_19 = add nsw i32 %zero_19, 20
  store i32 %Temp_19, i32* %local_19, align 4
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_20, 21
  store i32 %Temp_20, i32* %local_20, align 4
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_21, 22
  store i32 %Temp_21, i32* %local_21, align 4
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_22, 23
  store i32 %Temp_22, i32* %local_22, align 4
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_23, 24
  store i32 %Temp_23, i32* %local_23, align 4
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_24, 25
  store i32 %Temp_24, i32* %local_24, align 4
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_25, 26
  store i32 %Temp_25, i32* %local_25, align 4
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_26, 27
  store i32 %Temp_26, i32* %local_26, align 4
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_27 = add nsw i32 %zero_27, 28
  store i32 %Temp_27, i32* %local_27, align 4
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_28, 29
  store i32 %Temp_28, i32* %local_28, align 4
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_29, 30
  store i32 %Temp_29, i32* %local_29, align 4
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_30 = add nsw i32 %zero_30, 31
  store i32 %Temp_30, i32* %local_30, align 4
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_31, 32
  store i32 %Temp_31, i32* %local_31, align 4
  %Temp_63 = load i32, i32* %local_0, align 4
  %Temp_64 = load i32, i32* %local_1, align 4
  %Temp_62 = add nsw i32 %Temp_63, %Temp_64
%Temp_65 = call i32 @CheckOverflow(i32 %Temp_62)
  %Temp_66 = load i32, i32* %local_2, align 4
  %Temp_61 = add nsw i32 %Temp_65, %Temp_66
%Temp_67 = call i32 @CheckOverflow(i32 %Temp_61)
  %Temp_68 = load i32, i32* %local_3, align 4
  %Temp_60 = add nsw i32 %Temp_67, %Temp_68
%Temp_69 = call i32 @CheckOverflow(i32 %Temp_60)
  %Temp_70 = load i32, i32* %local_4, align 4
  %Temp_59 = add nsw i32 %Temp_69, %Temp_70
%Temp_71 = call i32 @CheckOverflow(i32 %Temp_59)
  %Temp_72 = load i32, i32* %local_5, align 4
  %Temp_58 = add nsw i32 %Temp_71, %Temp_72
%Temp_73 = call i32 @CheckOverflow(i32 %Temp_58)
  %Temp_74 = load i32, i32* %local_6, align 4
  %Temp_57 = add nsw i32 %Temp_73, %Temp_74
%Temp_75 = call i32 @CheckOverflow(i32 %Temp_57)
  %Temp_76 = load i32, i32* %local_7, align 4
  %Temp_56 = add nsw i32 %Temp_75, %Temp_76
%Temp_77 = call i32 @CheckOverflow(i32 %Temp_56)
  %Temp_78 = load i32, i32* %local_8, align 4
  %Temp_55 = add nsw i32 %Temp_77, %Temp_78
%Temp_79 = call i32 @CheckOverflow(i32 %Temp_55)
  %Temp_80 = load i32, i32* %local_9, align 4
  %Temp_54 = add nsw i32 %Temp_79, %Temp_80
%Temp_81 = call i32 @CheckOverflow(i32 %Temp_54)
  %Temp_82 = load i32, i32* %local_10, align 4
  %Temp_53 = add nsw i32 %Temp_81, %Temp_82
%Temp_83 = call i32 @CheckOverflow(i32 %Temp_53)
  %Temp_84 = load i32, i32* %local_11, align 4
  %Temp_52 = add nsw i32 %Temp_83, %Temp_84
%Temp_85 = call i32 @CheckOverflow(i32 %Temp_52)
  %Temp_86 = load i32, i32* %local_12, align 4
  %Temp_51 = add nsw i32 %Temp_85, %Temp_86
%Temp_87 = call i32 @CheckOverflow(i32 %Temp_51)
  %Temp_88 = load i32, i32* %local_13, align 4
  %Temp_50 = add nsw i32 %Temp_87, %Temp_88
%Temp_89 = call i32 @CheckOverflow(i32 %Temp_50)
  %Temp_90 = load i32, i32* %local_14, align 4
  %Temp_49 = add nsw i32 %Temp_89, %Temp_90
%Temp_91 = call i32 @CheckOverflow(i32 %Temp_49)
  %Temp_92 = load i32, i32* %local_15, align 4
  %Temp_48 = add nsw i32 %Temp_91, %Temp_92
%Temp_93 = call i32 @CheckOverflow(i32 %Temp_48)
  %Temp_94 = load i32, i32* %local_16, align 4
  %Temp_47 = add nsw i32 %Temp_93, %Temp_94
%Temp_95 = call i32 @CheckOverflow(i32 %Temp_47)
  %Temp_96 = load i32, i32* %local_17, align 4
  %Temp_46 = add nsw i32 %Temp_95, %Temp_96
%Temp_97 = call i32 @CheckOverflow(i32 %Temp_46)
  %Temp_98 = load i32, i32* %local_18, align 4
  %Temp_45 = add nsw i32 %Temp_97, %Temp_98
%Temp_99 = call i32 @CheckOverflow(i32 %Temp_45)
  %Temp_100 = load i32, i32* %local_19, align 4
  %Temp_44 = add nsw i32 %Temp_99, %Temp_100
%Temp_101 = call i32 @CheckOverflow(i32 %Temp_44)
  %Temp_102 = load i32, i32* %local_20, align 4
  %Temp_43 = add nsw i32 %Temp_101, %Temp_102
%Temp_103 = call i32 @CheckOverflow(i32 %Temp_43)
  %Temp_104 = load i32, i32* %local_21, align 4
  %Temp_42 = add nsw i32 %Temp_103, %Temp_104
%Temp_105 = call i32 @CheckOverflow(i32 %Temp_42)
  %Temp_106 = load i32, i32* %local_22, align 4
  %Temp_41 = add nsw i32 %Temp_105, %Temp_106
%Temp_107 = call i32 @CheckOverflow(i32 %Temp_41)
  %Temp_108 = load i32, i32* %local_23, align 4
  %Temp_40 = add nsw i32 %Temp_107, %Temp_108
%Temp_109 = call i32 @CheckOverflow(i32 %Temp_40)
  %Temp_110 = load i32, i32* %local_24, align 4
  %Temp_39 = add nsw i32 %Temp_109, %Temp_110
%Temp_111 = call i32 @CheckOverflow(i32 %Temp_39)
  %Temp_112 = load i32, i32* %local_25, align 4
  %Temp_38 = add nsw i32 %Temp_111, %Temp_112
%Temp_113 = call i32 @CheckOverflow(i32 %Temp_38)
  %Temp_114 = load i32, i32* %local_26, align 4
  %Temp_37 = add nsw i32 %Temp_113, %Temp_114
%Temp_115 = call i32 @CheckOverflow(i32 %Temp_37)
  %Temp_116 = load i32, i32* %local_27, align 4
  %Temp_36 = add nsw i32 %Temp_115, %Temp_116
%Temp_117 = call i32 @CheckOverflow(i32 %Temp_36)
  %Temp_118 = load i32, i32* %local_28, align 4
  %Temp_35 = add nsw i32 %Temp_117, %Temp_118
%Temp_119 = call i32 @CheckOverflow(i32 %Temp_35)
  %Temp_120 = load i32, i32* %local_29, align 4
  %Temp_34 = add nsw i32 %Temp_119, %Temp_120
%Temp_121 = call i32 @CheckOverflow(i32 %Temp_34)
  %Temp_122 = load i32, i32* %local_30, align 4
  %Temp_33 = add nsw i32 %Temp_121, %Temp_122
%Temp_123 = call i32 @CheckOverflow(i32 %Temp_33)
  %Temp_124 = load i32, i32* %local_31, align 4
  %Temp_32 = add nsw i32 %Temp_123, %Temp_124
%Temp_125 = call i32 @CheckOverflow(i32 %Temp_32)
  ret i32 %Temp_125
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  call void @init_globals()
%Temp_126 =call i32 @foo()
  call void @PrintInt(i32 %Temp_126 )
call void @exit(i32 0)
  ret void
}
