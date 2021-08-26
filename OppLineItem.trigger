trigger OppLineItem on OpportunityLineItem (before insert,before update) {
    
    
    // List<OpportunityLineItem> opliList=[SELECT Product2Id,OpportunityId, UnitPrice, Quantity,PricebookEntryId,Do_you_want_Service__c, TotalPrice  FROM OpportunityLineItem  WHERE id in:trigger.new];
    //find the service of the products added in OpportunityLineItem
    List<Id>PrdIds=new List<Id>();
    Map<id,PricebookEntry>prodpricebkEntryMap=new Map<id,PricebookEntry>();
    
    system.debug('opliList'+trigger.new);
    if(trigger.new!=null){
        for(OpportunityLineItem opli:trigger.new){
            //if(opli.Do_you_want_Service__c==true){
            
            PrdIds.add(opli.Product2Id); 
            system.debug('PrdIds'+PrdIds);
            //}  
        }  
        
        // List<Product2>serProdList=[select id,(select id ,UnitPrice,UseStandardPrice,IsActive from PricebookEntries where IsActive=true) from Product2 where Service_for__c in:PrdIds];
        List<PricebookEntry> serProdPrice=[select id ,UnitPrice,UseStandardPrice,IsActive,Product2Id,Product2.name,Product2.Service_for__c from PricebookEntry where IsActive=true and Product2.Service_for__c in :PrdIds ];
        
        system.debug('serProdPrice'+serProdPrice);
        for(PricebookEntry pr: serProdPrice){
            
            prodpricebkEntryMap.put(pr.Product2.Service_for__c, pr);
            system.debug('prodpricebkEntryMap'+prodpricebkEntryMap);
        }
        
        for(OpportunityLineItem opli:trigger.new){
            
            if(opli.Do_you_want_Service__c==true){
                
                opli.UnitPrice+=prodpricebkEntryMap.get(opli.Product2Id).UnitPrice;
                
                system.debug(' opli.UnitPrice'+ opli.UnitPrice);
            }else{
                
                opli.UnitPrice=opli.UnitPrice;
                system.debug(' opli.UnitPrice in else'+ opli.UnitPrice);
                
            }
        }
    }
    
}