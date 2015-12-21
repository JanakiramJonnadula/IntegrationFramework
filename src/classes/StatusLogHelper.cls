public with sharing class StatusLogHelper {
  
  public static void logStatus(StatusLog__c statusLog, boolean serviceCall){
    
    if(statusLog != null){
      if(!serviceCall)
        logStatusByDBCall(JSON.serializePretty(statusLog));
      else
        logStatusByRESTServiceCall(JSON.serializePretty(statusLog));
    }
    
  }
  
  @future
  public static void logStatusByDBCall(String jsonString){
    StatusLog__c  statusLog;
        
        try {
            statusLog = (StatusLog__c) JSON.deserialize(jsonString, StatusLog__c.class);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
        }
        
        if(statusLog != null) {
            try {
                upsert statusLog;
            } catch (Exception e) {
                System.debug('Error upserting SObjects');
            }            
        } 
  }
  
  @future (callout=true)
  public static void logStatusByRESTServiceCall(String jsonString){    
    Service service = new Service(ServiceHelper.statusLogService);        
        Object status = service.callout(jsonString);
  }

}