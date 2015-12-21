public without sharing class ServiceHelper {
  
  public final static string serviceStrategies = 'ServiceStrategies';
  
  public final static string statusLogService = 'StatusLogService';
  public final static string testSoapService = 'TestSoapService';
  public final static string testRestService = 'TestRestService';
  
  private final static string googleCertificate = 'dsdasdujoifdfoiodffdjdfjjdjfd';
  private final static string facebookCertificate = 'dhfhdhfshuhfiuhiudfhf';
  
  public static map<String, String> getServiceHeaders(string headerType){
    map<string, string> headers = new map<string, string>();
    
    if(headerType != null){
      ServiceHeaders__c serviceHeaders = ServiceHeaders__c.getInstance(headerType);
      if(serviceHeaders.ContentType__c != null) headers.put('Content-Type',serviceHeaders.ContentType__c);
      if(serviceHeaders.Authorization__c != null){
        headers.put('Authorization',serviceHeaders.Authorization__c);
      }
      if(serviceHeaders.ContentEncoding__c != null) headers.put('Content-Encoding',serviceHeaders.ContentEncoding__c);
      if(serviceHeaders.AcceptEncoding__c != null) headers.put('Accept-Encoding',serviceHeaders.AcceptEncoding__c);
      if(serviceHeaders.ContentType__c != null) headers.put('Content-Type',serviceHeaders.ContentType__c);
    }
    
    return headers;
  }
  
  public static string getCertificate(string name){
    string certificate;
    
    if(name != null){
      if(name == 'google')
        certificate = googleCertificate;
      else if(name == 'facebook')
        certificate = facebookCertificate;
    }
    
    return certificate;
  }

}