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

@STR.LucyInTheSkyWithDiamonds = constant [25 x i8] c"LucyInTheSkyWithDiamonds\00", align 1
@STR.nothing = constant [8 x i8] c"nothing\00", align 1
@STR.IsThisTheRealLifeIsItJustFantasy = constant [33 x i8] c"IsThisTheRealLifeIsItJustFantasy\00", align 1
@STR.NOWPLAYING = constant [11 x i8] c"NOWPLAYING\00", align 1
;;;;;;;;;;;;;;;;;;;
;                 ;
; GLOBAL VARIABLE ;
;                 ;
;;;;;;;;;;;;;;;;;;;
@nowplaying = global i8* null, align 8

define i8* @whatsPlaying(i8*)
 { 
  %m = alloca i8*, align 8
  store i8* %0, i8** %m, align 8
  %Temp_1 = load i8*, i8** %m, align 8
%Temp_null_0 = bitcast i8* %Temp_1 to i32*
%equal_null_0 = icmp eq i32* %Temp_null_0, null
br i1 %equal_null_0, label %null_deref_0, label %continue_0
null_deref_0:
call void @InvalidPointer()
br label %continue_0
continue_0:
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_0, 0
;getlement temp temp temp;
  %Temp_3 = getelementptr inbounds i8, i8* %Temp_1, i32 %Temp_2
  %Temp_4 = bitcast i8* %Temp_3 to i8**
  %Temp_5 = load i8*, i8** @nowplaying, align 8
;load temp temp;
%Temp_init_ptr_1 = bitcast i8** %Temp_4 to i32*
%init_state_1 = load i32, i32* %Temp_init_ptr_1,align 4
%is_init_1 = icmp eq i32  %init_state_1, 0
br i1 %is_init_1 , label %error_init_1, label %good_init_1
error_init_1:
call void @InvalidPointer()
br label %good_init_1
good_init_1:
%Temp_actual_ptr_1 = getelementptr inbounds i32, i32* %Temp_init_ptr_1, i32 1
%Temp_actual_1 = bitcast i32* %Temp_actual_ptr_1 to i8**
  %Temp_6 = load i8*, i8** %Temp_actual_1 , align 8
%oprnd1_size_0 = call i32 @strlen(i8* %Temp_6)
%oprnd2_size_0 = call i32 @strlen(i8* %Temp_5)
%new_size_0 = add nsw i32 %oprnd1_size_0, %oprnd2_size_0
%allocated_i32_0 = call i32* @malloc(i32 %new_size_0)
%allocated_0 = bitcast i32* %allocated_i32_0 to i8*
%new_0 = call i8* @strcpy(i8* %allocated_0, i8* %Temp_6)
%Temp_0 = call i8* @strcat(i8* %new_0, i8* %Temp_5)
  ret i8* %Temp_0
}
define void @init_globals()
 { 
  %str_0 = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @STR.nothing, i32 0, i32 0), i8** %str_0, align 8
  %Temp_7 = load i8*, i8** %str_0, align 8
  store i8* %Temp_7, i8** @nowplaying, align 8
  ret void
}
define void @main()
 { 
  %local_0 = alloca i8*, align 8
  %local_1 = alloca i8*, align 8
  call void @init_globals()
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_1, 12
  %Temp_10 = call i32* @malloc(i32 %Temp_9)
  %Temp_8 = bitcast i32* %Temp_10 to i8*
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_2, 0
;getlement temp temp temp;
  %Temp_12 = getelementptr inbounds i8, i8* %Temp_8, i32 %Temp_11
  %Temp_13 = bitcast i8* %Temp_12 to i8**
  %str_1 = alloca i8*
  store i8* getelementptr inbounds ([11 x i8], [11 x i8]* @STR.NOWPLAYING, i32 0, i32 0), i8** %str_1, align 8
  %Temp_14 = load i8*, i8** %str_1, align 8
;store TYPES.TYPE_STRING@2e0fa5d3 dst src;
%Temp_init_ptr_2 = bitcast i8** %Temp_13 to i32*
store i32 1, i32* %Temp_init_ptr_2,align 4
%Temp_actual_ptr_2 = getelementptr inbounds i32, i32* %Temp_init_ptr_2, i32 1
%Temp_actual_2 = bitcast i32* %Temp_actual_ptr_2 to i8**
  store i8* %Temp_14, i8** %Temp_actual_2, align 8
  store i8* %Temp_8, i8** %local_0, align 8
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_3, 12
  %Temp_17 = call i32* @malloc(i32 %Temp_16)
  %Temp_15 = bitcast i32* %Temp_17 to i8*
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_4, 0
;getlement temp temp temp;
  %Temp_19 = getelementptr inbounds i8, i8* %Temp_15, i32 %Temp_18
  %Temp_20 = bitcast i8* %Temp_19 to i8**
  %str_2 = alloca i8*
  store i8* getelementptr inbounds ([11 x i8], [11 x i8]* @STR.NOWPLAYING, i32 0, i32 0), i8** %str_2, align 8
  %Temp_21 = load i8*, i8** %str_2, align 8
;store TYPES.TYPE_STRING@2e0fa5d3 dst src;
%Temp_init_ptr_3 = bitcast i8** %Temp_20 to i32*
store i32 1, i32* %Temp_init_ptr_3,align 4
%Temp_actual_ptr_3 = getelementptr inbounds i32, i32* %Temp_init_ptr_3, i32 1
%Temp_actual_3 = bitcast i32* %Temp_actual_ptr_3 to i8**
  store i8* %Temp_21, i8** %Temp_actual_3, align 8
  store i8* %Temp_15, i8** %local_1, align 8
  %Temp_22 = load i8*, i8** %local_0, align 8
%Temp_23 =call i8* @whatsPlaying(i8* %Temp_22 )
  call void @PrintString(i8* %Temp_23 )
  %Temp_24 = load i8*, i8** %local_0, align 8
%Temp_25 =call i8* @whatsPlaying(i8* %Temp_24 )
  call void @PrintString(i8* %Temp_25 )
  %Temp_26 = load i8*, i8** %local_1, align 8
%Temp_27 =call i8* @whatsPlaying(i8* %Temp_26 )
  call void @PrintString(i8* %Temp_27 )
  %Temp_28 = load i8*, i8** %local_0, align 8
%Temp_29 =call i8* @whatsPlaying(i8* %Temp_28 )
  call void @PrintString(i8* %Temp_29 )
call void @exit(i32 0)
  ret void
}
