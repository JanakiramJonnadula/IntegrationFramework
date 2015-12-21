public without sharing class SOAPService extends BaseService {  

    SoapRequest soapRequest = new SoapRequest();
    
    private void prepareServiceRequest(){
      
      if(serviceSettings.Timeout__c != null) soapRequest.timeout_x = integer.ValueOf(serviceSettings.Timeout__c);
      if(serviceSettings.CertificateName__c != null) soapRequest.clientCertName_x = serviceSettings.CertificateName__c;  
          
      if(certificate != null){
        soapRequest.clientCert_x = certificate;
        soapRequest.clientCertPasswd_x = serviceSettings.CertificatePassword__c;
      }
        
        soapRequest.endpoint_x = serviceEndpoint;
        
        if(requestHeader != null && !requestHeader.isEmpty()) soapRequest.inputHttpHeaders_x = requestHeader;
    }
   
    private void execute(){
        try{ 
          if(serviceIO != null)         
            responseBody = serviceIO.invokeWebserviceCallout(soapRequest);
        }
        catch(Exception e) {
            system.debug('***** Exception received = '+e.getMessage());
            throw e;
        }
    } 
    
    public void processServiceResponse(){      
      //TODO
        //Set Response Headers
    }

}