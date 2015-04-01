package llvmast;
public  class LlvmXor extends LlvmInstruction{
    public LlvmRegister lhs;
    public LlvmType type;
    public LlvmValue op1, op2;

    public LlvmXor(LlvmRegister lhs, LlvmType type, LlvmValue op1, LlvmValue op2){
        this.lhs = lhs;
        this.type = type;
        this.op1 = op1;
        this.op2 = op2;
    }

    public String toString(){
        return "  " +lhs + " = xor " + type + " " + op1 + ", " + op2;
    }
}
