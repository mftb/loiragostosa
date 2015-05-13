P3 Alunos
=========

* p3: É o diretório em que seus códigos de otimização devem ficar; cada otimização deve ter um .cpp próprio 

* Release: É o diretório que ficará a biblioteca compilada (.so) da sua otimização

Comandos
--------

Para compilar suas otimizações presentes em p3
```bash
$ make
```

Para limpar
```bash
$ make clean
```

Para utilizar a otimizacao que está em p3/Hello.cpp no arquivo LLVM-IR tests/QuickSort.ll
```bash
$ opt -S -load Release/P3.so -hello tests/QuickSort.ll > tests/QuickSort.opt.ll
```

O resultado QuickSort.opt.ll está em LLVM-IR (ASCII). 

Montando arquivos LLVM-IR (ASCII) em LLVM bytecode
```bash
$ llvm-as input.ll -o output.bc
```

Compilando arquivos .cpp para LLVM-IR (ASCII)
```bash
$ clang++ -emit-llvm -S input.cpp -o output.ll
```

Compilando arquivos .cpp para LLVM-IR bytecode
```bash
$ clang++ -emit-llvm -c input.cpp -o output.bc
```



