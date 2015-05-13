
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Instructions.h"
#include <set>
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/IR/ValueMap.h"

using namespace llvm;

namespace llvm {

struct LivenessInfo {
    std::set<const Value *> use;
    std::set<const Value *> def;
    std::set<const Value *> in;
    std::set<const Value *> out;
};

class Liveness: public FunctionPass {
private:

    DenseMap<const Instruction*, LivenessInfo> iLivenessMap;
    DenseMap<const BasicBlock*, LivenessInfo> bbLivenessMap;

    DenseMap<const Instruction*, int> instMap;


public:
	static char ID; 
	Liveness() : FunctionPass(ID) {}

	virtual bool runOnFunction(Function &F);
    void computeBBDefUse(Function &F);
    void computeBBInOut(Function &F);

    void computeIInOut(Function &F);

    bool isLiveOut(Instruction *I, Value *V);
    void addToMap(Function &F);

	virtual void getAnalysisUsage(AnalysisUsage &AU) const{
		AU.setPreservesAll();
	}



};

}


