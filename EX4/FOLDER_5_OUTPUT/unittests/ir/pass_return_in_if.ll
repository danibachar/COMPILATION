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
define i32 @foo1(i32, i32) #0 {
  %Temp_0 = alloca i32, align 4
  %Temp_1 = alloca i32, align 4
  store i32 %0, i32* %Temp_1, align 4
  %Temp_2 = alloca i32, align 4
  store i32 %1, i32* %Temp_2, align 4
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_5 = load i32, i32* %Temp_1, align 4
  %Temp_6 = load i32, i32* %Temp_2, align 4
  %Temp_4 = add nsw i32 %Temp_5, %Temp_6
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_0, 50
  %oren_3 = icmp slt i32 %Temp_4, %Temp_7
  %Temp_3 = zext i1 %oren_3 to i32
  %equal_zero_1 = icmp eq i32 %Temp_3, 0
  br i1 %equal_zero_1, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %Temp_9 = load i32, i32* %Temp_1, align 4
  %Temp_10 = load i32, i32* %Temp_2, align 4
  %Temp_8 = sub nsw i32 %Temp_9, %Temp_10
  store i32 %Temp_8, i32* %Temp_0, align 4
  br label %RETURN_0
  br label %Label_2_if.exit

Label_2_if.exit:

  %Temp_12 = load i32, i32* %Temp_1, align 4
  %Temp_13 = load i32, i32* %Temp_2, align 4
  %Temp_11 = add nsw i32 %Temp_12, %Temp_13
  store i32 %Temp_11, i32* %Temp_0, align 4
  br label %RETURN_0

RETURN_0:

  %Temp_20 = load i32, i32* %Temp_0, align 4
  ret i32 %Temp_20
}
define void @init_globals() #0 {
  ret void
}
define void @main() #0 {
  call void @init_globals()
  %Temp_14 = alloca i32, align 4
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_15 = add nsw i32 %zero_2, 15
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_16 = add nsw i32 %zero_3, 15
  %Temp_17 = call i32 @foo1(i32 %Temp_15,  i32 %Temp_16) 
  store i32 %Temp_17, i32* %Temp_14, align 4
  %Temp_18 = load i32, i32* %Temp_14, align 4
  call void @PrintInt(i32 %Temp_18) 
  ret void
}
