#!/bin/bash

OPT=opt-3.6
OPTLIB=../dce-pass-full/Release/P3.so

if [ $# -lt 2 ]; then
    echo -ne "Usage: \n"
    echo -ne "$0 minijava/<APP>.bc <PASS>\n"
    echo -ne "\t<APP> : Factorial, BubbleSort, TreeVisitor, ...\n"
    echo -ne "\t<PASS>: -dce-liveness or -dce-ssa\n\n"
    exit 0
fi

# DCE
${OPT} -S -load ${OPTLIB} $2 $1 > out-dce.ll



