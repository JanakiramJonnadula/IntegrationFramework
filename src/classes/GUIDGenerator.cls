public class GUIDGenerator {
  
  private static String kHexChars = '0123456789abcdefABCDEF';

    public static String Generate(){

        String returnValue = '';
        Integer nextByte = 0;
        for(Integer i = 0; i < 16; i++){
            //if(i==4 || i==6 || i==8 || i==10){
              //  returnValue +='-';
            //}
            
            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if(i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            returnValue += charAt(kHexChars,nextByte & 15);
        }        
      }
      return returnValue;
    }
    
    public static String generateGUID(){
      string guid = '';
    for(Integer i = 0; i < 16; i++){
      String id = Generate();
      guid=guid + id;
    }
    return guid;
    }

    public static String charAt(String str, Integer index){
        if(str == null){
            return null;
        }
        if(str.length() <= 0){
            return str;    
        }
        if(index == str.length()){
            return null;    
        }
        return str.substring(index, index+1);
    }

}