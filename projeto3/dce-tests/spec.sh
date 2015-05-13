#!/bin/bash

# Este script:
# 1. Aplica o DCE contido em P3.so
# 2. Gera o executável i386 do resultado
# 3. Executa
# 4. Compara a saída do código otimizado com a golden

OPT=opt-3.6
LLC=llc-3.6
CC=g++
DIFF=diff
OPTLIB=../dce-pass-full/Release/P3.so

base=$PWD

if [ $# -lt 2 ]; then
    echo -ne "usage:\n"
    echo -ne "$0 spec/<APP>/<APP>.bc <PASS>\n"
    echo -ne "\t<APP> : gcc, dealII or xalan\n"
    echo -ne "\t<PASS>: -dce-liveness or -dce-ssa\n\n"
    exit 0
fi


case $1 in
    gcc)
        ${OPT} -load ${OPTLIB} $2 ./spec/gcc/gcc.bc -o ./spec/gcc/out-dce.bc  &> /dev/null
        cd spec/gcc/
        ${LLC} out-dce.bc
        ${CC} -m32 out-dce.s -o out-dce
        ./out-dce test/cccp.i -o test/cccp.s
        ${DIFF} test/cccp.s golden/output/cccp.s
        rm out-*
        cd $base
        ;;

    dealII)
        ${OPT} -load ${OPTLIB} $2 ./spec/dealII/dealII.bc -o ./spec/dealII/out-dce.bc &> /dev/null
        cd spec/dealII/
        ${LLC} out-dce.bc
        ${CC} -m32 -Ddeal_II_dimension=3 -DBOOST_DISABLE_THREADS  out-dce.s -o out-dce -lstdc++ -lm 
        ./out-dce 3
        for i in solution*; do 
            ${DIFF} $i golden/output/$i
        done
        rm out-*
        rm solution-*
        rm grid-*
        cd $base
        ;;
    
    xalan)
        ${OPT} -load ${OPTLIB} $2 ./spec/xalancbmk/xalancbmk.bc -o ./spec/xalancbmk/out-dce.bc &> /dev/null
        cd spec/xalancbmk/
        ${LLC} out-dce.bc
        ${CC} -m32 -DNDEBUG -DAPP_NO_THREADS -DXALAN_INMEM_MSG_LOADER        \
            -DPROJ_XMLPARSER -DPROJ_XMLUTIL -DPROJ_PARSERS                 \
            -DPROJ_SAX4C -DPROJ_SAX2 -DPROJ_DOM -DPROJ_VALIDATORS          \
            -DXML_USE_NATIVE_TRANSCODER -DXML_USE_INMEM_MESSAGELOADER      \
            -DXML_USE_PTHREADS out-dce.s -o out-dce -lstdc++ -lm 
        ./out-dce -v test/test.xml test/xalanc.xsl > test.out
        ${DIFF} test.out golden/output/test.out
        rm out-*
        rm test.out
        ;;
    *)
        echo "Aplicativo SPEC incorreto"
        ;;
esac


