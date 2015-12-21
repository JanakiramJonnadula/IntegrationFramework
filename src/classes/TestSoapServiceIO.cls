public without sharing class TestSoapServiceIO extends SoapIO {
  
  String IPAddress;    
  
  public void convertInputToRequest(){
    IPAddress = (string) serviceInput;
  }  
  
  public override object invokeWebserviceCallout(SoapRequest soapRequest){
    
    GeoIPService.GeoIPServiceSoap stub = new GeoIPService.GeoIPServiceSoap();
    stub.endpoint_x = soapRequest.endpoint_x;
    stub.inputHttpHeaders_x = soapRequest.inputHttpHeaders_x;
    stub.clientCertName_x = soapRequest.clientCertName_x;
    stub.clientCert_x = soapRequest.clientCert_x;
    stub.clientCertPasswd_x = soapRequest.clientCertPasswd_x;
    stub.timeout_x = soapRequest.timeout_x;
    
    system.debug('IPAddress : ' + IPAddress);
    GeoIPService.GeoIP response = stub.GetGeoIP(IPAddress);
    
    return response;
  }
  
  public override object convertResponseToOutput(object response, map<string, string> responseHeader, ServiceStatus serviceStatus){
    
    TestSoapServiceOutput output = new TestSoapServiceOutput();
    
    if(serviceStatus.status == 'S' && response != null){
      GeoIPService.GeoIP geoIP = (GeoIPService.GeoIP) response;
      if(geoIP != null){
        output.CountryName = geoIP.CountryName;
        output.IP = geoIP.IP;
        output.ReturnCode = geoIP.ReturnCode;
        output.ReturnCodeDetails = geoIP.ReturnCodeDetails;
        output.serviceStatus = serviceStatus;
      }
    }
    else
      output.serviceStatus = serviceStatus;
    
      return output;
    } 

}