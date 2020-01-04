;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         ;
; GLOBAL VARIABLE :: zero ;
;                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
@my_zero = global i32 0, align 4

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         ;
; EXTERNAL LIBRARY FUNCS ;
;                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
declare i32* @malloc(i32)
declare i32 @strcmp(i8*, i8*)
declare void @exit(i32)
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         ;
; printf parameters       ;
;                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
@INT_FORMAT = constant [4 x i8] c"%d\0A\00", align 1
@STR_FORMAT = constant [4 x i8] c"%s\0A\00", align 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                 ;
; LIBRARY FUNCTION :: PrintString ;
;                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @PrintString(i8* %s) {
entry:
  %s.addr = alloca i8*, align 4
  store i8* %s, i8** %s.addr, align 4
  %0 = load i8*, i8** %s.addr, align 4
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @STR_FORMAT, i32 0, i32 0), i8* %0)
  ret void
}

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

;;;;;;;;;;;;;;;;;;:;
;                  ;
; GLOBAL VARIABLES ;
;                  ;
;;;;;;;;;;;;;;;;;;:;
@i = global i32 0, align 4
@j = global i32 0, align 4
@p = global i32 0, align 4
@start = global i32 0, align 4
@end = global i32 0, align 4
@isPrime = global i32 0, align 4
define void @main() #0 {
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_0 = add nsw i32 %zero_0, 2
  store i32 %Temp_0, i32* @p, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_1, 2
  store i32 %Temp_1, i32* @start, align 4
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_2, 100
  store i32 %Temp_2, i32* @end, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_4 = load i32, i32* @p, align 4
  %Temp_6 = load i32, i32* @end, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_3, 1
  %Temp_5 = add nsw i32 %Temp_6, %Temp_7
  %Temp_3 = icmp slt i32 %Temp_4, %Temp_5
  %equal_zero_4 = icmp eq i1 %Temp_3, 0
  br i1 %equal_zero_4, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_5, 2
  store i32 %Temp_8, i32* @i, align 4
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_6, 2
  store i32 %Temp_9, i32* @j, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_7, 1
  store i32 %Temp_10, i32* @isPrime, align 4
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_12 = load i32, i32* @i, align 4
  %Temp_13 = load i32, i32* @p, align 4
  %Temp_11 = icmp slt i32 %Temp_12, %Temp_13
  %equal_zero_8 = icmp eq i1 %Temp_11, 0
  br i1 %equal_zero_8, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_14 = add nsw i32 %zero_9, 2
  store i32 %Temp_14, i32* @j, align 4
  br label %Label_8_while.cond

Label_8_while.cond:

  %Temp_16 = load i32, i32* @j, align 4
  %Temp_17 = load i32, i32* @p, align 4
  %Temp_15 = icmp slt i32 %Temp_16, %Temp_17
  %equal_zero_10 = icmp eq i1 %Temp_15, 0
  br i1 %equal_zero_10, label %Label_6_while.end, label %Label_7_while.body
  
Label_7_while.body:

  br label %Label_9_if.cond

Label_9_if.cond:

  %Temp_20 = load i32, i32* @i, align 4
  %Temp_21 = load i32, i32* @j, align 4
  %Temp_19 = mul nsw i32 %Temp_20, %Temp_21
  %Temp_22 = load i32, i32* @p, align 4
  %Temp_18 = icmp eq i32 %Temp_19, %Temp_22
  %equal_zero_11 = icmp eq i1 %Temp_18, 0
  br i1 %equal_zero_11, label %Label_11_if.exit, label %Label_10_if.body
  
Label_10_if.body:

  %zero_12 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_12, 0
  store i32 %Temp_23, i32* @isPrime, align 4
  br label %Label_11_if.exit

Label_11_if.exit:

  %Temp_25 = load i32, i32* @j, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_26 = add nsw i32 %zero_13, 1
  %Temp_24 = add nsw i32 %Temp_25, %Temp_26
  store i32 %Temp_24, i32* @j, align 4
  br label %Label_8_while.cond

Label_6_while.end:

  %Temp_28 = load i32, i32* @i, align 4
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_29 = add nsw i32 %zero_14, 1
  %Temp_27 = add nsw i32 %Temp_28, %Temp_29
  store i32 %Temp_27, i32* @i, align 4
  br label %Label_5_while.cond

Label_3_while.end:

  br label %Label_12_if.cond

Label_12_if.cond:

  %Temp_31 = load i32, i32* @isPrime, align 4
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_32 = add nsw i32 %zero_15, 1
  %Temp_30 = icmp eq i32 %Temp_31, %Temp_32
  %equal_zero_16 = icmp eq i1 %Temp_30, 0
  br i1 %equal_zero_16, label %Label_14_if.exit, label %Label_13_if.body
  
Label_13_if.body:

  %Temp_33 = load i32, i32* @p, align 4
  call void @PrintInt(i32 %Temp_33) 
  br label %Label_14_if.exit

Label_14_if.exit:

  %Temp_35 = load i32, i32* @p, align 4
  %zero_17 = load i32, i32* @my_zero, align 4
  %Temp_36 = add nsw i32 %zero_17, 1
  %Temp_34 = add nsw i32 %Temp_35, %Temp_36
  store i32 %Temp_34, i32* @p, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  ret void
}
