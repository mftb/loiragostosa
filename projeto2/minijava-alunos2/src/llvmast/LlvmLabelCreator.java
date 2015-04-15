package llvmast;


public class LlvmLabelCreator extends LlvmLabelValue{
	static int numberLabel = 0;
	
	public LlvmLabelCreator(){
        super("lbl"+numberLabel++);
	}

	public static void rewind(){
		numberLabel = 0;
	}
}
