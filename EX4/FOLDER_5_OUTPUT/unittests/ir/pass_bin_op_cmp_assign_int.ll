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
define void @init_globals() #0 {
  ret void
}
define void @main() #0 {
  call void @init_globals()
  %Temp_0 = alloca i32, align 4
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_1 = add nsw i32 %zero_0, 10
  store i32 %Temp_1, i32* %Temp_0, align 4
  %Temp_2 = alloca i32, align 4
  %zero_1 = load i32, i32* @my_zero, align 4
  %Temp_3 = add nsw i32 %zero_1, 11
  store i32 %Temp_3, i32* %Temp_2, align 4
  %Temp_4 = alloca i32, align 4
  %Temp_6 = load i32, i32* %Temp_0, align 4
  %Temp_7 = load i32, i32* %Temp_2, align 4
  %oren_5 = icmp eq i32 %Temp_6, %Temp_7
  %Temp_5 = zext i1 %oren_5 to i32
  store i32 %Temp_5, i32* %Temp_4, align 4
  %Temp_9 = load i32, i32* %Temp_4, align 4
  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_10 = add nsw i32 %zero_2, 2
  %Temp_8 = add nsw i32 %Temp_9, %Temp_10
  call void @PrintInt(i32 %Temp_8) 
  ret void
}