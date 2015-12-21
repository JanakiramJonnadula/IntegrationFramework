public without sharing class StatusLogServiceIO extends RestIO {
  
  private virtual void setCustomHeaderValues(map<string, string> requestHeader){
    if(requestHeader != null && !requestHeader.isEmpty() && requestHeader.containsKey('Authorization'))
      requestHeader.put('Authorization', requestHeader.get('Authorization') + ' '+ UserInfo.getSessionId());    
  }

}