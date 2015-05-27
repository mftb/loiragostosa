#include "Liveness.h"
#include <unistd.h>
#include <stdio.h>
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SCCIterator.h"
#include "llvm/ADT/GraphTraits.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Instructions.h"
#include <set>
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/CFG.h"


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
    
    errs() << "SCCs for " << F.getName() << " in post-order:\n";
    for (scc_iterator<Function *> I = scc_begin(&F),IE = scc_end(&F);I != IE; ++I){
        // Obtain the vector of BBs in this SCC and print it out.
        const std::vector<BasicBlock *> &SCCBBs = *I;
        errs() << "  SCC: ";
        for (std::vector<BasicBlock *>::const_iterator BBI = SCCBBs.begin(),BBIE = SCCBBs.end();BBI != BBIE; ++BBI) {
            errs() << (*BBI)->getName() << "  ";
            for (BasicBlock::iterator i = (*BBI)->begin(), ie = (*BBI)->end(); i != ie; ++i){
                //errs() << *i << ":";
                //errs() << i->getNumOperands()<<"\n";
            }
        }
        errs() << "\n";
    }


	return false;
}

char Liveness::ID = 0;

RegisterPass<Liveness> X("liveness", "Live vars analysis", false, false);





