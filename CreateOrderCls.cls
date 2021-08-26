public class CreateOrderCls {
    @InvocableMethod
    public static void createOrderMethod(List<id> oppId){
        
        List<OrderItem> OrderLineItems = New List<OrderItem>();
        List<Order>orList=new List<Order>();
        Map<id,Order>oppOrderMap=new Map<id,Order>();
        //Map<Id,Contract>oppContract=new map<id,Contract>();
        try{
            Map<Id,Quote> opQuotes=new Map<Id,Quote>([select id,name,IsSyncing,AccountId,contractId,OpportunityId,Pricebook2Id from quote where OpportunityId in:oppId and IsSyncing=true and status='Accepted']);
            
            system.debug('opQuotes----'+opQuotes);
            
            //get opp and opplineitems
            List<Opportunity> oppList = [SELECT Pricebook2Id, AccountId,contactId, contractId, Order_Created__c FROM Opportunity WHERE Id in:oppId];
            List<QuoteLineItem>quoteLneItemList=[select id,Product2Id,QuoteId,UnitPrice,Quantity,TotalPrice,ListPrice,PricebookEntryId from QuoteLineItem where QuoteId in:opQuotes.keyset()];
            
            
            
            //create order
            for(Quote qo: opQuotes.values()){
                Order orders=new order();
                orders.AccountId=qo.AccountId;
                //orders.BillToContactId=op.contactId;
                orders.ContractId= qo.ContractId;
                orders.EffectiveDate = date.today();
                orders.Status='Draft';
                orders.Pricebook2Id=qo.Pricebook2Id;
                orders.EndDate  = date.today()+1;
                orders.QuoteId=qo.id;
                orders.OpportunityId=qo.OpportunityId;
                
                oppOrderMap.put(qo.id,orders);
                //orList.add(orders);
            }
            
            if(!oppOrderMap.isEmpty()){
                Insert oppOrderMap.values();
                
            }
            
            
            
            
            //create orderlineItem
            
            for(QuoteLineItem qoli:quoteLneItemList){
                
                OrderItem orItem=new OrderItem();
                orItem.Quantity=qoli.Quantity;
                orItem.Product2Id=qoli.Product2Id;
                orItem.OrderId =oppOrderMap.get(qoli.quoteId).id;
                orItem.UnitPrice  = qoli.UnitPrice;
                orItem.PricebookEntryId=qoli.PricebookEntryId;
                OrderLineItems.add(orItem);            
            }
            insert OrderLineItems;       
            
            
        }catch(Exception e){
            system.debug('Exception message'+e.getMessage()+'Exception line No'+e.getLineNumber());
        }
    }
}