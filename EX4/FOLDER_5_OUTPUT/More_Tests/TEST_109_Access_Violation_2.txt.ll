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

@STR.Easy = constant [5 x i8] c"Easy\00", align 1
@STR.Oopsy = constant [6 x i8] c"Oopsy\00", align 1
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_1 = alloca i8*, align 8
  %local_2 = alloca i32, align 4
  %local_0 = alloca i8**, align 8
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 5
  %Temp_2 = add nsw i32 %Temp_1,1
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 8
  %Temp_4 = mul nsw i32 %Temp_2, %Temp_3
  %Temp_5 = call i32* @malloc(i32 %Temp_4)
  %Temp_0 = bitcast i32* %Temp_5 to i8**
  %Temp_6 = getelementptr inbounds i32, i32* %Temp_5, i32 0
;store TYPES.TYPE_INT@2e0fa5d3 dst src;
  store i32 %Temp_1, i32* %Temp_6, align 4
  store i8** %Temp_0, i8*** %local_0, align 8
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_2, 4
  store i32 %Temp_7, i32* %local_2, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_8 = load i32, i32* %local_2, align 4
  %equal_zero_3 = icmp eq i32 %Temp_8, 0
  br i1 %equal_zero_3, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  br label %Label_3_if.cond

Label_3_if.cond:

  %Temp_10 = load i32, i32* %local_2, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_4, 0
  %Temp_9 = icmp slt i32 %Temp_10, %Temp_11
  %Temp_12 = zext i1 %Temp_9 to i32
  %equal_zero_5 = icmp eq i32 %Temp_12, 0
  br i1 %equal_zero_5, label %Label_5_if.exit, label %Label_4_if.body
  
Label_4_if.body:

  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @STR.Oopsy, i32 0, i32 0), i8** %str_0, align 8
  %Temp_13 = load i8*, i8** %str_0, align 8
  call void @PrintString(i8* %Temp_13 )
  br label %Label_5_if.exit

Label_5_if.exit:

  %Temp_14 = load i8**, i8*** %local_0, align 8
%Temp_null_0 = bitcast i8** %Temp_14 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %Temp_15 = load i32, i32* %local_2, align 4
%Temp_i32_1 = bitcast i8** %Temp_14 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_15, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_15, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_16 = add nsw i32 %Temp_15,1
;getlement temp temp temp;
  %Temp_17 = getelementptr inbounds i8*, i8** %Temp_14, i32 %Temp_16
;load temp temp;
  %Temp_18 = load i8*, i8** %Temp_17, align 8
  store i8* %Temp_18, i8** %local_1, align 8
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @STR.Easy, i32 0, i32 0), i8** %str_1, align 8
  %Temp_19 = load i8*, i8** %str_1, align 8
  call void @PrintString(i8* %Temp_19 )
  %Temp_21 = load i32, i32* %local_2, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_22 = add nsw i32 %zero_6, 1
  %Temp_20 = sub nsw i32 %Temp_21, %Temp_22
%Temp_23 = call i32 @CheckOverflow(i32 %Temp_20)
  store i32 %Temp_23, i32* %local_2, align 4
  br label %Label_2_while.cond

Label_0_while.end:

call void @exit(i32 0)
  ret void
}
