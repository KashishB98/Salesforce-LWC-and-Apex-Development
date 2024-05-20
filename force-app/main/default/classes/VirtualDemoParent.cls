public virtual class VirtualDemoParent {
    Integer aP;
    Integer bP;
    public VirtualDemoParent(Integer a,Integer b){
        this.aP = a;
        this.bP = b;
    }
    public virtual void parentMethod(){
        System.debug('I am coming from parent');
    }
    public Integer parentMethodSum(){
        return this.aP+this.bP;
    }
}