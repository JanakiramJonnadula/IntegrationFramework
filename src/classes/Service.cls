public without sharing class Service{
   
    private ServiceSettings__c serviceSettings;
    public class StrategyNameException extends Exception{}
    public class ServiceSettingException extends Exception{}
    private ServiceInterface strategy;
    public static final Map<String, ServiceInterface> strategies;
    
    static{
        GlobalSettings__c serviceStrategies = GlobalSettings__c.getInstance(ServiceHelper.serviceStrategies);
        List<String> strategyNames = new List<String>();
        
        if(serviceStrategies != null && serviceStrategies.value__c != null)
            strategyNames = serviceStrategies.value__c.split(',');
            
        strategies = new Map<String, ServiceInterface>();
        
        for(String name : strategyNames){
            try{
                strategies.put(name, (ServiceInterface)Type.forName(name).newInstance());                    
            }
            catch(Exception e){
              system.debug('Strategy Exception : ' + e.getMessage());
                continue;
            }
        }    
    }   
    
    public Service(String serviceName){
        serviceSettings = ServiceSettings__c.getInstance(serviceName);
        if(serviceSettings != null){
          if(!strategies.containsKey(serviceSettings.Strategy__c))
              throw new StrategyNameException(serviceSettings.Strategy__c);
          strategy = strategies.get(serviceSettings.Strategy__c);
        }
        else
          throw new ServiceSettingException('Error : Service Configuration Setup is Missing for : ' + serviceName);
    }    
    
    public Object callout(Object serviceInput){        
        return strategy.performServiceCallout(serviceSettings, serviceInput);
    }
    
}