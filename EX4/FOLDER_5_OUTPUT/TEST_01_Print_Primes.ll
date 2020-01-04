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
  %Temp_1 = alloca i32, align 4
  store i32 %0, i32* %Temp_1, align 4
  %Temp_2 = alloca i32, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_0, 2
  store i32 %Temp_3, i32* %Temp_2, align 4
  %Temp_4 = alloca i32, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_1, 2
  store i32 %Temp_5, i32* %Temp_4, align 4
  br label %Label_2_while.cond

Label_2_while.cond:

  %Temp_7 = load i32, i32* %Temp_2, align 4
  %Temp_8 = load i32, i32* %Temp_1, align 4
  %oren_6 = icmp slt i32 %Temp_7, %Temp_8
  %Temp_6 = zext i1 %oren_6 to i32
  %equal_zero_2 = icmp eq i32 %Temp_6, 0
  br i1 %equal_zero_2, label %Label_0_while.end, label %Label_1_while.body
  
Label_1_while.body:

  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_3, 2
  store i32 %Temp_9, i32* %Temp_4, align 4
  br label %Label_5_while.cond

Label_5_while.cond:

  %Temp_11 = load i32, i32* %Temp_4, align 4
  %Temp_12 = load i32, i32* %Temp_1, align 4
  %oren_10 = icmp slt i32 %Temp_11, %Temp_12
  %Temp_10 = zext i1 %oren_10 to i32
  %equal_zero_4 = icmp eq i32 %Temp_10, 0
  br i1 %equal_zero_4, label %Label_3_while.end, label %Label_4_while.body
  
Label_4_while.body:

  br label %Label_6_if.cond

Label_6_if.cond:

  %Temp_15 = load i32, i32* %Temp_2, align 4
  %Temp_16 = load i32, i32* %Temp_4, align 4
  %Temp_14 = mul nsw i32 %Temp_15, %Temp_16
  %Temp_17 = load i32, i32* %Temp_1, align 4
  %oren_13 = icmp eq i32 %Temp_14, %Temp_17
  %Temp_13 = zext i1 %oren_13 to i32
  %equal_zero_5 = icmp eq i32 %Temp_13, 0
  br i1 %equal_zero_5, label %Label_8_if.exit, label %Label_7_if.body
  
Label_7_if.body:

  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_18 = add nsw i32 %zero_6, 0
  store i32 %Temp_18, i32* %Temp_0, align 4
  br label %RETURN_27739
  br label %Label_8_if.exit

Label_8_if.exit:

  %Temp_20 = load i32, i32* %Temp_4, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_21 = add nsw i32 %zero_7, 1
  %Temp_19 = add nsw i32 %Temp_20, %Temp_21
  store i32 %Temp_19, i32* %Temp_4, align 4
  br label %Label_5_while.cond

Label_3_while.end:

  %Temp_23 = load i32, i32* %Temp_2, align 4
  %zero_8 = load i32, i32* @my_zero, align 4
  %Temp_24 = add nsw i32 %zero_8, 1
  %Temp_22 = add nsw i32 %Temp_23, %Temp_24
  store i32 %Temp_22, i32* %Temp_2, align 4
  br label %Label_2_while.cond

Label_0_while.end:

  %zero_9 = load i32, i32* @my_zero, align 4
  %Temp_25 = add nsw i32 %zero_9, 1
  store i32 %Temp_25, i32* %Temp_0, align 4
  br label %RETURN_27739
  br label %RETURN_27739

RETURN_27739:

  %Temp_45 = load i32, i32* %Temp_0, align 4
  ret i32 %Temp_45
}
define void @PrintPrimes(i32, i32) #0 {
  %Temp_26 = alloca i32, align 4
  store i32 %0, i32* %Temp_26, align 4
  %Temp_27 = alloca i32, align 4
  store i32 %1, i32* %Temp_27, align 4
  %Temp_28 = alloca i32, align 4
  %Temp_29 = load i32, i32* %Temp_26, align 4
  store i32 %Temp_29, i32* %Temp_28, align 4
  br label %Label_11_while.cond

Label_11_while.cond:

  %Temp_31 = load i32, i32* %Temp_28, align 4
  %Temp_33 = load i32, i32* %Temp_27, align 4
  %zero_10 = load i32, i32* @my_zero, align 4
  %Temp_34 = add nsw i32 %zero_10, 1
  %Temp_32 = add nsw i32 %Temp_33, %Temp_34
  %oren_30 = icmp slt i32 %Temp_31, %Temp_32
  %Temp_30 = zext i1 %oren_30 to i32
  %equal_zero_11 = icmp eq i32 %Temp_30, 0
  br i1 %equal_zero_11, label %Label_9_while.end, label %Label_10_while.body
  
Label_10_while.body:

  br label %Label_12_if.cond

Label_12_if.cond:

  %Temp_35 = load i32, i32* %Temp_28, align 4
  %Temp_36 = call i32 @IsPrime(i32 %Temp_35) 
  %equal_zero_12 = icmp eq i32 %Temp_36, 0
  br i1 %equal_zero_12, label %Label_14_if.exit, label %Label_13_if.body
  
Label_13_if.body:

  %Temp_37 = load i32, i32* %Temp_28, align 4
  call void @PrintInt(i32 %Temp_37) 
  br label %Label_14_if.exit

Label_14_if.exit:

  %Temp_40 = load i32, i32* %Temp_28, align 4
  %zero_13 = load i32, i32* @my_zero, align 4
  %Temp_41 = add nsw i32 %zero_13, 1
  %Temp_39 = add nsw i32 %Temp_40, %Temp_41
  store i32 %Temp_39, i32* %Temp_28, align 4
  br label %Label_11_while.cond

Label_9_while.end:

  br label %RETURN_52222

RETURN_52222:

  ret void
}
define void @init_globals() #0 {
  ret void
}
define void @main() #0 {
  call void @init_globals()
  %zero_14 = load i32, i32* @my_zero, align 4
  %Temp_42 = add nsw i32 %zero_14, 2
  %zero_15 = load i32, i32* @my_zero, align 4
  %Temp_43 = add nsw i32 %zero_15, 100
  call void @PrintPrimes(i32 %Temp_42,  i32 %Temp_43) 
  br label %RETURN_17351

RETURN_17351:

  ret void
}
