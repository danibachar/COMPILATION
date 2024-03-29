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

define i8* @MergeLists(i8*,i8*)
 { 
  %l1 = alloca i8*, align 8
  %l2 = alloca i8*, align 8
  %local_0 = alloca i8*, align 8
  store i8* %0, i8** %l1, align 8
  store i8* %1, i8** %l2, align 8
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_1 = load i8*, i8** %l1, align 8
  %Temp_2 = load i32*, i32** @my_null, align 8
  %Temp_3 = bitcast i8* %Temp_1 to i32*
  %Temp_0 = icmp eq i32* %Temp_3, %Temp_2
  %Temp_4 = zext i1 %Temp_0 to i32
  %equal_zero_0 = icmp eq i32 %Temp_4, 0
  br i1 %equal_zero_0, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %Temp_5 = load i8*, i8** %l2, align 8
  ret i8* %Temp_5
  br label %Label_2_if.exit

Label_2_if.exit:

  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_7 = load i8*, i8** %l2, align 8
  %Temp_8 = load i32*, i32** @my_null, align 8
  %Temp_9 = bitcast i8* %Temp_7 to i32*
  %Temp_6 = icmp eq i32* %Temp_9, %Temp_8
  %Temp_10 = zext i1 %Temp_6 to i32
  %equal_zero_1 = icmp eq i32 %Temp_10, 0
  br i1 %equal_zero_1, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  %Temp_11 = load i8*, i8** %l1, align 8
  ret i8* %Temp_11
  br label %Label_5_if.exit

Label_5_if.exit:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_13 = load i8*, i8** %l1, align 8
%Temp_null_0 = bitcast i8* %Temp_13 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_2, 12
;getlement temp temp temp;
  %Temp_15 = getelementptr inbounds i8, i8* %Temp_13, i32 %Temp_14
  %Temp_16 = bitcast i8* %Temp_15 to i32*
  %Temp_17 = load i8*, i8** %l2, align 8
%Temp_null_1 = bitcast i8* %Temp_17 to i32*
%equal_null_1 = icmp eq i32* %Temp_null_1, null
br i1 %equal_null_1, label %null_deref_1, label %continue_1
null_deref_1:
call void @InvalidPointer()
br label %continue_1
continue_1:
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_3, 12
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_17, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i32*
;load temp temp;
%Temp_init_ptr_2 = bitcast i32* %Temp_20 to i32*
%init_state_2 = load i32, i32* %Temp_init_ptr_2,align 4
%is_init_2 = icmp eq i32  %init_state_2, 0
br i1 %is_init_2 , label %error_init_2, label %good_init_2
error_init_2:
call void @InvalidPointer()
br label %good_init_2
good_init_2:
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i32*
  %Temp_21 = load i32, i32* %Temp_actual_2 , align 4
;load temp temp;
%Temp_init_ptr_3 = bitcast i32* %Temp_16 to i32*
%init_state_3 = load i32, i32* %Temp_init_ptr_3,align 4
%is_init_3 = icmp eq i32  %init_state_3, 0
br i1 %is_init_3 , label %error_init_3, label %good_init_3
error_init_3:
call void @InvalidPointer()
br label %good_init_3
good_init_3:
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i32*
  %Temp_22 = load i32, i32* %Temp_actual_3 , align 4
  %Temp_12 = icmp slt i32 %Temp_22, %Temp_21
  %Temp_23 = zext i1 %Temp_12 to i32
  %equal_zero_4 = icmp eq i32 %Temp_23, 0
  br i1 %equal_zero_4, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %Temp_24 = load i8*, i8** %l1, align 8
  store i8* %Temp_24, i8** %local_0, align 8
  %Temp_25 = load i8*, i8** %local_0, align 8
%Temp_null_4 = bitcast i8* %Temp_25 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_5, 0
;getlement temp temp temp;
  %Temp_27 = getelementptr inbounds i8, i8* %Temp_25, i32 %Temp_26
  %Temp_28 = bitcast i8* %Temp_27 to i8**
  %Temp_29 = load i8*, i8** %l1, align 8
%Temp_null_5 = bitcast i8* %Temp_29 to i32*
%equal_null_5 = icmp eq i32* %Temp_null_5, null
br i1 %equal_null_5, label %null_deref_5, label %continue_5
null_deref_5:
call void @InvalidPointer()
br label %continue_5
continue_5:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_30 = add nsw i32 %zero_6, 0
;getlement temp temp temp;
  %Temp_31 = getelementptr inbounds i8, i8* %Temp_29, i32 %Temp_30
  %Temp_32 = bitcast i8* %Temp_31 to i8**
  %Temp_33 = load i8*, i8** %l2, align 8
;load temp temp;
%Temp_init_ptr_6 = bitcast i8** %Temp_32 to i32*
%init_state_6 = load i32, i32* %Temp_init_ptr_6,align 4
%is_init_6 = icmp eq i32  %init_state_6, 0
br i1 %is_init_6 , label %error_init_6, label %good_init_6
error_init_6:
call void @InvalidPointer()
br label %good_init_6
good_init_6:
%Temp_actual_ptr_6 = getelementptr inbounds i32, i32* %Temp_init_ptr_6, i32 1
%Temp_actual_6 = bitcast i32* %Temp_actual_ptr_6 to i8**
  %Temp_34 = load i8*, i8** %Temp_actual_6 , align 8
%Temp_35 =call i8* @MergeLists(i8* %Temp_34 ,i8* %Temp_33 )
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_7 = bitcast i8** %Temp_28 to i32*
store i32 1, i32* %Temp_init_ptr_7,align 4
%Temp_actual_ptr_7 = getelementptr inbounds i32, i32* %Temp_init_ptr_7, i32 1
%Temp_actual_7 = bitcast i32* %Temp_actual_ptr_7 to i8**
  store i8* %Temp_35, i8** %Temp_actual_7, align 8
  %Temp_36 = load i8*, i8** %local_0, align 8
  ret i8* %Temp_36
  br label %Label_8_if.exit

Label_8_if.exit:

  br label %Label_9_if.cond

Label_9_if.cond:

  %Temp_38 = load i8*, i8** %l2, align 8
%Temp_null_8 = bitcast i8* %Temp_38 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_39 = add nsw i32 %zero_7, 12
;getlement temp temp temp;
  %Temp_40 = getelementptr inbounds i8, i8* %Temp_38, i32 %Temp_39
  %Temp_41 = bitcast i8* %Temp_40 to i32*
  %Temp_42 = load i8*, i8** %l1, align 8
%Temp_null_9 = bitcast i8* %Temp_42 to i32*
%equal_null_9 = icmp eq i32* %Temp_null_9, null
br i1 %equal_null_9, label %null_deref_9, label %continue_9
null_deref_9:
call void @InvalidPointer()
br label %continue_9
continue_9:
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_43 = add nsw i32 %zero_8, 12
;getlement temp temp temp;
  %Temp_44 = getelementptr inbounds i8, i8* %Temp_42, i32 %Temp_43
  %Temp_45 = bitcast i8* %Temp_44 to i32*
;load temp temp;
%Temp_init_ptr_10 = bitcast i32* %Temp_45 to i32*
%init_state_10 = load i32, i32* %Temp_init_ptr_10,align 4
%is_init_10 = icmp eq i32  %init_state_10, 0
br i1 %is_init_10 , label %error_init_10, label %good_init_10
error_init_10:
call void @InvalidPointer()
br label %good_init_10
good_init_10:
%Temp_actual_ptr_10 = getelementptr inbounds i32, i32* %Temp_init_ptr_10, i32 1
%Temp_actual_10 = bitcast i32* %Temp_actual_ptr_10 to i32*
  %Temp_46 = load i32, i32* %Temp_actual_10 , align 4
;load temp temp;
%Temp_init_ptr_11 = bitcast i32* %Temp_41 to i32*
%init_state_11 = load i32, i32* %Temp_init_ptr_11,align 4
%is_init_11 = icmp eq i32  %init_state_11, 0
br i1 %is_init_11 , label %error_init_11, label %good_init_11
error_init_11:
call void @InvalidPointer()
br label %good_init_11
good_init_11:
%Temp_actual_ptr_11 = getelementptr inbounds i32, i32* %Temp_init_ptr_11, i32 1
%Temp_actual_11 = bitcast i32* %Temp_actual_ptr_11 to i32*
  %Temp_47 = load i32, i32* %Temp_actual_11 , align 4
  %Temp_37 = icmp slt i32 %Temp_47, %Temp_46
  %Temp_48 = zext i1 %Temp_37 to i32
  %equal_zero_9 = icmp eq i32 %Temp_48, 0
  br i1 %equal_zero_9, label %Label_11_if.exit, label %Label_10_if.body
  
Label_10_if.body:

  %Temp_49 = load i8*, i8** %l2, align 8
  store i8* %Temp_49, i8** %local_0, align 8
  %Temp_50 = load i8*, i8** %local_0, align 8
%Temp_null_12 = bitcast i8* %Temp_50 to i32*
%equal_null_12 = icmp eq i32* %Temp_null_12, null
br i1 %equal_null_12, label %null_deref_12, label %continue_12
null_deref_12:
call void @InvalidPointer()
br label %continue_12
continue_12:
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_51 = add nsw i32 %zero_10, 0
;getlement temp temp temp;
  %Temp_52 = getelementptr inbounds i8, i8* %Temp_50, i32 %Temp_51
  %Temp_53 = bitcast i8* %Temp_52 to i8**
  %Temp_54 = load i8*, i8** %l1, align 8
  %Temp_55 = load i8*, i8** %l2, align 8
%Temp_null_13 = bitcast i8* %Temp_55 to i32*
%equal_null_13 = icmp eq i32* %Temp_null_13, null
br i1 %equal_null_13, label %null_deref_13, label %continue_13
null_deref_13:
call void @InvalidPointer()
br label %continue_13
continue_13:
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_56 = add nsw i32 %zero_11, 0
;getlement temp temp temp;
  %Temp_57 = getelementptr inbounds i8, i8* %Temp_55, i32 %Temp_56
  %Temp_58 = bitcast i8* %Temp_57 to i8**
;load temp temp;
%Temp_init_ptr_14 = bitcast i8** %Temp_58 to i32*
%init_state_14 = load i32, i32* %Temp_init_ptr_14,align 4
%is_init_14 = icmp eq i32  %init_state_14, 0
br i1 %is_init_14 , label %error_init_14, label %good_init_14
error_init_14:
call void @InvalidPointer()
br label %good_init_14
good_init_14:
%Temp_actual_ptr_14 = getelementptr inbounds i32, i32* %Temp_init_ptr_14, i32 1
%Temp_actual_14 = bitcast i32* %Temp_actual_ptr_14 to i8**
  %Temp_59 = load i8*, i8** %Temp_actual_14 , align 8
%Temp_60 =call i8* @MergeLists(i8* %Temp_54 ,i8* %Temp_59 )
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_15 = bitcast i8** %Temp_53 to i32*
store i32 1, i32* %Temp_init_ptr_15,align 4
%Temp_actual_ptr_15 = getelementptr inbounds i32, i32* %Temp_init_ptr_15, i32 1
%Temp_actual_15 = bitcast i32* %Temp_actual_ptr_15 to i8**
  store i8* %Temp_60, i8** %Temp_actual_15, align 8
  %Temp_61 = load i8*, i8** %local_0, align 8
  ret i8* %Temp_61
  br label %Label_11_if.exit

Label_11_if.exit:

  ret i8* null
}
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_3 = alloca i8*, align 8
  %local_4 = alloca i8*, align 8
  %local_2 = alloca i8*, align 8
  %local_1 = alloca i8*, align 8
  %local_0 = alloca i8*, align 8
  %local_8 = alloca i8*, align 8
  %local_7 = alloca i8*, align 8
  %local_6 = alloca i8*, align 8
  %local_5 = alloca i8*, align 8
  call void @init_globals()
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_63 = add nsw i32 %zero_12, 20
  %Temp_64 = call i32* @malloc(i32 %Temp_63)
  %Temp_62 = bitcast i32* %Temp_64 to i8*
  store i8* %Temp_62, i8** %local_0, align 8
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_66 = add nsw i32 %zero_13, 20
  %Temp_67 = call i32* @malloc(i32 %Temp_66)
  %Temp_65 = bitcast i32* %Temp_67 to i8*
  store i8* %Temp_65, i8** %local_1, align 8
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_69 = add nsw i32 %zero_14, 20
  %Temp_70 = call i32* @malloc(i32 %Temp_69)
  %Temp_68 = bitcast i32* %Temp_70 to i8*
  store i8* %Temp_68, i8** %local_2, align 8
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_72 = add nsw i32 %zero_15, 20
  %Temp_73 = call i32* @malloc(i32 %Temp_72)
  %Temp_71 = bitcast i32* %Temp_73 to i8*
  store i8* %Temp_71, i8** %local_3, align 8
  %zero_16 = load i32, i32* @my_zero, align 4
  %Temp_75 = add nsw i32 %zero_16, 20
  %Temp_76 = call i32* @malloc(i32 %Temp_75)
  %Temp_74 = bitcast i32* %Temp_76 to i8*
  store i8* %Temp_74, i8** %local_4, align 8
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_78 = add nsw i32 %zero_17, 20
  %Temp_79 = call i32* @malloc(i32 %Temp_78)
  %Temp_77 = bitcast i32* %Temp_79 to i8*
  store i8* %Temp_77, i8** %local_5, align 8
  %zero_18 = load i32, i32* @my_zero, align 4
  %Temp_81 = add nsw i32 %zero_18, 20
  %Temp_82 = call i32* @malloc(i32 %Temp_81)
  %Temp_80 = bitcast i32* %Temp_82 to i8*
  store i8* %Temp_80, i8** %local_6, align 8
  %zero_19 = load i32, i32* @my_zero, align 4
  %Temp_84 = add nsw i32 %zero_19, 20
  %Temp_85 = call i32* @malloc(i32 %Temp_84)
  %Temp_83 = bitcast i32* %Temp_85 to i8*
  store i8* %Temp_83, i8** %local_7, align 8
  %Temp_86 = load i8*, i8** %local_0, align 8
%Temp_null_16 = bitcast i8* %Temp_86 to i32*
%equal_null_16 = icmp eq i32* %Temp_null_16, null
br i1 %equal_null_16, label %null_deref_16, label %continue_16
null_deref_16:
call void @InvalidPointer()
br label %continue_16
continue_16:
  %zero_20 = load i32, i32* @my_zero, align 4
  %Temp_87 = add nsw i32 %zero_20, 12
;getlement temp temp temp;
  %Temp_88 = getelementptr inbounds i8, i8* %Temp_86, i32 %Temp_87
  %Temp_89 = bitcast i8* %Temp_88 to i32*
  %zero_21 = load i32, i32* @my_zero, align 4
  %Temp_90 = add nsw i32 %zero_21, 34
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_17 = bitcast i32* %Temp_89 to i32*
store i32 1, i32* %Temp_init_ptr_17,align 4
%Temp_actual_ptr_17 = getelementptr inbounds i32, i32* %Temp_init_ptr_17, i32 1
%Temp_actual_17 = bitcast i32* %Temp_actual_ptr_17 to i32*
  store i32 %Temp_90, i32* %Temp_actual_17, align 4
  %Temp_91 = load i8*, i8** %local_1, align 8
%Temp_null_18 = bitcast i8* %Temp_91 to i32*
%equal_null_18 = icmp eq i32* %Temp_null_18, null
br i1 %equal_null_18, label %null_deref_18, label %continue_18
null_deref_18:
call void @InvalidPointer()
br label %continue_18
continue_18:
  %zero_22 = load i32, i32* @my_zero, align 4
  %Temp_92 = add nsw i32 %zero_22, 12
;getlement temp temp temp;
  %Temp_93 = getelementptr inbounds i8, i8* %Temp_91, i32 %Temp_92
  %Temp_94 = bitcast i8* %Temp_93 to i32*
  %zero_23 = load i32, i32* @my_zero, align 4
  %Temp_95 = add nsw i32 %zero_23, 70
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_19 = bitcast i32* %Temp_94 to i32*
store i32 1, i32* %Temp_init_ptr_19,align 4
%Temp_actual_ptr_19 = getelementptr inbounds i32, i32* %Temp_init_ptr_19, i32 1
%Temp_actual_19 = bitcast i32* %Temp_actual_ptr_19 to i32*
  store i32 %Temp_95, i32* %Temp_actual_19, align 4
  %Temp_96 = load i8*, i8** %local_2, align 8
%Temp_null_20 = bitcast i8* %Temp_96 to i32*
%equal_null_20 = icmp eq i32* %Temp_null_20, null
br i1 %equal_null_20, label %null_deref_20, label %continue_20
null_deref_20:
call void @InvalidPointer()
br label %continue_20
continue_20:
  %zero_24 = load i32, i32* @my_zero, align 4
  %Temp_97 = add nsw i32 %zero_24, 12
;getlement temp temp temp;
  %Temp_98 = getelementptr inbounds i8, i8* %Temp_96, i32 %Temp_97
  %Temp_99 = bitcast i8* %Temp_98 to i32*
  %zero_25 = load i32, i32* @my_zero, align 4
  %Temp_100 = add nsw i32 %zero_25, 92
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_21 = bitcast i32* %Temp_99 to i32*
store i32 1, i32* %Temp_init_ptr_21,align 4
%Temp_actual_ptr_21 = getelementptr inbounds i32, i32* %Temp_init_ptr_21, i32 1
%Temp_actual_21 = bitcast i32* %Temp_actual_ptr_21 to i32*
  store i32 %Temp_100, i32* %Temp_actual_21, align 4
  %Temp_101 = load i8*, i8** %local_3, align 8
%Temp_null_22 = bitcast i8* %Temp_101 to i32*
%equal_null_22 = icmp eq i32* %Temp_null_22, null
br i1 %equal_null_22, label %null_deref_22, label %continue_22
null_deref_22:
call void @InvalidPointer()
br label %continue_22
continue_22:
  %zero_26 = load i32, i32* @my_zero, align 4
  %Temp_102 = add nsw i32 %zero_26, 12
;getlement temp temp temp;
  %Temp_103 = getelementptr inbounds i8, i8* %Temp_101, i32 %Temp_102
  %Temp_104 = bitcast i8* %Temp_103 to i32*
  %zero_27 = load i32, i32* @my_zero, align 4
  %Temp_105 = add nsw i32 %zero_27, 96
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_23 = bitcast i32* %Temp_104 to i32*
store i32 1, i32* %Temp_init_ptr_23,align 4
%Temp_actual_ptr_23 = getelementptr inbounds i32, i32* %Temp_init_ptr_23, i32 1
%Temp_actual_23 = bitcast i32* %Temp_actual_ptr_23 to i32*
  store i32 %Temp_105, i32* %Temp_actual_23, align 4
  %Temp_106 = load i8*, i8** %local_4, align 8
%Temp_null_24 = bitcast i8* %Temp_106 to i32*
%equal_null_24 = icmp eq i32* %Temp_null_24, null
br i1 %equal_null_24, label %null_deref_24, label %continue_24
null_deref_24:
call void @InvalidPointer()
br label %continue_24
continue_24:
  %zero_28 = load i32, i32* @my_zero, align 4
  %Temp_107 = add nsw i32 %zero_28, 12
;getlement temp temp temp;
  %Temp_108 = getelementptr inbounds i8, i8* %Temp_106, i32 %Temp_107
  %Temp_109 = bitcast i8* %Temp_108 to i32*
  %zero_29 = load i32, i32* @my_zero, align 4
  %Temp_110 = add nsw i32 %zero_29, 12
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_25 = bitcast i32* %Temp_109 to i32*
store i32 1, i32* %Temp_init_ptr_25,align 4
%Temp_actual_ptr_25 = getelementptr inbounds i32, i32* %Temp_init_ptr_25, i32 1
%Temp_actual_25 = bitcast i32* %Temp_actual_ptr_25 to i32*
  store i32 %Temp_110, i32* %Temp_actual_25, align 4
  %Temp_111 = load i8*, i8** %local_5, align 8
%Temp_null_26 = bitcast i8* %Temp_111 to i32*
%equal_null_26 = icmp eq i32* %Temp_null_26, null
br i1 %equal_null_26, label %null_deref_26, label %continue_26
null_deref_26:
call void @InvalidPointer()
br label %continue_26
continue_26:
  %zero_30 = load i32, i32* @my_zero, align 4
  %Temp_112 = add nsw i32 %zero_30, 12
;getlement temp temp temp;
  %Temp_113 = getelementptr inbounds i8, i8* %Temp_111, i32 %Temp_112
  %Temp_114 = bitcast i8* %Temp_113 to i32*
  %zero_31 = load i32, i32* @my_zero, align 4
  %Temp_115 = add nsw i32 %zero_31, 50
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_27 = bitcast i32* %Temp_114 to i32*
store i32 1, i32* %Temp_init_ptr_27,align 4
%Temp_actual_ptr_27 = getelementptr inbounds i32, i32* %Temp_init_ptr_27, i32 1
%Temp_actual_27 = bitcast i32* %Temp_actual_ptr_27 to i32*
  store i32 %Temp_115, i32* %Temp_actual_27, align 4
  %Temp_116 = load i8*, i8** %local_6, align 8
%Temp_null_28 = bitcast i8* %Temp_116 to i32*
%equal_null_28 = icmp eq i32* %Temp_null_28, null
br i1 %equal_null_28, label %null_deref_28, label %continue_28
null_deref_28:
call void @InvalidPointer()
br label %continue_28
continue_28:
  %zero_32 = load i32, i32* @my_zero, align 4
  %Temp_117 = add nsw i32 %zero_32, 12
;getlement temp temp temp;
  %Temp_118 = getelementptr inbounds i8, i8* %Temp_116, i32 %Temp_117
  %Temp_119 = bitcast i8* %Temp_118 to i32*
  %zero_33 = load i32, i32* @my_zero, align 4
  %Temp_120 = add nsw i32 %zero_33, 97
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_29 = bitcast i32* %Temp_119 to i32*
store i32 1, i32* %Temp_init_ptr_29,align 4
%Temp_actual_ptr_29 = getelementptr inbounds i32, i32* %Temp_init_ptr_29, i32 1
%Temp_actual_29 = bitcast i32* %Temp_actual_ptr_29 to i32*
  store i32 %Temp_120, i32* %Temp_actual_29, align 4
  %Temp_121 = load i8*, i8** %local_7, align 8
%Temp_null_30 = bitcast i8* %Temp_121 to i32*
%equal_null_30 = icmp eq i32* %Temp_null_30, null
br i1 %equal_null_30, label %null_deref_30, label %continue_30
null_deref_30:
call void @InvalidPointer()
br label %continue_30
continue_30:
  %zero_34 = load i32, i32* @my_zero, align 4
  %Temp_122 = add nsw i32 %zero_34, 12
;getlement temp temp temp;
  %Temp_123 = getelementptr inbounds i8, i8* %Temp_121, i32 %Temp_122
  %Temp_124 = bitcast i8* %Temp_123 to i32*
  %zero_35 = load i32, i32* @my_zero, align 4
  %Temp_125 = add nsw i32 %zero_35, 99
;store TYPES.TYPE_INT@377dca04 dst src;
%Temp_init_ptr_31 = bitcast i32* %Temp_124 to i32*
store i32 1, i32* %Temp_init_ptr_31,align 4
%Temp_actual_ptr_31 = getelementptr inbounds i32, i32* %Temp_init_ptr_31, i32 1
%Temp_actual_31 = bitcast i32* %Temp_actual_ptr_31 to i32*
  store i32 %Temp_125, i32* %Temp_actual_31, align 4
  %Temp_126 = load i8*, i8** %local_0, align 8
%Temp_null_32 = bitcast i8* %Temp_126 to i32*
%equal_null_32 = icmp eq i32* %Temp_null_32, null
br i1 %equal_null_32, label %null_deref_32, label %continue_32
null_deref_32:
call void @InvalidPointer()
br label %continue_32
continue_32:
  %zero_36 = load i32, i32* @my_zero, align 4
  %Temp_127 = add nsw i32 %zero_36, 0
;getlement temp temp temp;
  %Temp_128 = getelementptr inbounds i8, i8* %Temp_126, i32 %Temp_127
  %Temp_129 = bitcast i8* %Temp_128 to i8**
  %Temp_130 = load i8*, i8** %local_1, align 8
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_33 = bitcast i8** %Temp_129 to i32*
store i32 1, i32* %Temp_init_ptr_33,align 4
%Temp_actual_ptr_33 = getelementptr inbounds i32, i32* %Temp_init_ptr_33, i32 1
%Temp_actual_33 = bitcast i32* %Temp_actual_ptr_33 to i8**
  store i8* %Temp_130, i8** %Temp_actual_33, align 8
  %Temp_131 = load i8*, i8** %local_1, align 8
%Temp_null_34 = bitcast i8* %Temp_131 to i32*
%equal_null_34 = icmp eq i32* %Temp_null_34, null
br i1 %equal_null_34, label %null_deref_34, label %continue_34
null_deref_34:
call void @InvalidPointer()
br label %continue_34
continue_34:
  %zero_37 = load i32, i32* @my_zero, align 4
  %Temp_132 = add nsw i32 %zero_37, 0
;getlement temp temp temp;
  %Temp_133 = getelementptr inbounds i8, i8* %Temp_131, i32 %Temp_132
  %Temp_134 = bitcast i8* %Temp_133 to i8**
  %Temp_135 = load i8*, i8** %local_2, align 8
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_35 = bitcast i8** %Temp_134 to i32*
store i32 1, i32* %Temp_init_ptr_35,align 4
%Temp_actual_ptr_35 = getelementptr inbounds i32, i32* %Temp_init_ptr_35, i32 1
%Temp_actual_35 = bitcast i32* %Temp_actual_ptr_35 to i8**
  store i8* %Temp_135, i8** %Temp_actual_35, align 8
  %Temp_136 = load i8*, i8** %local_2, align 8
%Temp_null_36 = bitcast i8* %Temp_136 to i32*
%equal_null_36 = icmp eq i32* %Temp_null_36, null
br i1 %equal_null_36, label %null_deref_36, label %continue_36
null_deref_36:
call void @InvalidPointer()
br label %continue_36
continue_36:
  %zero_38 = load i32, i32* @my_zero, align 4
  %Temp_137 = add nsw i32 %zero_38, 0
;getlement temp temp temp;
  %Temp_138 = getelementptr inbounds i8, i8* %Temp_136, i32 %Temp_137
  %Temp_139 = bitcast i8* %Temp_138 to i8**
  %Temp_140 = load i8*, i8** %local_3, align 8
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_37 = bitcast i8** %Temp_139 to i32*
store i32 1, i32* %Temp_init_ptr_37,align 4
%Temp_actual_ptr_37 = getelementptr inbounds i32, i32* %Temp_init_ptr_37, i32 1
%Temp_actual_37 = bitcast i32* %Temp_actual_ptr_37 to i8**
  store i8* %Temp_140, i8** %Temp_actual_37, align 8
  %Temp_141 = load i8*, i8** %local_3, align 8
%Temp_null_38 = bitcast i8* %Temp_141 to i32*
%equal_null_38 = icmp eq i32* %Temp_null_38, null
br i1 %equal_null_38, label %null_deref_38, label %continue_38
null_deref_38:
call void @InvalidPointer()
br label %continue_38
continue_38:
  %zero_39 = load i32, i32* @my_zero, align 4
  %Temp_142 = add nsw i32 %zero_39, 0
;getlement temp temp temp;
  %Temp_143 = getelementptr inbounds i8, i8* %Temp_141, i32 %Temp_142
  %Temp_144 = bitcast i8* %Temp_143 to i8**
  %Temp_145 = load i32*, i32** @my_null, align 8
  %Temp_146 = bitcast i8** %Temp_144 to i32**
;store TYPES.TYPE_NIL@728938a9 dst src;
%Temp_init_ptr_39 = bitcast i32** %Temp_146 to i32*
store i32 1, i32* %Temp_init_ptr_39,align 4
%Temp_actual_ptr_39 = getelementptr inbounds i32, i32* %Temp_init_ptr_39, i32 1
%Temp_actual_39 = bitcast i32* %Temp_actual_ptr_39 to i32**
  store i32* %Temp_145, i32** %Temp_actual_39, align 8
  %Temp_147 = load i8*, i8** %local_4, align 8
%Temp_null_40 = bitcast i8* %Temp_147 to i32*
%equal_null_40 = icmp eq i32* %Temp_null_40, null
br i1 %equal_null_40, label %null_deref_40, label %continue_40
null_deref_40:
call void @InvalidPointer()
br label %continue_40
continue_40:
  %zero_40 = load i32, i32* @my_zero, align 4
  %Temp_148 = add nsw i32 %zero_40, 0
;getlement temp temp temp;
  %Temp_149 = getelementptr inbounds i8, i8* %Temp_147, i32 %Temp_148
  %Temp_150 = bitcast i8* %Temp_149 to i8**
  %Temp_151 = load i8*, i8** %local_5, align 8
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_41 = bitcast i8** %Temp_150 to i32*
store i32 1, i32* %Temp_init_ptr_41,align 4
%Temp_actual_ptr_41 = getelementptr inbounds i32, i32* %Temp_init_ptr_41, i32 1
%Temp_actual_41 = bitcast i32* %Temp_actual_ptr_41 to i8**
  store i8* %Temp_151, i8** %Temp_actual_41, align 8
  %Temp_152 = load i8*, i8** %local_5, align 8
%Temp_null_42 = bitcast i8* %Temp_152 to i32*
%equal_null_42 = icmp eq i32* %Temp_null_42, null
br i1 %equal_null_42, label %null_deref_42, label %continue_42
null_deref_42:
call void @InvalidPointer()
br label %continue_42
continue_42:
  %zero_41 = load i32, i32* @my_zero, align 4
  %Temp_153 = add nsw i32 %zero_41, 0
;getlement temp temp temp;
  %Temp_154 = getelementptr inbounds i8, i8* %Temp_152, i32 %Temp_153
  %Temp_155 = bitcast i8* %Temp_154 to i8**
  %Temp_156 = load i8*, i8** %local_6, align 8
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_43 = bitcast i8** %Temp_155 to i32*
store i32 1, i32* %Temp_init_ptr_43,align 4
%Temp_actual_ptr_43 = getelementptr inbounds i32, i32* %Temp_init_ptr_43, i32 1
%Temp_actual_43 = bitcast i32* %Temp_actual_ptr_43 to i8**
  store i8* %Temp_156, i8** %Temp_actual_43, align 8
  %Temp_157 = load i8*, i8** %local_6, align 8
%Temp_null_44 = bitcast i8* %Temp_157 to i32*
%equal_null_44 = icmp eq i32* %Temp_null_44, null
br i1 %equal_null_44, label %null_deref_44, label %continue_44
null_deref_44:
call void @InvalidPointer()
br label %continue_44
continue_44:
  %zero_42 = load i32, i32* @my_zero, align 4
  %Temp_158 = add nsw i32 %zero_42, 0
;getlement temp temp temp;
  %Temp_159 = getelementptr inbounds i8, i8* %Temp_157, i32 %Temp_158
  %Temp_160 = bitcast i8* %Temp_159 to i8**
  %Temp_161 = load i8*, i8** %local_7, align 8
;store TYPES.TYPE_CLASS@31221be2 dst src;
%Temp_init_ptr_45 = bitcast i8** %Temp_160 to i32*
store i32 1, i32* %Temp_init_ptr_45,align 4
%Temp_actual_ptr_45 = getelementptr inbounds i32, i32* %Temp_init_ptr_45, i32 1
%Temp_actual_45 = bitcast i32* %Temp_actual_ptr_45 to i8**
  store i8* %Temp_161, i8** %Temp_actual_45, align 8
  %Temp_162 = load i8*, i8** %local_7, align 8
%Temp_null_46 = bitcast i8* %Temp_162 to i32*
%equal_null_46 = icmp eq i32* %Temp_null_46, null
br i1 %equal_null_46, label %null_deref_46, label %continue_46
null_deref_46:
call void @InvalidPointer()
br label %continue_46
continue_46:
  %zero_43 = load i32, i32* @my_zero, align 4
  %Temp_163 = add nsw i32 %zero_43, 0
;getlement temp temp temp;
  %Temp_164 = getelementptr inbounds i8, i8* %Temp_162, i32 %Temp_163
  %Temp_165 = bitcast i8* %Temp_164 to i8**
  %Temp_166 = load i32*, i32** @my_null, align 8
  %Temp_167 = bitcast i8** %Temp_165 to i32**
;store TYPES.TYPE_NIL@728938a9 dst src;
%Temp_init_ptr_47 = bitcast i32** %Temp_167 to i32*
store i32 1, i32* %Temp_init_ptr_47,align 4
%Temp_actual_ptr_47 = getelementptr inbounds i32, i32* %Temp_init_ptr_47, i32 1
%Temp_actual_47 = bitcast i32* %Temp_actual_ptr_47 to i32**
  store i32* %Temp_166, i32** %Temp_actual_47, align 8
  %Temp_168 = load i8*, i8** %local_0, align 8
  %Temp_169 = load i8*, i8** %local_4, align 8
%Temp_170 =call i8* @MergeLists(i8* %Temp_168 ,i8* %Temp_169 )
  store i8* %Temp_170, i8** %local_8, align 8
  br label %Label_14_while.cond

Label_14_while.cond:

  %zero_44 = load i32, i32* @my_zero, align 4
  %Temp_172 = add nsw i32 %zero_44, 1
  %Temp_174 = load i8*, i8** %local_8, align 8
  %Temp_175 = load i32*, i32** @my_null, align 8
  %Temp_176 = bitcast i8* %Temp_174 to i32*
  %Temp_173 = icmp eq i32* %Temp_176, %Temp_175
  %Temp_177 = zext i1 %Temp_173 to i32
  %Temp_171 = sub nsw i32 %Temp_172, %Temp_177
%Temp_178 = call i32 @CheckOverflow(i32 %Temp_171)
  %equal_zero_45 = icmp eq i32 %Temp_178, 0
  br i1 %equal_zero_45, label %Label_12_while.end, label %Label_13_while.body
  
Label_13_while.body:

  %Temp_179 = load i8*, i8** %local_8, align 8
%Temp_null_48 = bitcast i8* %Temp_179 to i32*
%equal_null_48 = icmp eq i32* %Temp_null_48, null
br i1 %equal_null_48, label %null_deref_48, label %continue_48
null_deref_48:
call void @InvalidPointer()
br label %continue_48
continue_48:
  %zero_46 = load i32, i32* @my_zero, align 4
  %Temp_180 = add nsw i32 %zero_46, 12
;getlement temp temp temp;
  %Temp_181 = getelementptr inbounds i8, i8* %Temp_179, i32 %Temp_180
  %Temp_182 = bitcast i8* %Temp_181 to i32*
;load temp temp;
%Temp_init_ptr_49 = bitcast i32* %Temp_182 to i32*
%init_state_49 = load i32, i32* %Temp_init_ptr_49,align 4
%is_init_49 = icmp eq i32  %init_state_49, 0
br i1 %is_init_49 , label %error_init_49, label %good_init_49
error_init_49:
call void @InvalidPointer()
br label %good_init_49
good_init_49:
%Temp_actual_ptr_49 = getelementptr inbounds i32, i32* %Temp_init_ptr_49, i32 1
%Temp_actual_49 = bitcast i32* %Temp_actual_ptr_49 to i32*
  %Temp_183 = load i32, i32* %Temp_actual_49 , align 4
  call void @PrintInt(i32 %Temp_183 )
  %Temp_184 = load i8*, i8** %local_8, align 8
%Temp_null_50 = bitcast i8* %Temp_184 to i32*
%equal_null_50 = icmp eq i32* %Temp_null_50, null
br i1 %equal_null_50, label %null_deref_50, label %continue_50
null_deref_50:
call void @InvalidPointer()
br label %continue_50
continue_50:
  %zero_47 = load i32, i32* @my_zero, align 4
  %Temp_185 = add nsw i32 %zero_47, 0
;getlement temp temp temp;
  %Temp_186 = getelementptr inbounds i8, i8* %Temp_184, i32 %Temp_185
  %Temp_187 = bitcast i8* %Temp_186 to i8**
;load temp temp;
%Temp_init_ptr_51 = bitcast i8** %Temp_187 to i32*
%init_state_51 = load i32, i32* %Temp_init_ptr_51,align 4
%is_init_51 = icmp eq i32  %init_state_51, 0
br i1 %is_init_51 , label %error_init_51, label %good_init_51
error_init_51:
call void @InvalidPointer()
br label %good_init_51
good_init_51:
%Temp_actual_ptr_51 = getelementptr inbounds i32, i32* %Temp_init_ptr_51, i32 1
%Temp_actual_51 = bitcast i32* %Temp_actual_ptr_51 to i8**
  %Temp_188 = load i8*, i8** %Temp_actual_51 , align 8
  store i8* %Temp_188, i8** %local_8, align 8
  br label %Label_14_while.cond

Label_12_while.end:

call void @exit(i32 0)
  ret void
}
