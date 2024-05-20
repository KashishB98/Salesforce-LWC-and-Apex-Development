public class DSAPractice {
    
    public static Integer isTarget(List<Integer>intList,Integer target,Integer low,Integer high){
        if(low == high && target == intList[low]){
            return low;
        }
        if(low <= high && low != high){
            Integer mid = low+(high-low)/2;
            if(target == intList[mid]){
                return mid;
            }
            else if(target < intList[mid]){
                return isTarget(intList,target,low,mid-1);
            }
            else if(target > intList[mid]){ // low = 2 high - 3
                return isTarget(intList,target,mid+1,high);
            }
        }
        return -1;
        
    }
    
}