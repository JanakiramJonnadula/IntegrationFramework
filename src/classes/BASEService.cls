public without sharing abstract class BASEService implements ServiceInterface {
  
  public ServiceSettings__c serviceSettings; 
  public string guid;
  
  public string serviceEndpoint;
  public map<string, string> requestHeader;
  public string certificate;
  public Object requestBody;
  
  public Map<string, string> responseHeader;
  public Object responseBody;
  
  public ServiceStatus serviceStatus = new ServiceStatus();
  
  private Object serviceOutput;
  public ServiceIO serviceIO;
  
  private long serviceInputProcessingTime;
  private long serviceCalloutTime;
  private long serviceOutputProcessingTime;
    
  private abstract void prepareServiceRequest();
   
    private abstract void execute();
    
    private abstract void processServiceResponse();
    
    private void getServiceEndPoint(){
      serviceEndpoint = serviceSettings.EndPoint__c;          
    }
    
    private void getRequestHeader(){
      requestHeader = ServiceHelper.getServiceHeaders(serviceSettings.HeaderName__c);    
    }
    
    private void getCertificate(){
      certificate = ServiceHelper.getCertificate(serviceSettings.Certificate__c);    
    }
    
    private void getRequestBody(Object serviceInput){
      if(serviceIO != null){        
          requestBody = serviceIO.convertInputToRequest(serviceInput, serviceEndpoint, requestHeader, guid);          
          System.debug('Service Input : ' + serviceInput);
          System.debug('Service Endpoint : ' + serviceEndpoint);
          System.debug('Service Request Header : ' + requestHeader);
      }
    }
    
    private void prepareOutput(){
      if(serviceIO != null){
        serviceOutput = serviceIO.convertResponseToOutput(responseBody, responseHeader, serviceStatus);
          System.Debug('Service Output : ' + serviceOutput);   
      }     
    }
    
    private void logServiceStatus(){
      if(serviceSettings.LogStatus__c){
          StatusLog__c statusLog = new StatusLog__c();
      statusLog.Name = serviceSettings.Name;
      statusLog.UID__c = guid;
          statusLog.Status__c = serviceStatus.status;          
          statusLog.ErrorCode__c = serviceStatus.errorCode;
          statusLog.ErrorDescription__c = serviceStatus.errorDescription;
          statusLog.InputProcessingTime__c = serviceInputProcessingTime;
          statusLog.CalloutTime__c = serviceCalloutTime;
          statusLog.OutputProcessingTime__c = serviceOutputProcessingTime;  
          if(requestBody != null){
            if(requestBody instanceof string)
              statusLog.RequestBody__c = (String) requestBody;
            else
              statusLog.RequestBody__c = string.valueof(requestBody);
          }
          if(responseBody != null){
            if(responseBody instanceof string)
              statusLog.ResponseBody__c = (String) responseBody;
            else
              statusLog.ResponseBody__c = string.valueof(responseBody);
          }
          
          StatusLogHelper.logStatus(statusLog, false);
          //Service service = new Service(ServiceHelper.serviceStatusLogService);        
          //Object status = service.callout(statusLog);      
                  
      }
    }
  
  public Object performServiceCallout(ServiceSettings__c serviceSettings, Object serviceInput){
    DateTime startTime = system.now();
    try{
      this.serviceSettings = serviceSettings;
      if(serviceSettings.ProcessingClass__c != null)
        this.serviceIO = new ServiceIO(serviceSettings.ProcessingClass__c);
      this.serviceStatus.status = 'S';
      this.guid = GUIDGenerator.generateGUID();
      system.debug('GUID : ' + guid);
          
      getServiceEndPoint();
      getRequestHeader();    
      getCertificate();
      getRequestBody(serviceInput);
          
      prepareServiceRequest();
    }
    catch(Exception ex){
      serviceStatus.status = 'E';
        serviceStatus.errorCode = 'Input';
        serviceStatus.errorDescription = ' Processing Error : ' + ex.getMessage();      
    }
    serviceInputProcessingTime = system.now().getTime() - startTime.getTime();
    
    startTime = system.now();
        try{                
            if(serviceStatus.status == 'S') execute();              
        } catch(Exception ex) {
            serviceStatus.status = 'I';
        serviceStatus.errorCode = 'Interface';
        serviceStatus.errorDescription = ex.getMessage();
        }  
        serviceCalloutTime = system.now().getTime() - startTime.getTime();
        
        startTime = system.now(); 
        try{  
          processServiceResponse();        
          prepareOutput();
        }
        catch(Exception ex){
          serviceStatus.status = 'E';
        serviceStatus.errorCode = 'Output';
        serviceStatus.errorDescription = ' Processing Error : ' + ex.getMessage();
        }
        serviceOutputProcessingTime = system.now().getTime() - startTime.getTime();
        
        logServiceStatus();
        
        return serviceOutput;
    }

}