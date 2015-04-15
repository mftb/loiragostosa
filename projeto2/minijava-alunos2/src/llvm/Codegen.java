/*****************************************************
Esta classe Codegen é a responsável por emitir LLVM-IR. 
Ela possui o mesmo método 'visit' sobrecarregado de
acordo com o tipo do parâmetro. Se o parâmentro for
do tipo 'While', o 'visit' emitirá código LLVM-IR que 
representa este comportamento. 
Alguns métodos 'visit' já estão prontos e, por isso,
a compilação do código abaixo já é possível.

class a{
    public static void main(String[] args){
    	System.out.println(1+2);
    }
}

O pacote 'llvmast' possui estruturas simples 
que auxiliam a geração de código em LLVM-IR. Quase todas 
as classes estão prontas; apenas as seguintes precisam ser 
implementadas: 

Todas as assinaturas de métodos e construtores 
necessárias já estão lá. 


Observem todos os métodos e classes já implementados
e o manual do LLVM-IR (http://llvm.org/docs/LangRef.html) 
como guia no desenvolvimento deste projeto. 

****************************************************/
package llvm;

import semant.Env;
import syntaxtree.*;
import llvmast.*;

import java.util.*;

public class Codegen extends VisitorAdapter{
	private List<LlvmInstruction> assembler;
	private Codegen codeGenerator;

  	private SymTab symTab;
	private ClassNode classEnv; 	// Aponta para a classe atualmente em uso em symTab
	private MethodNode methodEnv; 	// Aponta para a metodo atualmente em uso em symTab


	public Codegen(){
		assembler = new LinkedList<LlvmInstruction>();
	}

	// Método de entrada do Codegen
	public String translate(Program p, Env env){	
		codeGenerator = new Codegen();
		
		// Preenchendo a Tabela de Símbolos
		// Quem quiser usar 'env', apenas comente essa linha
		// codeGenerator.symTab.FillTabSymbol(p);
		
		// Formato da String para o System.out.printlnijava "%d\n"
		codeGenerator.assembler.add(new LlvmConstantDeclaration("@.formatting.string", "private constant [4 x i8] c\"%d\\0A\\00\""));	

		// NOTA: sempre que X.accept(Y), então Y.visit(X);
		// NOTA: Logo, o comando abaixo irá chamar codeGenerator.visit(Program), linha 75
		p.accept(codeGenerator);

		// Link do printf
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@printf", LlvmPrimitiveType.I32, pts)); 
		List<LlvmType> mallocpts = new LinkedList<LlvmType>();
		mallocpts.add(LlvmPrimitiveType.I32);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@malloc", new LlvmPointer(LlvmPrimitiveType.I8),mallocpts)); 


		String r = new String();
		for(LlvmInstruction instr : codeGenerator.assembler)
			r += instr+"\n";
		return r;
	}

	public LlvmValue visit(Program n){
		n.mainClass.accept(this);

		for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
			c.head.accept(this);

		return null;
	}

	public LlvmValue visit(MainClass n){
		
		// definicao do main 
		assembler.add(new LlvmDefine("@main", LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		LlvmRegister R1 = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
		assembler.add(new LlvmAlloca(R1, LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmStore(new LlvmIntegerLiteral(0), R1));

		// Statement é uma classe abstrata
		// Portanto, o accept chamado é da classe que implementa Statement, por exemplo,  a classe "Print". 
		n.stm.accept(this);  

		// Final do Main
		LlvmRegister R2 = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmLoad(R2,R1));
		assembler.add(new LlvmRet(R2));
		assembler.add(new LlvmCloseDefinition());
		return null;
	}
	// @@@@@@@@@@@@@@@@@ NOSSAS CHAMADAS DE VISITS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	public LlvmValue visit(Plus n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmPlus(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
	
	public LlvmValue visit(Minus n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmMinus(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
	
	public LlvmValue visit(Times n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmTimes(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
    
    public LlvmValue visit(Equal n){
	    LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmIcmp(lhs,"eq",LlvmPrimitiveType.I32,v1,v2));
		return lhs;
    }

    public LlvmValue visit(LessThan n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmIcmp(lhs,"slt",LlvmPrimitiveType.I32,v1,v2));
		return lhs;
    }
    
    public LlvmValue visit(True n){
        return new LlvmBool(1);
    }
	public LlvmValue visit(False n){
	    return new LlvmBool(0);
	}
    
    public LlvmValue visit(Not n){
        LlvmValue v1 = n.exp.accept(this);
        LlvmValue v2 = new LlvmBool(1);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmXor(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
    }
    
    public LlvmValue visit(And n){
        LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmAnd(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
    }
    
    public LlvmValue visit(IntegerType n){
        return new LlvmRegister(LlvmPrimitiveType.I32);
    }
    public LlvmValue visit(BooleanType n){
        return new LlvmRegister(LlvmPrimitiveType.I1);
    }
   
    public LlvmValue visit(If n){
        LlvmValue cond = n.condition.accept(this);
        LlvmLabelValue thenLabel = new LlvmLabelCreator();
        LlvmLabelValue elseLabel = new LlvmLabelCreator();
        LlvmLabelValue endLabel = new LlvmLabelCreator();
        assembler.add(new LlvmBranch(cond, thenLabel, elseLabel));
        assembler.add(new LlvmLabel(thenLabel));
        n.thenClause.accept(this);
        assembler.add(new LlvmBranch(endLabel));
        assembler.add(new LlvmLabel(elseLabel));
        n.elseClause.accept(this);
        assembler.add(new LlvmBranch(endLabel));
        assembler.add(new LlvmLabel(endLabel));
        return null;
    }

    public LlvmValue visit(This n){
        LlvmType classType = new LlvmPointer (new LlvmNamedClass("%" + classEnv.mangledName));
        LlvmValue self = new LlvmNamedValue("%self.addr", new LlvmPointer(classType));
        LlvmValue lhs = new LlvmRegister(classType);
        assembler.add (new LlvmLoad(lhs, self));
        return lhs;
    }

    public LlvmValue visit(Assign n){
        LlvmValue aux = n.var.accept (this);
        LlvmValue lhs;
        if (aux instanceof LlvmNamedValue) {
            lhs = new LlvmNamedValue (aux.toString () + ".addr",
            new LlvmPointer (aux.type));
        }
        else {
            lhs = new LlvmNamedValue (aux.toString (),
            new LlvmPointer (aux.type));
        }
        LlvmValue rhs = n.exp.accept (this);
        assembler.add(new LlvmStore(rhs, lhs));
        return null;
    }

    public LlvmValue visit(While n){
        LlvmLabelValue conditionLabel = new LlvmLabelCreator();
        LlvmLabelValue bodyLabel = new LlvmLabelCreator();
        LlvmLabelValue endLabel = new LlvmLabelCreator();
        assembler.add(new LlvmBranch(conditionLabel));
        assembler.add(new LlvmLabel(conditionLabel));
        LlvmValue cond = n.condition.accept(this);
        assembler.add(new LlvmBranch(cond, bodyLabel, endLabel));
        assembler.add(new LlvmLabel(bodyLabel));
        n.body.accept(this);
        assembler.add(new LlvmBranch(conditionLabel));
        assembler.add(new LlvmLabel(endLabel));
        return null;
    }


    // @@@@@@@@@@@@@@@@@ END NOSSAS CHAMADAS DE VISITS @@@@@@@@@@@@@@@@@@@@@@@@@
	
	public LlvmValue visit(Print n){

		LlvmValue v =  n.exp.accept(this);

		// getelementptr:
		LlvmRegister lhs = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I8));
		LlvmRegister src = new LlvmNamedValue("@.formatting.string",new LlvmPointer(new LlvmArray(4,LlvmPrimitiveType.I8)));
		List<LlvmValue> offsets = new LinkedList<LlvmValue>();
		offsets.add(new LlvmIntegerLiteral(0));
		offsets.add(new LlvmIntegerLiteral(0));
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		List<LlvmValue> args = new LinkedList<LlvmValue>();
		args.add(lhs);
		args.add(v);
		assembler.add(new LlvmGetElementPointer(lhs,src,offsets));

		pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		
		// printf:
		assembler.add(new LlvmCall(new LlvmRegister(LlvmPrimitiveType.I32),
				LlvmPrimitiveType.I32,
				pts,				 
				"@printf",
				args
				));
		return null;
	}
	
	public LlvmValue visit(IntegerLiteral n){
		return new LlvmIntegerLiteral(n.value);
	};
	

	// Todos os visit's que devem ser implementados	
	public LlvmValue visit(ClassDeclSimple n){return null;}
	public LlvmValue visit(ClassDeclExtends n){return null;}
	public LlvmValue visit(VarDecl n){return null;}
	public LlvmValue visit(MethodDecl n){return null;}
	public LlvmValue visit(Formal n){return null;}
	public LlvmValue visit(IntArrayType n){return null;}
	public LlvmValue visit(IdentifierType n){return null;}
	public LlvmValue visit(Block n){return null;}
	public LlvmValue visit(While n){return null;}
	public LlvmValue visit(ArrayAssign n){return null;}
	public LlvmValue visit(ArrayLookup n){return null;}
	public LlvmValue visit(ArrayLength n){return null;}
	public LlvmValue visit(Call n){return null;}
	public LlvmValue visit(IdentifierExp n){return null;}
	public LlvmValue visit(NewArray n){return null;}
	public LlvmValue visit(NewObject n){return null;}
	public LlvmValue visit(Identifier n){return null;}
}


/**********************************************************************************/
/* === Tabela de Símbolos ==== 
 * 
 * 
 */
/**********************************************************************************/

class SymTab extends VisitorAdapter{
    public Map<String, ClassNode> classes;     
    private ClassNode classEnv;    //aponta para a classe em uso

    public LlvmValue FillTabSymbol(Program n){
	    n.accept(this);
	    return null;
    }

    public LlvmValue visit(Program n){
	    n.mainClass.accept(this);

    	for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
		    c.head.accept(this);

	    return null;
    }

    public LlvmValue visit(MainClass n){
	    classes.put(n.className.s, new ClassNode(n.className.s, null, null));
    	return null;
    }

    public LlvmValue visit(ClassDeclSimple n){
	    List<LlvmType> typeList = null;
    	// Constroi TypeList com os tipos das variáveis da Classe (vai formar a Struct da classe)
	
	    List<LlvmValue> varList = null;
	    // Constroi VarList com as Variáveis da Classe

	    classes.put(n.name.s, new ClassNode(n.name.s, 
										new LlvmStructure(typeList), 
										varList)
      			);
    	// Percorre n.methodList visitando cada método
    	return null;
    }

	public LlvmValue visit(ClassDeclExtends n){return null;}
	public LlvmValue visit(VarDecl n){return null;}
	public LlvmValue visit(Formal n){return null;}
	public LlvmValue visit(MethodDecl n){return null;}
	public LlvmValue visit(IdentifierType n){return null;}
	public LlvmValue visit(IntArrayType n){return null;}
	public LlvmValue visit(BooleanType n){return null;}
	public LlvmValue visit(IntegerType n){return null;}
}

class ClassNode extends LlvmType {
    String mangledName;
    String name;
    private List<LlvmValue> varList;
    private List<LlvmType> types;
    private Map<String,MethodNode> methods;
    String parent;

    ClassNode (String nameClass, String parent, List<LlvmType> classTypes,
               List<LlvmValue> varList, Map<String,MethodNode> methods){
        this.varList = varList;
        this.types = classTypes;
        this.methods = methods;
        this.mangledName = mangle (nameClass);
        this.name = nameClass;
        this.parent = parent;
    }

    public  static String mangle (String a)   {
        return "class_" + a;
    }

    public  static String demangle (String a)   {
      return a.split("class_")[1];
    }

    public String toString () {
        String methods = "";
        if (this.methods != null) {
            for (String key : this.methods.keySet ()) {
                methods += this.methods.get (key);
            }
        }

        if (varList != null)
            return varList.toString () + " "
                + this.getStructure ().toString () + methods;

        return "[none]";
    }
    public MethodNode getMethod (String methodName) {
        if (methods.containsKey (methodName)) {
            return methods.get (methodName);
        }
        else if (parent != null) {
            return Codegen.symTab.classes.get (parent).getMethod (methodName);
        }
        else
            return null;
    }
    public LlvmValue getClassVariable (String variableName) {
        for (LlvmValue c : varList) {
            if (((LlvmNamedValue) c).name.equals (variableName))
                return c;
        }
         if (parent != null) {
            return Codegen.symTab.classes.get (parent).getClassVariable (variableName);
        }
        else
            return null;
    }
    public LlvmStructure getStructure () {
        ClassNode parent = this;
        List<LlvmType> types = new LinkedList<LlvmType>();
        while (parent != null) {
            types.addAll (parent.types);
            parent = Codegen.symTab.classes.get (parent.parent);
        }
        return new LlvmStructure (types);
    }
    public List<LlvmValue> getVarList () {
        ClassNode parent = this;
        List<LlvmValue> vars = new LinkedList<LlvmValue>();
        while (parent != null) {
            vars.addAll (parent.varList);
            parent = Codegen.symTab.classes.get (parent.parent);
        }

        return vars;
    }
}

class MethodNode {
    List<LlvmValue> varList;
    LlvmFunctionType types;
    String mangledName;

    MethodNode (String className, String methodName,
                List<LlvmValue> varList, LlvmFunctionType types) {
        this.varList = varList;
        this.types = types;
        this.mangledName = mangle (className, methodName);
    }

    String mangle (String className, String method) {
        String args = "";
        for (LlvmType c : types.parametersTypes) {
            if (c instanceof LlvmPointer) {
                LlvmPointer ptr = (LlvmPointer) c;
                String arg = c.toString().substring(1, c.toString().length()-2);
                args += "_" + arg;
            }
            else {
                args += "_" + c.toString ();
            }
        }

        return "@" + className + "_" + method + args;
    };

    public String toString () {
        String local_variables = "Local Variables:\n\t\t";
        for (LlvmValue c : varList) {
            local_variables += " " + c.type.toString () + " " + c.toString () + ";\n\t\t";

        }

        return "\n\t" + mangledName + "( " + this.types.toString ()  + ")" +
            "\n\t\t" +local_variables;
    }

}


