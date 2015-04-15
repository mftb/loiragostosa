package llvmast;

import java.util.*;

public class LlvmNamedFunction extends LlvmRegister{

    public List<LlvmValue> argList;

    public LlvmNamedFunction(String name, LlvmType type, List<LlvmValue> argList){
        super(name, type);
        this.name = name;
        this.argList = argList;
    }

    public String toString(){
        return name; 
    }
}

