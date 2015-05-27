#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"

using namespace llvm;

namespace {
  struct GVN : public FunctionPass {
    static char ID;
    GVN() : FunctionPass(ID) {}

    virtual bool runOnFunction(Function &F) {
        BasicBlock::iterator prev;
        int store = 0;
        Value *val = NULL ,*reg = NULL;
        for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
            // Print out the name of the basic block if it has one, and then the
            // number of instructions that it contains
            // errs() << "Basic block (name=" << b->getName() << ") has " << b->size() << " instructions.\n";
            for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i){
                if(isa<StoreInst>(*i)){
                    store = 1;
                    val = i->getOperand(0);
                    reg = i->getOperand(1);
                }
                else if(isa<LoadInst>(*i) && store){
                    store = 0;
                    if(reg == i->getOperand(0)){
                        //i--;
                        //errs() << *i << "\n";
                        //i++;
                        //errs() << *i << "\n";
                        //errs() << "\n";
                        i->replaceAllUsesWith(val);
                        prev = --i;
                        //errs() << *prev << "\n";
                        i++;
                        //errs() << *i << "\n";
                        //errs() << *prev << "\n";
                        //errs() << "\n";
                        i->eraseFromParent();
                        i = prev;
                    }
                }
               else{
                    store = 0;
               }
            }
        }
        return false;
    }
  };
}

char GVN::ID = 0;
static RegisterPass<GVN> X("gvn-p3", "Hello World Pass", false, false);
