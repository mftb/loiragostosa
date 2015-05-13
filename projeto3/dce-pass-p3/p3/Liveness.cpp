#include "llvm/IR/Instructions.h"
#include "Liveness.h"

#include <unistd.h>
#include <stdio.h>

using namespace std;

void print_elem(const Value* i) {
  errs() << i->getName() << " ";
}

bool Liveness::isLiveOut(Instruction *I, Value *V){
    return false;
}

void Liveness::computeBBDefUse(Function &F){
}

void Liveness::computeBBInOut(Function &F){
}

void Liveness::computeIInOut(Function &F) {
}

bool Liveness::runOnFunction(Function &F) {
    computeBBDefUse(F);
    computeBBInOut(F);
    computeIInOut(F);
	return false;
}

char Liveness::ID = 0;

RegisterPass<Liveness> X("liveness", "Live vars analysis", false, false);





