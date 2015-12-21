public without sharing abstract class BaseIO implements ServiceIOInterface {
  
  public abstract object convertInputToRequest(object serviceInput, string serviceEndpoint, map<string, string> requestHeader, object additionalDetails);
    
    public abstract object invokeWebserviceCallout(SoapRequest soapRequest);
    
    public abstract object convertResponseToOutput(object response, map<string, string> responseHeader, ServiceStatus serviceStatus);

}