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
@y.123.CONST = constant [4 x i8] c"123\00", align 1
@y = global i8* null, align 8
@y.12345.CONST = constant [6 x i8] c"12345\00", align 1
@y.125.CONST = constant [4 x i8] c"125\00", align 1

define void @init_globals() #0 {
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @y.123.CONST, i32 0, i32 0), i8** @y, align 8
  ret void 
}

define void @main() #0 {
  call void @init_globals()
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @y.12345.CONST, i32 0, i32 0), i8** @y, align 8
  %Temp_0 = load i8*, i8** @y, align 8
  %Temp_1 = load i8*, i8** @y, align 8
  call void @PrintString(i8* %Temp_1) 
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @y.125.CONST, i32 0, i32 0), i8** @y, align 8
  %Temp_3 = load i8*, i8** @y, align 8
  %Temp_4 = load i8*, i8** @y, align 8
  call void @PrintString(i8* %Temp_4) 
  br label %RETURN_47025

RETURN_47025:

  ret void
}
