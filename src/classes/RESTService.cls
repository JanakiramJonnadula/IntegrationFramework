public without sharing class RESTService extends BASEService {
  
  HttpRequest request = new HttpRequest();
    HttpResponse response = new HttpResponse();
    Http http = new Http();
    
    private void prepareServiceRequest(){
      if(serviceSettings.Timeout__c != null) request.setTimeout(integer.ValueOf(serviceSettings.Timeout__c));
      if(serviceSettings.Operation__c != null) request.setMethod(serviceSettings.Operation__c);
      if(serviceSettings.Compressed__c) request.setCompressed(serviceSettings.Compressed__c);
      if(serviceSettings.CertificateName__c != null) request.setClientCertificateName(serviceSettings.CertificateName__c);  
          
      if(certificate != null) request.setClientCertificate(certificate, serviceSettings.CertificatePassword__c);
        
        request.setEndpoint(serviceEndpoint);
        
        if(requestHeader != null && !requestHeader.isEmpty()){
          Set<string> keys = requestHeader.keySet();
          for(string key : keys){
            request.setHeader(key, requestHeader.get(key));
          }          
        }
        
        string jsonString;
        if(requestBody != null){
            if(requestBody instanceof string)
                jsonString = (string)requestBody;
            else
                jsonString = JSON.serializePretty(requestBody);
            request.setBody(jsonString);
        }
        
        requestBody = jsonString;        
        System.debug('Request Body : ' + requestBody);
    }
   
    private void execute(){
        try{
          system.debug('Request : ' + request);
            response = http.send(request); 
            system.debug('Response : ' + response);
        }
        catch(Exception ex) {
            system.debug('Interface Error : '+ex.getMessage());
            throw ex;
        }
    } 
    
    public void processServiceResponse(){
      responseBody = response.getBody();
        System.Debug('Response Body : ' + responseBody);
        
        //TODO
        //Set Response Headers
        
        if(response.getStatusCode() != 200 && response.getStatusCode() != 201){
          serviceStatus.status = 'I';
        serviceStatus.errorCode = string.valueOf(response.getStatusCode());
        serviceStatus.errorDescription = response.getStatus();            
            /*if(jsonResponse != null){
                XmlStreamReader xsr = new XmlStreamReader(jsonResponse);
                //TODO
                //Parse the XML for the error code and description
            }*/                   
        }
        else if(serviceSettings.OutputClass__c != null && responseBody != null && responseBody instanceof string && serviceStatus.status == 'S')
        responseBody = JSON.deserialize((string)responseBody, Type.forName(serviceSettings.OutputClass__c));  
    }

}