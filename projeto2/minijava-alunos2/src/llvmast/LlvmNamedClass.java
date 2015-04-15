package llvmast;
public class LlvmNamedClass extends LlvmType{

    public String name;

	public LlvmNamedClass(String name){

		this.name = name;
	}

	public String toString(){
		return name;
	}
}
