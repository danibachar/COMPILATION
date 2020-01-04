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
@i1 = global i32 0, align 4
@i2 = global i32 0, align 4
@i3 = global i32 0, align 4
@i4 = global i32 0, align 4
define void @init_globals() #0 {
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 101
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 2
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_4 = add nsw i32 %zero_2, 3
  %Temp_2 = mul nsw i32 %Temp_3, %Temp_4
  %Temp_0 = add nsw i32 %Temp_1, %Temp_2
  store i32 %Temp_0, i32* @i1, align 4
  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_5 = add nsw i32 %zero_3, 15
  store i32 %Temp_5, i32* @i2, align 4
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_4, 17
  store i32 %Temp_6, i32* @i3, align 4
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_8 = add nsw i32 %zero_5, 62
  %zero_6 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_6, 2
  %Temp_7 = add nsw i32 %Temp_8, %Temp_9
  store i32 %Temp_7, i32* @i4, align 4
  ret void
}
define void @main() #0 {
  call void @init_globals()
  %Temp_0 = alloca i32, align 4
  %zero_7 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_7, 3
  store i32 %Temp_1, i32* %Temp_0, align 4
  %Temp_2 = load i32, i32* %Temp_0, align 4
  call void @PrintInt(i32 %Temp_2) 
  %Temp_3 = load i32, i32* @i2, align 4
  call void @PrintInt(i32 %Temp_3) 
  %Temp_5 = load i32, i32* @i2, align 4
  %Temp_6 = load i32, i32* %Temp_0, align 4
  %Temp_4 = add nsw i32 %Temp_5, %Temp_6
  call void @PrintInt(i32 %Temp_4) 
  %Temp_8 = load i32, i32* @i2, align 4
  %Temp_9 = load i32, i32* @i3, align 4
  %Temp_7 = add nsw i32 %Temp_8, %Temp_9
  call void @PrintInt(i32 %Temp_7) 
  %Temp_11 = load i32, i32* @i2, align 4
  %Temp_13 = load i32, i32* @i3, align 4
  %Temp_14 = load i32, i32* @i4, align 4
  %Temp_12 = mul nsw i32 %Temp_13, %Temp_14
  %Temp_10 = add nsw i32 %Temp_11, %Temp_12
  call void @PrintInt(i32 %Temp_10) 
  %Temp_17 = load i32, i32* @i2, align 4
  %Temp_18 = load i32, i32* @i3, align 4
  %Temp_16 = add nsw i32 %Temp_17, %Temp_18
  %Temp_19 = load i32, i32* @i4, align 4
  %Temp_15 = mul nsw i32 %Temp_16, %Temp_19
  call void @PrintInt(i32 %Temp_15) 
  ret void
}
