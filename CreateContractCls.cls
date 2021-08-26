public class CreateContractCls {
    @InvocableMethod
    public static void createContractMethod(List<Id>quoteIds){
        
        Map<id,contract>oppContractMap=new Map<id,contract>();
        Map<id,Quote> oppQuoteMap=new map<id,Quote>();
        try{
            
            List<Quote>QuoteList=[select id,name,OpportunityId,AccountId,contractId from Quote where id in: quoteIds];
            for(quote qo:QuoteList){
                
                oppQuoteMap.put(qo.OpportunityId,qo);
            }
            
            //create  contract
            
            for(Quote q: QuoteList){
                
                contract con=new contract();
                con.AccountId=q.AccountId;
                con.Status='Draft';
                con.StartDate=date.today();
                con.ContractTerm=12;
                con.CompanySignedDate=date.today();
                con.CompanySignedId=UserInfo.getUserId();
                //con.OwnerExpirationNotice='15 Days';
                //con.SpecialTerms='This Contract can only be sold  with Truck';
                
                // conList.add(con);
                oppContractMap.put(q.OpportunityId,con);
            }
            
            if(oppContractMap.size()>0){
                
                insert oppContractMap.values();
                
            }
            
            
            //associate contract with Opp
            CreateContractCls conCls=new CreateContractCls();
            conCls.updateContractInOpp(oppContractMap);
        }catch(Exception e){
            system.debug('Exception message'+e.getMessage());
        } 
        
        
    }
    
    public void updateContractInOpp( Map<id,contract>oppConMap){
        
        List<Opportunity>opUpdate=new List<Opportunity>();
        
        try{
            List<Opportunity> oppList = [SELECT id,contractId FROM Opportunity WHERE Id in:oppConMap.keyset()];
            
            
            for(Opportunity op: oppList){
                
                op.contractId=oppConMap.get(op.Id).id;
                
                opUpdate.add(op);
                
            }
            
            update opUpdate;
        }
        catch(Exception e){
            system.debug('Exception message'+e.getMessage()+'Exception line No'+e.getLineNumber());
        }
    }
    
}