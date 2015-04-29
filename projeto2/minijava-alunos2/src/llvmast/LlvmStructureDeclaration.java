package llvmast;
import java.util.*;

import syntaxtree.VarDecl;
public class LlvmStructureDeclaration extends LlvmInstruction{
    LlvmStructure structure;
    String name;

    public LlvmStructureDeclaration(String name, LlvmStructure structure){
    	this.structure = structure;
        this.name = name;
    }

    public String toString() {
        return "%" + this.name + " = type " + structure.toString ();
    }
}
