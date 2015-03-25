clang main.c -S -emit-llvm -o main.ll

lli main.ll

llc main.ll -o main.s

as main.s -o main.o

make run INPUT=test/test.java

#test
lli output.s

https://gitorious.org/unicamp/llvm-ir-backend/source/5a3d8689525648f13cf9db4e187af9c1e2658ef7:

http://compiladores-minijava-equipe10.googlecode.com/files/%5BCS%5D%20Modern%20Compiler%20Implementation%20in%20Java,%202nd%20ed.%28Andrew%20Appel_%20Cambrdige%20University%20Press%29%282004%29.pdf
