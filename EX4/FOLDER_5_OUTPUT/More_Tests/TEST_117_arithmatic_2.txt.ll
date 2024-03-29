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
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 1
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_1, 3
  %Temp_0 = mul nsw i32 %Temp_1, %Temp_2
%Temp_3 = call i32 @CheckOverflow(i32 %Temp_0)
  call void @PrintInt(i32 %Temp_3 )
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_2, -1
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_3, 3
  %Temp_4 = mul nsw i32 %Temp_5, %Temp_6
%Temp_7 = call i32 @CheckOverflow(i32 %Temp_4)
  call void @PrintInt(i32 %Temp_7 )
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_4, 1
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_5, -3
  %Temp_8 = mul nsw i32 %Temp_9, %Temp_10
%Temp_11 = call i32 @CheckOverflow(i32 %Temp_8)
  call void @PrintInt(i32 %Temp_11 )
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_6, 80
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_7, 190
  %Temp_12 = mul nsw i32 %Temp_13, %Temp_14
%Temp_15 = call i32 @CheckOverflow(i32 %Temp_12)
  call void @PrintInt(i32 %Temp_15 )
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_8, 32000
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_9, 1000
  %Temp_16 = mul nsw i32 %Temp_17, %Temp_18
%Temp_19 = call i32 @CheckOverflow(i32 %Temp_16)
  call void @PrintInt(i32 %Temp_19 )
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_10, 16384
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_11, 2
  %Temp_20 = mul nsw i32 %Temp_21, %Temp_22
%Temp_23 = call i32 @CheckOverflow(i32 %Temp_20)
  call void @PrintInt(i32 %Temp_23 )
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_12, 128
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_13, 256
  %Temp_24 = mul nsw i32 %Temp_25, %Temp_26
%Temp_27 = call i32 @CheckOverflow(i32 %Temp_24)
  call void @PrintInt(i32 %Temp_27 )
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_14, 3200
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_15, 100
  %Temp_32 = mul nsw i32 %Temp_33, %Temp_34
%Temp_35 = call i32 @CheckOverflow(i32 %Temp_32)
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_16, 10
  %Temp_31 = mul nsw i32 %Temp_35, %Temp_36
%Temp_37 = call i32 @CheckOverflow(i32 %Temp_31)
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_17, 10
  %Temp_30 = mul nsw i32 %Temp_37, %Temp_38
%Temp_39 = call i32 @CheckOverflow(i32 %Temp_30)
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_18, 10
  %Temp_29 = mul nsw i32 %Temp_39, %Temp_40
%Temp_41 = call i32 @CheckOverflow(i32 %Temp_29)
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_19, 1
  %Temp_28 = mul nsw i32 %Temp_41, %Temp_42
%Temp_43 = call i32 @CheckOverflow(i32 %Temp_28)
  call void @PrintInt(i32 %Temp_43 )
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_61 = add nsw i32 %zero_20, 2
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_21, 2
  %Temp_60 = mul nsw i32 %Temp_61, %Temp_62
%Temp_63 = call i32 @CheckOverflow(i32 %Temp_60)
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_64 = add nsw i32 %zero_22, 2
  %Temp_59 = mul nsw i32 %Temp_63, %Temp_64
%Temp_65 = call i32 @CheckOverflow(i32 %Temp_59)
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_66 = add nsw i32 %zero_23, 2
  %Temp_58 = mul nsw i32 %Temp_65, %Temp_66
%Temp_67 = call i32 @CheckOverflow(i32 %Temp_58)
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_68 = add nsw i32 %zero_24, 2
  %Temp_57 = mul nsw i32 %Temp_67, %Temp_68
%Temp_69 = call i32 @CheckOverflow(i32 %Temp_57)
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_70 = add nsw i32 %zero_25, 2
  %Temp_56 = mul nsw i32 %Temp_69, %Temp_70
%Temp_71 = call i32 @CheckOverflow(i32 %Temp_56)
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_72 = add nsw i32 %zero_26, 2
  %Temp_55 = mul nsw i32 %Temp_71, %Temp_72
%Temp_73 = call i32 @CheckOverflow(i32 %Temp_55)
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_74 = add nsw i32 %zero_27, 2
  %Temp_54 = mul nsw i32 %Temp_73, %Temp_74
%Temp_75 = call i32 @CheckOverflow(i32 %Temp_54)
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_76 = add nsw i32 %zero_28, 2
  %Temp_53 = mul nsw i32 %Temp_75, %Temp_76
%Temp_77 = call i32 @CheckOverflow(i32 %Temp_53)
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_78 = add nsw i32 %zero_29, 2
  %Temp_52 = mul nsw i32 %Temp_77, %Temp_78
%Temp_79 = call i32 @CheckOverflow(i32 %Temp_52)
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_80 = add nsw i32 %zero_30, 2
  %Temp_51 = mul nsw i32 %Temp_79, %Temp_80
%Temp_81 = call i32 @CheckOverflow(i32 %Temp_51)
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_82 = add nsw i32 %zero_31, 2
  %Temp_50 = mul nsw i32 %Temp_81, %Temp_82
%Temp_83 = call i32 @CheckOverflow(i32 %Temp_50)
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_32, 2
  %Temp_49 = mul nsw i32 %Temp_83, %Temp_84
%Temp_85 = call i32 @CheckOverflow(i32 %Temp_49)
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_86 = add nsw i32 %zero_33, 2
  %Temp_48 = mul nsw i32 %Temp_85, %Temp_86
%Temp_87 = call i32 @CheckOverflow(i32 %Temp_48)
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_88 = add nsw i32 %zero_34, 2
  %Temp_47 = mul nsw i32 %Temp_87, %Temp_88
%Temp_89 = call i32 @CheckOverflow(i32 %Temp_47)
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_90 = add nsw i32 %zero_35, 2
  %Temp_46 = mul nsw i32 %Temp_89, %Temp_90
%Temp_91 = call i32 @CheckOverflow(i32 %Temp_46)
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_92 = add nsw i32 %zero_36, 2
  %Temp_45 = mul nsw i32 %Temp_91, %Temp_92
%Temp_93 = call i32 @CheckOverflow(i32 %Temp_45)
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_94 = add nsw i32 %zero_37, 2
  %Temp_44 = mul nsw i32 %Temp_93, %Temp_94
%Temp_95 = call i32 @CheckOverflow(i32 %Temp_44)
  call void @PrintInt(i32 %Temp_95 )
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_100 = add nsw i32 %zero_38, 8
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_101 = add nsw i32 %zero_39, 8
  %Temp_99 = mul nsw i32 %Temp_100, %Temp_101
%Temp_102 = call i32 @CheckOverflow(i32 %Temp_99)
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_103 = add nsw i32 %zero_40, 8
  %Temp_98 = mul nsw i32 %Temp_102, %Temp_103
%Temp_104 = call i32 @CheckOverflow(i32 %Temp_98)
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_105 = add nsw i32 %zero_41, 8
  %Temp_97 = mul nsw i32 %Temp_104, %Temp_105
%Temp_106 = call i32 @CheckOverflow(i32 %Temp_97)
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_107 = add nsw i32 %zero_42, 8
  %Temp_96 = mul nsw i32 %Temp_106, %Temp_107
%Temp_108 = call i32 @CheckOverflow(i32 %Temp_96)
  call void @PrintInt(i32 %Temp_108 )
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_110 = add nsw i32 %zero_43, 32767
  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_111 = add nsw i32 %zero_44, 1
  %Temp_109 = mul nsw i32 %Temp_110, %Temp_111
%Temp_112 = call i32 @CheckOverflow(i32 %Temp_109)
  call void @PrintInt(i32 %Temp_112 )
  %zero_45 = load i32, i32* @my_zero, align 4
  %Temp_114 = add nsw i32 %zero_45, -256
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_115 = add nsw i32 %zero_46, 256
  %Temp_113 = mul nsw i32 %Temp_114, %Temp_115
%Temp_116 = call i32 @CheckOverflow(i32 %Temp_113)
  call void @PrintInt(i32 %Temp_116 )
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_118 = add nsw i32 %zero_47, -256
  %zero_48 = load i32, i32* @my_zero, align 4
  %Temp_119 = add nsw i32 %zero_48, -256
  %Temp_117 = mul nsw i32 %Temp_118, %Temp_119
%Temp_120 = call i32 @CheckOverflow(i32 %Temp_117)
  call void @PrintInt(i32 %Temp_120 )
  %zero_49 = load i32, i32* @my_zero, align 4
  %Temp_125 = add nsw i32 %zero_49, -8
  %zero_50 = load i32, i32* @my_zero, align 4
  %Temp_126 = add nsw i32 %zero_50, -8
  %Temp_124 = mul nsw i32 %Temp_125, %Temp_126
%Temp_127 = call i32 @CheckOverflow(i32 %Temp_124)
  %zero_51 = load i32, i32* @my_zero, align 4
  %Temp_128 = add nsw i32 %zero_51, -8
  %Temp_123 = mul nsw i32 %Temp_127, %Temp_128
%Temp_129 = call i32 @CheckOverflow(i32 %Temp_123)
  %zero_52 = load i32, i32* @my_zero, align 4
  %Temp_130 = add nsw i32 %zero_52, 8
  %Temp_122 = mul nsw i32 %Temp_129, %Temp_130
%Temp_131 = call i32 @CheckOverflow(i32 %Temp_122)
  %zero_53 = load i32, i32* @my_zero, align 4
  %Temp_132 = add nsw i32 %zero_53, 8
  %Temp_121 = mul nsw i32 %Temp_131, %Temp_132
%Temp_133 = call i32 @CheckOverflow(i32 %Temp_121)
  call void @PrintInt(i32 %Temp_133 )
  %zero_54 = load i32, i32* @my_zero, align 4
  %Temp_135 = add nsw i32 %zero_54, -32768
  %zero_55 = load i32, i32* @my_zero, align 4
  %Temp_136 = add nsw i32 %zero_55, -1
  %Temp_134 = mul nsw i32 %Temp_135, %Temp_136
%Temp_137 = call i32 @CheckOverflow(i32 %Temp_134)
  call void @PrintInt(i32 %Temp_137 )
  %zero_56 = load i32, i32* @my_zero, align 4
  %Temp_140 = add nsw i32 %zero_56, -256
  %zero_57 = load i32, i32* @my_zero, align 4
  %Temp_141 = add nsw i32 %zero_57, 256
  %Temp_139 = mul nsw i32 %Temp_140, %Temp_141
%Temp_142 = call i32 @CheckOverflow(i32 %Temp_139)
  %zero_58 = load i32, i32* @my_zero, align 4
  %Temp_143 = add nsw i32 %zero_58, 4
%is_div_zero_0 = icmp eq i32  %Temp_143, 0
br i1 %is_div_zero_0 , label %div_by_zero_0, label %good_div_0
div_by_zero_0:
call void @DivideByZero()
br label %good_div_0
good_div_0:
  %Temp_138 = sdiv i32 %Temp_142, %Temp_143
%Temp_144 = call i32 @CheckOverflow(i32 %Temp_138)
  call void @PrintInt(i32 %Temp_144 )
call void @exit(i32 0)
  ret void
}
