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
define i32 @IsPrime(i32) #0 {
  %Temp_0 = alloca i32, align 4
  store i32 %0, i32* %Temp_0, align 4
  %Temp_1 = alloca i32, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_2 = add nsw i32 %zero_0, 2
  store i32 %Temp_2, i32* @i, align 4
  %Temp_3 = alloca i32, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_1, 2
  store i32 %Temp_4, i32* @j, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_6 = load i32, i32* %Temp_1, align 4
  %Temp_7 = load i32, i32* %Temp_0, align 4
  %oren_5 = icmp slt i32 %Temp_6, %Temp_7
  %Temp_5 = zext i1 %oren_5 to i32
  %equal_zero_2 = icmp eq i32 %Temp_5, 0
  br i1 %equal_zero_2, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_3, 2
  store i32 %Temp_8, i32* @j, align 4
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_10 = load i32, i32* @j, align 4
  %Temp_11 = load i32, i32* @p, align 4
  %oren_9 = icmp slt i32 %Temp_10, %Temp_11
  %Temp_9 = zext i1 %oren_9 to i32
  %equal_zero_4 = icmp eq i32 %Temp_9, 0
  br i1 %equal_zero_4, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_14 = load i32, i32* @i, align 4
  %Temp_15 = load i32, i32* @j, align 4
  %Temp_13 = mul nsw i32 %Temp_14, %Temp_15
  %Temp_16 = load i32, i32* @p, align 4
  %oren_12 = icmp eq i32 %Temp_13, %Temp_16
  %Temp_12 = zext i1 %oren_12 to i32
  %equal_zero_5 = icmp eq i32 %Temp_12, 0
  br i1 %equal_zero_5, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_17 = add nsw i32 %zero_6, 0
  br label %Label_8_if.exit

Label_8_if.exit:

  %Temp_19 = load i32, i32* @j, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_20 = add nsw i32 %zero_7, 1
  %Temp_18 = add nsw i32 %Temp_19, %Temp_20
  store i32 %Temp_18, i32* @j, align 4
  br label %Label_5_while.cond

Label_3_while.end:

  %Temp_22 = load i32, i32* @i, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_23 = add nsw i32 %zero_8, 1
  %Temp_21 = add nsw i32 %Temp_22, %Temp_23
  store i32 %Temp_21, i32* @i, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_9, 1
  ret i32 %Temp_24
}
define void @PrintPrimes(i32, i32) #0 {
  %Temp_25 = alloca i32, align 4
  store i32 %0, i32* %Temp_25, align 4
  %Temp_26 = alloca i32, align 4
  store i32 %1, i32* %Temp_26, align 4
  %Temp_27 = alloca i32, align 4
  %Temp_28 = load i32, i32* %Temp_25, align 4
  store i32 %Temp_28, i32* @p, align 4
  br label %Label_11_while.cond

Label_11_while.cond:

  %Temp_30 = load i32, i32* %Temp_27, align 4
  %Temp_32 = load i32, i32* %Temp_26, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_33 = add nsw i32 %zero_10, 1
  %Temp_31 = add nsw i32 %Temp_32, %Temp_33
  %oren_29 = icmp slt i32 %Temp_30, %Temp_31
  %Temp_29 = zext i1 %oren_29 to i32
  %equal_zero_11 = icmp eq i32 %Temp_29, 0
  br i1 %equal_zero_11, label %Label_9_while.end, label %Label_10_while.body
  
Label_10_while.body:

  br label %Label_12_if.cond

Label_12_if.cond:

  %Temp_34 = load i32, i32* @p, align 4
  %Temp_35 = call i32 @IsPrime(i32 %Temp_34) 
  %equal_zero_12 = icmp eq i32 %Temp_35, 0
  br i1 %equal_zero_12, label %Label_14_if.exit, label %Label_13_if.body
  
Label_13_if.body:

  %Temp_36 = load i32, i32* @p, align 4
  call void @PrintInt(i32 %Temp_36) 
  br label %Label_14_if.exit

Label_14_if.exit:

  %Temp_39 = load i32, i32* @p, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_40 = add nsw i32 %zero_13, 1
  %Temp_38 = add nsw i32 %Temp_39, %Temp_40
  store i32 %Temp_38, i32* @p, align 4
  br label %Label_11_while.cond

Label_9_while.end:

  ret void
}
define void @init_globals() #0 {
  ret void
}
define void @main() #0 {
  call void @init_globals()
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_14, 2
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_15, 100
  call void @PrintPrimes(i32 %Temp_41,  i32 %Temp_42) 
  ret void
}
