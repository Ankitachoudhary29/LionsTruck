public class CreateAssetForOrder {
    
    @InvocableMethod
    public static void createSLAPerProduct(List<Id>orderIds){
        
        List<ServiceContract> serConList=new List<ServiceContract>();
        List<ContractLineItem> conliList=new List<ContractLineItem>();
        List<Asset>assetList=new List<asset>();
        List<Asset>aList=new List<asset>();
        Map<Id,OrderItem> orderItemMap=new Map<Id,OrderItem>();
        Map<Id,Order> olProdMap=new Map<Id,Order>();
        
        try{
            
            List<OrderItem> oliList=[select id,Product2Id,Quantity,UnitPrice,TotalPrice,OrderId,Product2.name from OrderItem where OrderId in:orderIds ];
            Map<id,order> olObjMap=new Map<Id,Order>([select id,OrderNumber,AccountId,BillToContactId from  order where id in:orderIds]);
            
            
            //Create asset records
            for(OrderItem oli:oliList ){
                
                
                Asset asObj=new Asset();
                asObj.Name=oli.Product2.name;
                asObj.Product2Id=oli.Product2Id;
                asObj.Status='Purchased';
                asObj.PurchaseDate=date.today();
                asObj.Price=oli.TotalPrice;
                asObj.Quantity= oli.Quantity;
                asObj.AccountId=olObjMap.get(oli.OrderId).AccountId;
                asObj.ContactId=olObjMap.get(oli.OrderId).BillToContactId;
                
                
                assetList.add(asObj);
            }
            
            insert assetList;
        }catch(Exception e){
            system.debug('Exception message'+e.getMessage());
        }
        
        
        
        
        
        
    }
    
    
}