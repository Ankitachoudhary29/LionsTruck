public class GetAssetDeatilsCtrl {
    
    private string client_id='b903e91e6c6542a3a4a6e800f37f95ea';
    private string client_secret='4d73e495F84E4c47B8a8E37C8F8B96b3';
    
    
    public class responseWrapper {
        public string id;
        public string access_token;
        public string instance_url;
    }
    public string getRequestToken() {
        string reqBody = 'grant_type=&client_id=' + client_id + '&client_secret=' + client_secret;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        //acesstoken url
        req.setEndpoint('https://auth-provider.cloudhub.io/external/access_token');
        HttpResponse hresp = h.send(req);
        responseWrapper wResp = (responseWrapper) JSON.deserialize(hresp.getBody(), responseWrapper.class);
        system.debug('Instance url' + wResp.instance_url);
        system.debug('session id' + wResp.access_token);
        return wResp.access_token;
    }
    
    
    @AuraEnabled
    public static string fetchAssetDetails(Id AssetId){
        
        String errmessage = null;
        
        Asset ast=new  Asset();
        ast=[select id,Vehicle_Identification_Number_VIN__c from asset where id=:AssetId];
        
        string Vin=ast.Vehicle_Identification_Number_VIN__c;
        
        string endPointUrl='https://eu1.anypoint.mulesoft.com/mocking/api/v1/sources/exchange/assets/a9111cc7-7a75-420b-996d-c403e449fb82/man-join-data-hub/1.0.2/m/'+vin;
        
        GetAssetDeatilsCtrl cls = new GetAssetDeatilsCtrl();
        string  accToken = cls.getRequestToken();
        try{
            if(accToken!=null){
                Http ht=new Http();
                
                HttpRequest req=new HttpRequest();
                req.setEndpoint(endPointUrl);
                req.setHeader('Authorization', 'Bearer ' + accToken);
                req.setHeader('Content-Type', 'application/json');
                req.setMethod('GET');
                
                HttpResponse res=ht.send(req);
                
                if(res.getStatusCode()==200){
                    
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    
                    
                    return 'Success';
                }else{
                    errmessage='Callout Exception'+' '+'status code:'+' '+res.getStatusCode()+''+'respose:'+''+res.getBody();
                    return errmessage;
                    
                }
                
            }
            return null;
            
        }catch(Exception e){
            
            string exceptionmsg=e.getMessage()+''+e.getLineNumber();
            return exceptionmsg;
        }  
        
        
    }
    
    
    
    
}