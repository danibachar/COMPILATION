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

@STR.GrandfatherRUN = constant [15 x i8] c"GrandfatherRUN\00", align 1
@STR.GrandfatherSWIM = constant [16 x i8] c"GrandfatherSWIM\00", align 1
@STR.FatherRUN = constant [10 x i8] c"FatherRUN\00", align 1
@STR.SonRUN = constant [7 x i8] c"SonRUN\00", align 1
@STR.GrandfatherWALK = constant [16 x i8] c"GrandfatherWALK\00", align 1
@STR.FatherSWIM = constant [11 x i8] c"FatherSWIM\00", align 1
@STR.SonWALK = constant [8 x i8] c"SonWALK\00", align 1
@STR.FatherPAINT = constant [12 x i8] c"FatherPAINT\00", align 1
define void @init_globals()
 { 
  ret void
}
define void @main()
 { 
  %local_3 = alloca i8*, align 8
  %local_1 = alloca i8**, align 8
  %local_2 = alloca i8*, align 8
  %local_0 = alloca i32, align 4
  call void @init_globals()
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 0
  store i32 %Temp_0, i32* %local_0, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_1, 27
  %Temp_3 = add nsw i32 %Temp_2,1
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_2, 8
  %Temp_5 = mul nsw i32 %Temp_3, %Temp_4
  %Temp_6 = call i32* @malloc(i32 %Temp_5)
  %Temp_1 = bitcast i32* %Temp_6 to i8**
  %Temp_7 = getelementptr inbounds i32, i32* %Temp_6, i32 0
;store TYPES.TYPE_INT@31221be2 dst src;
  store i32 %Temp_2, i32* %Temp_7, align 4
  store i8** %Temp_1, i8*** %local_1, align 8
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_9 = load i32, i32* %local_0, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_3, 27
  %Temp_8 = icmp slt i32 %Temp_9, %Temp_10
  %Temp_11 = zext i1 %Temp_8 to i32
  %equal_zero_4 = icmp eq i32 %Temp_11, 0
  br i1 %equal_zero_4, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %Temp_12 = load i8**, i8*** %local_1, align 8
%Temp_null_0 = bitcast i8** %Temp_12 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %Temp_13 = load i32, i32* %local_0, align 4
%Temp_i32_1 = bitcast i8** %Temp_12 to i32*
%Temp_size_ptr_1 = getelementptr inbounds i32, i32* %Temp_i32_1, i32 0
%arr_size_1 = load i32, i32* %Temp_size_ptr_1,align 4
%sub_negative_1 = icmp slt i32  %Temp_13, 0
br i1 %sub_negative_1 , label %error_idx_1, label %positive_idx_1
positive_idx_1:
%out_of_bounds_1 = icmp sge i32 %Temp_13, %arr_size_1
br i1 %out_of_bounds_1 , label %error_idx_1, label %continue_idx_1
error_idx_1:
call void @AccessViolation()
br label %continue_idx_1
continue_idx_1:
  %Temp_14 = add nsw i32 %Temp_13,1
;getlement temp temp temp;
  %Temp_15 = getelementptr inbounds i8*, i8** %Temp_12, i32 %Temp_14
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_5, 0
  %Temp_18 = call i32* @malloc(i32 %Temp_17)
  %Temp_16 = bitcast i32* %Temp_18 to i8*
;store TYPES.TYPE_CLASS@377dca04 dst src;
  store i8* %Temp_16, i8** %Temp_15, align 8
  %Temp_20 = load i32, i32* %local_0, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_6, 1
  %Temp_19 = add nsw i32 %Temp_20, %Temp_21
%Temp_22 = call i32 @CheckOverflow(i32 %Temp_19)
  store i32 %Temp_22, i32* %local_0, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_7, 0
  store i32 %Temp_23, i32* %local_0, align 4
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_25 = load i32, i32* %local_0, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_8, 11
  %Temp_24 = icmp slt i32 %Temp_25, %Temp_26
  %Temp_27 = zext i1 %Temp_24 to i32
  %equal_zero_9 = icmp eq i32 %Temp_27, 0
  br i1 %equal_zero_9, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  %Temp_28 = load i8**, i8*** %local_1, align 8
%Temp_null_2 = bitcast i8** %Temp_28 to i32*
%equal_null_2 = icmp eq i32* %Temp_null_2, null
br i1 %equal_null_2, label %null_deref_2, label %continue_2
null_deref_2:
call void @InvalidPointer()
br label %continue_2
continue_2:
  %Temp_29 = load i32, i32* %local_0, align 4
%Temp_i32_3 = bitcast i8** %Temp_28 to i32*
%Temp_size_ptr_3 = getelementptr inbounds i32, i32* %Temp_i32_3, i32 0
%arr_size_3 = load i32, i32* %Temp_size_ptr_3,align 4
%sub_negative_3 = icmp slt i32  %Temp_29, 0
br i1 %sub_negative_3 , label %error_idx_3, label %positive_idx_3
positive_idx_3:
%out_of_bounds_3 = icmp sge i32 %Temp_29, %arr_size_3
br i1 %out_of_bounds_3 , label %error_idx_3, label %continue_idx_3
error_idx_3:
call void @AccessViolation()
br label %continue_idx_3
continue_idx_3:
  %Temp_30 = add nsw i32 %Temp_29,1
;getlement temp temp temp;
  %Temp_31 = getelementptr inbounds i8*, i8** %Temp_28, i32 %Temp_30
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_10, 0
  %Temp_34 = call i32* @malloc(i32 %Temp_33)
  %Temp_32 = bitcast i32* %Temp_34 to i8*
;store TYPES.TYPE_CLASS@377dca04 dst src;
  store i8* %Temp_32, i8** %Temp_31, align 8
  %Temp_36 = load i32, i32* %local_0, align 4
  %zero_11 = load i32, i32* @my_zero, align 4
  %Temp_37 = add nsw i32 %zero_11, 1
  %Temp_35 = add nsw i32 %Temp_36, %Temp_37
%Temp_38 = call i32 @CheckOverflow(i32 %Temp_35)
  store i32 %Temp_38, i32* %local_0, align 4
  br label %Label_5_while.cond

Label_3_while.end:

  %Temp_39 = load i8**, i8*** %local_1, align 8
%Temp_null_4 = bitcast i8** %Temp_39 to i32*
%equal_null_4 = icmp eq i32* %Temp_null_4, null
br i1 %equal_null_4, label %null_deref_4, label %continue_4
null_deref_4:
call void @InvalidPointer()
br label %continue_4
continue_4:
  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_12, 3
%Temp_i32_5 = bitcast i8** %Temp_39 to i32*
%Temp_size_ptr_5 = getelementptr inbounds i32, i32* %Temp_i32_5, i32 0
%arr_size_5 = load i32, i32* %Temp_size_ptr_5,align 4
%sub_negative_5 = icmp slt i32  %Temp_40, 0
br i1 %sub_negative_5 , label %error_idx_5, label %positive_idx_5
positive_idx_5:
%out_of_bounds_5 = icmp sge i32 %Temp_40, %arr_size_5
br i1 %out_of_bounds_5 , label %error_idx_5, label %continue_idx_5
error_idx_5:
call void @AccessViolation()
br label %continue_idx_5
continue_idx_5:
  %Temp_41 = add nsw i32 %Temp_40,1
;getlement temp temp temp;
  %Temp_42 = getelementptr inbounds i8*, i8** %Temp_39, i32 %Temp_41
;load temp temp;
  %Temp_43 = load i8*, i8** %Temp_42, align 8
  store i8* %Temp_43, i8** %local_2, align 8
  %Temp_44 = load i8**, i8*** %local_1, align 8
%Temp_null_6 = bitcast i8** %Temp_44 to i32*
%equal_null_6 = icmp eq i32* %Temp_null_6, null
br i1 %equal_null_6, label %null_deref_6, label %continue_6
null_deref_6:
call void @InvalidPointer()
br label %continue_6
continue_6:
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_45 = add nsw i32 %zero_13, 20
%Temp_i32_7 = bitcast i8** %Temp_44 to i32*
%Temp_size_ptr_7 = getelementptr inbounds i32, i32* %Temp_i32_7, i32 0
%arr_size_7 = load i32, i32* %Temp_size_ptr_7,align 4
%sub_negative_7 = icmp slt i32  %Temp_45, 0
br i1 %sub_negative_7 , label %error_idx_7, label %positive_idx_7
positive_idx_7:
%out_of_bounds_7 = icmp sge i32 %Temp_45, %arr_size_7
br i1 %out_of_bounds_7 , label %error_idx_7, label %continue_idx_7
error_idx_7:
call void @AccessViolation()
br label %continue_idx_7
continue_idx_7:
  %Temp_46 = add nsw i32 %Temp_45,1
;getlement temp temp temp;
  %Temp_47 = getelementptr inbounds i8*, i8** %Temp_44, i32 %Temp_46
;load temp temp;
  %Temp_48 = load i8*, i8** %Temp_47, align 8
  store i8* %Temp_48, i8** %local_3, align 8
call void @exit(i32 0)
  ret void
}
