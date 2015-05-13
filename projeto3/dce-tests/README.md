Minijava
=======================

Contém programas do pacote de testes do minijava otimizado com Constant Propagation (CP).
O algoritmo de CP implementado no LLVM sempre remove as instruções após propagá-las, 
não deixando espaço para o DCE. Por isso, modifiquei o CP nativo do LLVM para que 
as instruções propagadas fossem removidas no DCE, e não no próprio CP. 

Como testar
------------

1. Aplique o DCE que você implementou nos bitcodes minijava/\*.bc 
2. Confira se o seu bitcode gerado executa sem Seg. Fault.
3. Confira se a saída da sua execução correta.
 
**Utilize o script minijava.sh como apoio.** 

SPEC2006       
===========

Três aplicativos do benchmark SPEC2006.
Cada pasta contém:

APP.bc  : bitcode em LLVM da aplicação APP
test    : arquivo(s) de input
golden  : output experado da aplicação do SPEC

Como testar
------------

1. Aplique o DCE que você implementou no APP.bc
2. Confira se o seu bitcode gerado executa sem Seg. Fault.
3. Confira se a saída da sua execução está de acordo com a golden/output.

**Utilize o script spec.sh como apoio**

Atenção 
------------

Não utilize o 'lli' para executar os bitcode SPEC. Gere assembler com 'llc' depois compile com 'gcc'.
O nível de maturidade do 'lli' não é o mesmo que o 'llc'. Como o SPEC são aplicações reais e pesadas, o 'lli' pode quebrar. 
Vejam o script 'spec.sh'.


