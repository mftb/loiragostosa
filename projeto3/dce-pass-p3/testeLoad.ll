@.formatting.string = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry0:
  %tmp0 = alloca i32
  %tmp1 = alloca i32
  store i32 0, i32* %tmp0
  %tmp2 = load i32* %tmp0
  store i32 0, i32* %tmp1
  %tmp3 = load i32* %tmp1
  %tmp4 = add i32 %tmp2, 1
  %tmp5 = add i32 %tmp3, 1
  ret i32 0
}
