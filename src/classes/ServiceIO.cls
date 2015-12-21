public with sharing class ServiceIO {
  
  public class NameException extends Exception{}
    public static final map<String, ServiceIOInterface> strategies;
    private ServiceIOInterface strategy;    
    
    static{
        List<ServiceSettings__c> serviceSettings = ServiceSettings__c.getall().values();      
        List<String> strategyNames = new List<String>();
        
        for(ServiceSettings__c ss : serviceSettings){          
            strategyNames.add(ss.ProcessingClass__c);
        }
            
        strategies = new Map<String, ServiceIOInterface>();
        
        for(String name : strategyNames){
            try{
                strategies.put(name, (ServiceIOInterface)Type.forName(name).newInstance());                    
            }
            catch(Exception e){
              system.debug('Strategy Exception : ' + e.getMessage());              
                continue;
            }
        }          
    } 
    
    public ServiceIO(String ioClass){
        if(!strategies.containsKey(ioClass))
            throw new NameException(ioClass);
        strategy = strategies.get(ioClass);
    }
    
    public Object convertInputToRequest(Object serviceInput, string serviceEndpoint, map<string, string> requestHeader, string messageReference){        
        return strategy.convertInputToRequest(serviceInput, serviceEndpoint, requestHeader, messageReference);
    }
    
    public Object invokeWebserviceCallout(SoapRequest soapRequest){        
        return strategy.invokeWebserviceCallout(soapRequest);        
    }
    
    public Object convertResponseToOutput(Object response, map<string, string> responseHeader, ServiceStatus serviceStatus){        
        return strategy.convertResponseToOutput(response, responseHeader, serviceStatus);
    }

}