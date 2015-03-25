@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = mul i32 9, 9
  %tmp2 = mul i32 %tmp1, 2
  %tmp3 = add i32 %tmp2, 4
  %tmp4 = sub i32 %tmp3, 1
  %tmp5 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp6 = call i32 (i8 *, ...)* @printf(i8 * %tmp5, i32 %tmp4)
  %tmp7 = load i32 * %tmp0
  ret i32 %tmp7
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
