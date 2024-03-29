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
  %Temp_1 = add nsw i32 %zero_0, 0
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_1, 3
  %Temp_0 = sub nsw i32 %Temp_1, %Temp_2
%Temp_3 = call i32 @CheckOverflow(i32 %Temp_0)
  call void @PrintInt(i32 %Temp_3 )
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_2, -17
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_3, 1
  %Temp_4 = sub nsw i32 %Temp_5, %Temp_6
%Temp_7 = call i32 @CheckOverflow(i32 %Temp_4)
  call void @PrintInt(i32 %Temp_7 )
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_4, 1
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_5, 17
  %Temp_8 = sub nsw i32 %Temp_9, %Temp_10
%Temp_11 = call i32 @CheckOverflow(i32 %Temp_8)
  call void @PrintInt(i32 %Temp_11 )
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_6, 800
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_7, 900
  %Temp_12 = add nsw i32 %Temp_13, %Temp_14
%Temp_15 = call i32 @CheckOverflow(i32 %Temp_12)
  call void @PrintInt(i32 %Temp_15 )
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_8, -32000
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_9, 1000
  %Temp_16 = sub nsw i32 %Temp_17, %Temp_18
%Temp_19 = call i32 @CheckOverflow(i32 %Temp_16)
  call void @PrintInt(i32 %Temp_19 )
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_10, 32000
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_11, 1000
  %Temp_20 = add nsw i32 %Temp_21, %Temp_22
%Temp_23 = call i32 @CheckOverflow(i32 %Temp_20)
  call void @PrintInt(i32 %Temp_23 )
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_12, 32000
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_30 = add nsw i32 %zero_13, 1000
  %Temp_28 = add nsw i32 %Temp_29, %Temp_30
%Temp_31 = call i32 @CheckOverflow(i32 %Temp_28)
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_14, 1000
  %Temp_27 = add nsw i32 %Temp_31, %Temp_32
%Temp_33 = call i32 @CheckOverflow(i32 %Temp_27)
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_15, 100
  %Temp_26 = add nsw i32 %Temp_33, %Temp_34
%Temp_35 = call i32 @CheckOverflow(i32 %Temp_26)
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_16, 10
  %Temp_25 = add nsw i32 %Temp_35, %Temp_36
%Temp_37 = call i32 @CheckOverflow(i32 %Temp_25)
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_38 = add nsw i32 %zero_17, 1
  %Temp_24 = add nsw i32 %Temp_37, %Temp_38
%Temp_39 = call i32 @CheckOverflow(i32 %Temp_24)
  call void @PrintInt(i32 %Temp_39 )
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_44 = add nsw i32 %zero_18, 10
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_45 = add nsw i32 %zero_19, 10
  %Temp_43 = add nsw i32 %Temp_44, %Temp_45
%Temp_46 = call i32 @CheckOverflow(i32 %Temp_43)
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_47 = add nsw i32 %zero_20, 10
  %Temp_42 = add nsw i32 %Temp_46, %Temp_47
%Temp_48 = call i32 @CheckOverflow(i32 %Temp_42)
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_49 = add nsw i32 %zero_21, 10
  %Temp_41 = add nsw i32 %Temp_48, %Temp_49
%Temp_50 = call i32 @CheckOverflow(i32 %Temp_41)
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_22, 32760
  %Temp_40 = add nsw i32 %Temp_50, %Temp_51
%Temp_52 = call i32 @CheckOverflow(i32 %Temp_40)
  call void @PrintInt(i32 %Temp_52 )
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_23, 32767
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_55 = add nsw i32 %zero_24, 1
  %Temp_53 = add nsw i32 %Temp_54, %Temp_55
%Temp_56 = call i32 @CheckOverflow(i32 %Temp_53)
  call void @PrintInt(i32 %Temp_56 )
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_62 = add nsw i32 %zero_25, -32000
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_63 = add nsw i32 %zero_26, 1000
  %Temp_61 = sub nsw i32 %Temp_62, %Temp_63
%Temp_64 = call i32 @CheckOverflow(i32 %Temp_61)
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_65 = add nsw i32 %zero_27, 1000
  %Temp_60 = sub nsw i32 %Temp_64, %Temp_65
%Temp_66 = call i32 @CheckOverflow(i32 %Temp_60)
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_67 = add nsw i32 %zero_28, 100
  %Temp_59 = sub nsw i32 %Temp_66, %Temp_67
%Temp_68 = call i32 @CheckOverflow(i32 %Temp_59)
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_69 = add nsw i32 %zero_29, 10
  %Temp_58 = sub nsw i32 %Temp_68, %Temp_69
%Temp_70 = call i32 @CheckOverflow(i32 %Temp_58)
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_71 = add nsw i32 %zero_30, 1
  %Temp_57 = sub nsw i32 %Temp_70, %Temp_71
%Temp_72 = call i32 @CheckOverflow(i32 %Temp_57)
  call void @PrintInt(i32 %Temp_72 )
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_77 = add nsw i32 %zero_31, -10
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_78 = add nsw i32 %zero_32, 10
  %Temp_76 = sub nsw i32 %Temp_77, %Temp_78
%Temp_79 = call i32 @CheckOverflow(i32 %Temp_76)
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_80 = add nsw i32 %zero_33, 10
  %Temp_75 = sub nsw i32 %Temp_79, %Temp_80
%Temp_81 = call i32 @CheckOverflow(i32 %Temp_75)
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_82 = add nsw i32 %zero_34, 10
  %Temp_74 = sub nsw i32 %Temp_81, %Temp_82
%Temp_83 = call i32 @CheckOverflow(i32 %Temp_74)
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_35, 32760
  %Temp_73 = sub nsw i32 %Temp_83, %Temp_84
%Temp_85 = call i32 @CheckOverflow(i32 %Temp_73)
  call void @PrintInt(i32 %Temp_85 )
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_87 = add nsw i32 %zero_36, -32768
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_88 = add nsw i32 %zero_37, 1
  %Temp_86 = sub nsw i32 %Temp_87, %Temp_88
%Temp_89 = call i32 @CheckOverflow(i32 %Temp_86)
  call void @PrintInt(i32 %Temp_89 )
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_92 = add nsw i32 %zero_38, 32760
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_93 = add nsw i32 %zero_39, 10
  %Temp_91 = add nsw i32 %Temp_92, %Temp_93
%Temp_94 = call i32 @CheckOverflow(i32 %Temp_91)
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_40, 7
  %Temp_90 = sub nsw i32 %Temp_94, %Temp_95
%Temp_96 = call i32 @CheckOverflow(i32 %Temp_90)
  call void @PrintInt(i32 %Temp_96 )
call void @exit(i32 0)
  ret void
}
