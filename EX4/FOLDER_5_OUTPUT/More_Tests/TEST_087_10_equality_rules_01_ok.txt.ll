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
  %local_2 = alloca i8*, align 8
  %local_1 = alloca i8*, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 36
  %Temp_2 = call i32* @malloc(i32 %Temp_1)
  %Temp_0 = bitcast i32* %Temp_2 to i8*
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 28
;getlement temp temp temp;
  %Temp_4 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_3
  %Temp_5 = bitcast i8* %Temp_4 to i32*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_2, 4
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_0 = bitcast i32* %Temp_5 to i32*
store i32 1, i32* %Temp_init_ptr_0,align 4
%Temp_actual_ptr_0 = getelementptr inbounds i32, i32* %Temp_init_ptr_0, i32 1
%Temp_actual_0 = bitcast i32* %Temp_actual_ptr_0 to i32*
  store i32 %Temp_6, i32* %Temp_actual_0, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_3, 12
;getlement temp temp temp;
  %Temp_8 = getelementptr inbounds i8, i8* %Temp_0, i32 %Temp_7
  %Temp_9 = bitcast i8* %Temp_8 to i32*
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_4, 3
;store TYPES.TYPE_INT@37f8bb67 dst src;
%Temp_init_ptr_1 = bitcast i32* %Temp_9 to i32*
store i32 1, i32* %Temp_init_ptr_1,align 4
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i32*
  store i32 %Temp_10, i32* %Temp_actual_1, align 4
  store i8* %Temp_0, i8** %local_0, align 8
  %Temp_11 = load i8*, i8** %local_0, align 8
  store i8* %Temp_11, i8** %local_1, align 8
  %Temp_12 = load i8*, i8** %local_0, align 8
  store i8* %Temp_12, i8** %local_2, align 8
  %Temp_14 = load i8*, i8** %local_2, align 8
  %Temp_15 = load i8*, i8** %local_1, align 8
  %Temp_13 = icmp eq i8* %Temp_14, %Temp_15
  %Temp_16 = zext i1 %Temp_13 to i32
  call void @PrintInt(i32 %Temp_16 )
  %Temp_18 = load i8*, i8** %local_2, align 8
  %Temp_19 = load i8*, i8** %local_0, align 8
  %Temp_17 = icmp eq i8* %Temp_18, %Temp_19
  %Temp_20 = zext i1 %Temp_17 to i32
  call void @PrintInt(i32 %Temp_20 )
  %Temp_22 = load i8*, i8** %local_1, align 8
  %Temp_23 = load i8*, i8** %local_2, align 8
  %Temp_21 = icmp eq i8* %Temp_22, %Temp_23
  %Temp_24 = zext i1 %Temp_21 to i32
  call void @PrintInt(i32 %Temp_24 )
  %Temp_26 = load i8*, i8** %local_0, align 8
  %Temp_27 = load i8*, i8** %local_2, align 8
  %Temp_25 = icmp eq i8* %Temp_26, %Temp_27
  %Temp_28 = zext i1 %Temp_25 to i32
  call void @PrintInt(i32 %Temp_28 )
  %Temp_30 = load i8*, i8** %local_1, align 8
  %Temp_31 = load i8*, i8** %local_0, align 8
  %Temp_29 = icmp eq i8* %Temp_30, %Temp_31
  %Temp_32 = zext i1 %Temp_29 to i32
  call void @PrintInt(i32 %Temp_32 )
  %Temp_34 = load i8*, i8** %local_0, align 8
  %Temp_35 = load i8*, i8** %local_0, align 8
  %Temp_33 = icmp eq i8* %Temp_34, %Temp_35
  %Temp_36 = zext i1 %Temp_33 to i32
  call void @PrintInt(i32 %Temp_36 )
  %Temp_38 = load i8*, i8** %local_2, align 8
  %Temp_39 = load i32*, i32** @my_null, align 8
  %Temp_40 = bitcast i8* %Temp_38 to i32*
  %Temp_37 = icmp eq i32* %Temp_40, %Temp_39
  %Temp_41 = zext i1 %Temp_37 to i32
  call void @PrintInt(i32 %Temp_41 )
  %Temp_43 = load i8*, i8** %local_0, align 8
  %Temp_44 = load i32*, i32** @my_null, align 8
  %Temp_45 = bitcast i8* %Temp_43 to i32*
  %Temp_42 = icmp eq i32* %Temp_45, %Temp_44
  %Temp_46 = zext i1 %Temp_42 to i32
  call void @PrintInt(i32 %Temp_46 )
  %Temp_48 = load i32*, i32** @my_null, align 8
  %Temp_49 = load i8*, i8** %local_2, align 8
  %Temp_50 = bitcast i8* %Temp_49 to i32*
  %Temp_47 = icmp eq i32* %Temp_48, %Temp_50
  %Temp_51 = zext i1 %Temp_47 to i32
  call void @PrintInt(i32 %Temp_51 )
  %Temp_53 = load i8*, i8** %local_2, align 8
%Temp_null_2 = bitcast i8* %Temp_53 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_54 = add nsw i32 %zero_5, 12
;getlement temp temp temp;
  %Temp_55 = getelementptr inbounds i8, i8* %Temp_53, i32 %Temp_54
  %Temp_56 = bitcast i8* %Temp_55 to i32*
  %Temp_57 = load i8*, i8** %local_0, align 8
%Temp_null_3 = bitcast i8* %Temp_57 to i32*
%equal_null_3 = icmp eq i32* %Temp_null_3, null
br i1 %equal_null_3, label %null_deref_3, label %continue_3
null_deref_3:
call void @InvalidPointer()
br label %continue_3
continue_3:
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_58 = add nsw i32 %zero_6, 28
;getlement temp temp temp;
  %Temp_59 = getelementptr inbounds i8, i8* %Temp_57, i32 %Temp_58
  %Temp_60 = bitcast i8* %Temp_59 to i32*
;load temp temp;
%Temp_init_ptr_4 = bitcast i32* %Temp_60 to i32*
%init_state_4 = load i32, i32* %Temp_init_ptr_4,align 4
%is_init_4 = icmp eq i32  %init_state_4, 0
br i1 %is_init_4 , label %error_init_4, label %good_init_4
error_init_4:
call void @InvalidPointer()
br label %good_init_4
good_init_4:
%Temp_actual_ptr_4 = getelementptr inbounds i32, i32* %Temp_init_ptr_4, i32 1
%Temp_actual_4 = bitcast i32* %Temp_actual_ptr_4 to i32*
  %Temp_61 = load i32, i32* %Temp_actual_4 , align 4
;load temp temp;
%Temp_init_ptr_5 = bitcast i32* %Temp_56 to i32*
%init_state_5 = load i32, i32* %Temp_init_ptr_5,align 4
%is_init_5 = icmp eq i32  %init_state_5, 0
br i1 %is_init_5 , label %error_init_5, label %good_init_5
error_init_5:
call void @InvalidPointer()
br label %good_init_5
good_init_5:
%Temp_actual_ptr_5 = getelementptr inbounds i32, i32* %Temp_init_ptr_5, i32 1
%Temp_actual_5 = bitcast i32* %Temp_actual_ptr_5 to i32*
  %Temp_62 = load i32, i32* %Temp_actual_5 , align 4
  %Temp_52 = icmp eq i32 %Temp_62, %Temp_61
  %Temp_63 = zext i1 %Temp_52 to i32
  call void @PrintInt(i32 %Temp_63 )
call void @exit(i32 0)
  ret void
}
