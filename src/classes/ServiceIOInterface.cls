public interface ServiceIOInterface {
  
    object convertInputToRequest(object serviceInput, string serviceEndpoint, map<string, string> requestHeader, object additionalDetails);
       
    object invokeWebserviceCallout(SoapRequest soapRequest);
    
    object convertResponseToOutput(object response, map<string, string> responseHeader, ServiceStatus serviceStatus);

}