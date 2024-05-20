public class TriggerHelper {
    
    // to store processed records with operation type
    private static Map<String,Set<Id>> processedRecords = new Map<String,Set<Id>>();
    
    public static boolean runOnce(Set<Id>newRecordIds, Set<Id>oldRecordIds,TriggerOperation operation) {
        
        Set<Id>recordIds = newRecordIds;        
        if(newRecordIds == null) {
            recordIds=oldRecordIds;
        }        
        if(recordIds == null) {
            return false;
        }        
        for(Id recordId : recordIds) {
            if(validateRecursive(recordId,operation.name()))
            {
                return true;
            }
        }        
        return false;
    }
    
    public static boolean validateRecursive(Id recordId, String operation){        
        Boolean recursive = false;
        if(processedRecords.containsKey(operation)) {
            if(processedRecords.get(operation).contains(recordId)) {
                recursive = true;
                return recursive;
            }
            processedRecords.get(operation).add(recordId);
        }
        else {
            processedRecords.put(operation,new Set<Id>{recordId});
        }
        return recursive;
    }   
}