public class Stack {
    
    List<Object> stackList = new List<Object>();
    public void push(Object obj) {
        //implement push
        stackList.add(obj);
    }
    
    public Object pop() {
        //implement pop
        if(stackList != null){
            return stackList.remove(stackList.size() - 1);
        }
        return null;
    }
    
    public Integer size() {
        //implement size
        return stackList.size();
    }
    
    public Object peek(){
        //implement peek
        Integer lastIndex = stackList.size() - 1;
        return stackList[lastIndex];
    }
    
    public Boolean isEmpty() {
        //implement isEmpty
        if(stackList.isEmpty()){
            return true;
        }
        return false;
    }
}