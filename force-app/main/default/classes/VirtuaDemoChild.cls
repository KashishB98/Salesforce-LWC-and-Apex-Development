public class VirtuaDemoChild extends VirtualDemoParent{

    public VirtuaDemoChild(Integer a,Integer b){
        super(a,b);
    }
    public void childMethod2(){
        System.debug('I am coming from child');
    }
    
    public override void parentMethod(){
        System.debug('Now I am coming from child');
        
        // calls the parent also
        super.parentMethod();
    }
    /*
    public override void parentMethodSum(){
        System.debug('Now updated from Child '+ (2+3));
    }*/
    
}