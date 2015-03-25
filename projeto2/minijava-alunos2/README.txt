clang main.c -S -emit-llvm -o main.ll

lli main.ll

llc main.ll -o main.s

as main.s -o main.o

make run INPUT=test/test.java

#test
lli output.s
