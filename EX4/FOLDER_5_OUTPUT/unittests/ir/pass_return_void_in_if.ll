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
define void @foo1(i32, i32) #0 {
  %Temp_0 = alloca i32, align 4
  store i32 %0, i32* %Temp_0, align 4
  %Temp_1 = alloca i32, align 4
  store i32 %1, i32* %Temp_1, align 4
  br label %Label_0_if.cond

Label_0_if.cond:

  %Temp_4 = load i32, i32* %Temp_0, align 4
  %Temp_5 = load i32, i32* %Temp_1, align 4
  %Temp_3 = add nsw i32 %Temp_4, %Temp_5
  %zero_0 = load i32, i32* @my_zero, align 4
  %Temp_6 = add nsw i32 %zero_0, 50
  %oren_2 = icmp slt i32 %Temp_3, %Temp_6
  %Temp_2 = zext i1 %oren_2 to i32
  %equal_zero_1 = icmp eq i32 %Temp_2, 0
  br i1 %equal_zero_1, label %Label_2_if.exit, label %Label_1_if.body
  
Label_1_if.body:

  %zero_2 = load i32, i32* @my_zero, align 4
  %Temp_7 = add nsw i32 %zero_2, 50
  call void @PrintInt(i32 %Temp_7) 
  br label %RETURN_83938
  br label %Label_2_if.exit

Label_2_if.exit:

  %zero_3 = load i32, i32* @my_zero, align 4
  %Temp_9 = add nsw i32 %zero_3, 40
  call void @PrintInt(i32 %Temp_9) 
  br label %RETURN_83938
  br label %RETURN_83938

RETURN_83938:

  ret void
}
define void @init_globals() #0 {
  ret void
}
define void @main() #0 {
  call void @init_globals()
  %zero_4 = load i32, i32* @my_zero, align 4
  %Temp_11 = add nsw i32 %zero_4, 15
  %zero_5 = load i32, i32* @my_zero, align 4
  %Temp_12 = add nsw i32 %zero_5, 15
  call void @foo1(i32 %Temp_11,  i32 %Temp_12) 
  br label %RETURN_33879

RETURN_33879:

  ret void
}
