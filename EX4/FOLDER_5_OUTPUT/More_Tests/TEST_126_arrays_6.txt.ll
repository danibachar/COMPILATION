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

@STR.Love = constant [5 x i8] c"Love\00", align 1
@STR.I = constant [2 x i8] c"I\00", align 1
@STR.Lazagna = constant [8 x i8] c"Lazagna\00", align 1
@STR.You = constant [4 x i8] c"You\00", align 1
;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@mystrs = global i8** null, align 8

define void @love()
 { 
  %Temp_0 = load i8**, i8*** @mystrs, align 8
%Temp_null_0 = bitcast i8** %Temp_0 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 1
%Temp_i32_1 = bitcast i8** %Temp_0 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_1, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_1, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_2 = add nsw i32 %Temp_1,1
;getlement temp temp temp;
  %Temp_3 = getelementptr inbounds i8*, i8** %Temp_0, i32 %Temp_2
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @STR.Love, i32 0, i32 0), i8** %str_0, align 8
  %Temp_4 = load i8*, i8** %str_0, align 8
;store TYPES.TYPE_STRING@2e5d6d97 dst src;
  store i8* %Temp_4, i8** %Temp_3, align 8
  ret void
}
define void @lazagna(i8**)
 { 
  %arr = alloca i8**, align 8
  store i8** %0, i8*** %arr, align 8
  %Temp_5 = load i8**, i8*** %arr, align 8
%Temp_null_2 = bitcast i8** %Temp_5 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_1, 2
%Temp_i32_3 = bitcast i8** %Temp_5 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_6, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_6, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_7 = add nsw i32 %Temp_6,1
;getlement temp temp temp;
  %Temp_8 = getelementptr inbounds i8*, i8** %Temp_5, i32 %Temp_7
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @STR.Lazagna, i32 0, i32 0), i8** %str_1, align 8
  %Temp_9 = load i8*, i8** %str_1, align 8
;store TYPES.TYPE_STRING@2e5d6d97 dst src;
  store i8* %Temp_9, i8** %Temp_8, align 8
  ret void
}
define void @init_globals()
 { 
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_2, 3
  %Temp_12 = add nsw i32 %Temp_11,1
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_13 = add nsw i32 %zero_3, 8
  %Temp_14 = mul nsw i32 %Temp_12, %Temp_13
  %Temp_15 = call i32* @malloc(i32 %Temp_14)
  %Temp_10 = bitcast i32* %Temp_15 to i8**
  %Temp_16 = getelementptr inbounds i32, i32* %Temp_15, i32 0
;store TYPES.TYPE_INT@238e0d81 dst src;
  store i32 %Temp_11, i32* %Temp_16, align 4
  store i8** %Temp_10, i8*** @mystrs, align 8
  ret void
}
define void @main()
 { 
  %local_0 = alloca i32, align 4
  call void @init_globals()
  %Temp_17 = load i8**, i8*** @mystrs, align 8
%Temp_null_4 = bitcast i8** %Temp_17 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_4, 0
%Temp_i32_5 = bitcast i8** %Temp_17 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_18, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_18, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_19 = add nsw i32 %Temp_18,1
;getlement temp temp temp;
  %Temp_20 = getelementptr inbounds i8*, i8** %Temp_17, i32 %Temp_19
  %str_2 = alloca i8*
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @STR.I, i32 0, i32 0), i8** %str_2, align 8
  %Temp_21 = load i8*, i8** %str_2, align 8
;store TYPES.TYPE_STRING@2e5d6d97 dst src;
  store i8* %Temp_21, i8** %Temp_20, align 8
  call void @love()
  %Temp_22 = load i8**, i8*** @mystrs, align 8
  call void @lazagna(i8** %Temp_22 )
  %Temp_23 = load i8**, i8*** @mystrs, align 8
%Temp_null_6 = bitcast i8** %Temp_23 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_5, 0
%Temp_i32_7 = bitcast i8** %Temp_23 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_24, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_24, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_25 = add nsw i32 %Temp_24,1
;getlement temp temp temp;
  %Temp_26 = getelementptr inbounds i8*, i8** %Temp_23, i32 %Temp_25
  %str_3 = alloca i8*
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @STR.You, i32 0, i32 0), i8** %str_3, align 8
  %Temp_27 = load i8*, i8** %str_3, align 8
;store TYPES.TYPE_STRING@2e5d6d97 dst src;
  store i8* %Temp_27, i8** %Temp_26, align 8
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_28 = add nsw i32 %zero_6, 0
  store i32 %Temp_28, i32* %local_0, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_30 = load i32, i32* %local_0, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_31 = add nsw i32 %zero_7, 3
  %Temp_29 = icmp slt i32 %Temp_30, %Temp_31
  %Temp_32 = zext i1 %Temp_29 to i32
  %equal_zero_8 = icmp eq i32 %Temp_32, 0
  br i1 %equal_zero_8, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_33 = load i8**, i8*** @mystrs, align 8
%Temp_null_8 = bitcast i8** %Temp_33 to i32*
%equal_null_8 = icmp eq i32* %Temp_null_8, null
br i1 %equal_null_8, label %null_deref_8, label %continue_8
null_deref_8:
call void @InvalidPointer()
br label %continue_8
continue_8:
  %Temp_34 = load i32, i32* %local_0, align 4
%Temp_i32_9 = bitcast i8** %Temp_33 to i32*
%Temp_size_ptr_9 = getelementptr inbounds i32, i32* %Temp_i32_9, i32 0
%arr_size_9 = load i32, i32* %Temp_size_ptr_9,align 4
%sub_negative_9 = icmp slt i32  %Temp_34, 0
br i1 %sub_negative_9 , label %error_idx_9, label %positive_idx_9
positive_idx_9:
%out_of_bounds_9 = icmp sge i32 %Temp_34, %arr_size_9
br i1 %out_of_bounds_9 , label %error_idx_9, label %continue_idx_9
error_idx_9:
call void @AccessViolation()
br label %continue_idx_9
continue_idx_9:
  %Temp_35 = add nsw i32 %Temp_34,1
;getlement temp temp temp;
  %Temp_36 = getelementptr inbounds i8*, i8** %Temp_33, i32 %Temp_35
;load temp temp;
  %Temp_37 = load i8*, i8** %Temp_36, align 8
  call void @PrintString(i8* %Temp_37 )
  %Temp_39 = load i32, i32* %local_0, align 4
  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_9, 1
  %Temp_38 = add nsw i32 %Temp_39, %Temp_40
%Temp_41 = call i32 @CheckOverflow(i32 %Temp_38)
  store i32 %Temp_41, i32* %local_0, align 4
  br label %Label_2_while.cond

Label_0_while.end:

call void @exit(i32 0)
  ret void
}
