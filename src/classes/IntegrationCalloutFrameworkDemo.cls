public class IntegrationCalloutFrameworkDemo {
    public String ipAddress { get; set; }
    public String countryName { get; set; }
    public String firstName{ get; set; }
    public String lastName{ get; set; }
    
    public PageReference getCountry() {
        if(ipAddress != null){
            Service service = new Service(ServiceHelper.testSoapService);
            TestSoapServiceOutput output = (TestSoapServiceOutput) service.callout(ipAddress);            
            if(output != null)
                countryName = output.countryName;
        }
        return null;
    }
    
    public PageReference restCllout() {   
        Service service = new Service(ServiceHelper.testRestService);
        TestRestServiceInput input = new testRestServiceInput();
        input.firstName = firstName;
        input.lastName = lastName;
        Object output = service.callout(input);     
        return null;
    }
}