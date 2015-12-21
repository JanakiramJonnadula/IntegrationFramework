public without sharing abstract class SoapIO extends BaseIO {  
  
  public object serviceInput;
  public object additionalDetails;
  
  private virtual void setCustomHeaderValues(map<string, string> requestHeader){
    
  }  
  
  private abstract void convertInputToRequest();
    
  public override object convertInputToRequest(object serviceInput, string serviceEndpoint, map<string, string> requestHeader, object additionalDetails){
      this.serviceInput = serviceInput;    
      this.additionalDetails = additionalDetails;  

    setCustomHeaderValues(requestHeader);  
    convertInputToRequest();      
    
      return serviceInput;
    }
    
    public override abstract object invokeWebserviceCallout(SoapRequest soapRequest);   
    
    public override virtual object convertResponseToOutput(object response, map<string, string> responseHeader, ServiceStatus serviceStatus){
      return response;
    } 

}