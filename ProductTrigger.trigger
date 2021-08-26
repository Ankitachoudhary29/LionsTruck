trigger ProductTrigger on Product2 (before insert,after insert,before update,after update,before delete, after delete,after undelete) {
    
    List<Product2>productList=new List<Product2>();
    List<Product2>serProductList=new List<Product2>();
    Map<id,PriceBookEntry> prodPriceMap=new Map<id,PriceBookEntry>();
    
    Id prodRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Lions_Truck_Product').getRecordTypeId();
    Id serviceRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Product_Service').getRecordTypeId();
    
    if(trigger.isafter && trigger.isInsert  ){
        
        
       productList=[select id,name,Is_Service__c,IsActive from Product2 where id in:trigger.new and recordTypeId=:prodRecordTypeId];
        
        
       
        if(!productList.isEmpty()){
           // Map<id,PriceBookEntry> prodPriceMap=new Map<id,PriceBookEntry>([SELECT Product2.id,Name,UnitPrice,UseStandardPrice,IsActive from PriceBookEntry where Product2.id in:productList and IsActive=true]);
            
            for(Product2 prod:productList){
                Product2 serprod=new Product2();
                serprod.Service_for__c=prod.Id;
                    serprod.Name='Service of'+''+'  '+prod.Name;
                    serprod.Is_Service__c=true;
                serprod.RecordTypeId=serviceRecordTypeId;
                serprod.Start_Date__c=date.today();
                serprod.End_Date__c=date.today()+364;
                //serprod.Subscription_Price__c=!(prodPriceMap.isEmpty())?(10*(prodPriceMap.get(prod.Id).unitPrice))/100:0;
                serProductList.add(serprod);
                
            }
            
            insert serProductList;
        }
    }
    
    if(trigger.isbefore && trigger.isdelete){
        
        List<Id>prodIds=new List<Id>();
        for(Product2 prod:trigger.old){
            prodIds.add(prod.Id);
            
        }
        
        //get the list of child to be deleted
        List<Product2> serProdList=[select id from Product2 where Service_for__c in:prodIds  ];
        if(!serProdList.isempty()){
             database.delete(serProdList) ;
            
        }
    }
    
    //check if product has more than 1 service
    if(trigger.isbefore && (trigger.isInsert || trigger.isupdate)){
        
        Set<id> prodIds = new Set<id>();
    Map<id, Product2> mapParentProd = new Map<id, Product2>();
        for (Product2 service : trigger.New) {
            if(service.RecordTypeId==serviceRecordTypeId)
        prodIds.add(service.Service_for__c);
            system.debug('prodIds'+prodIds);
    }
        
        //List<Product2> prodList = [SELECT Id, Name FROM Product2 WHERE Id IN :prodIds and RecordTypeId=:prodRecordTypeId  ];
         //system.debug('prodList'+prodList);
         List<Product2>serPrdList=[select id,name from Product2 where Service_for__c in:prodIds and RecordTypeId=:serviceRecordTypeId];
        
        if(serPrdList.size()>0){
            for (Product2 ser : trigger.New) {
                ser.addError('Service already exist for product ');
            }
            
        }
        
      
    }
    
     // if(trigger.isbefore && trigger.isupdate ){
    
    

}