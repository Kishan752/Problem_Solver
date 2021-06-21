public class InsertPincode implements Queueable{
    public list<PincodeService.PostalResponseWrapper> Pincodes=new list<PincodeService.PostalResponseWrapper>();
    public InsertPincode(list<PincodeService.PostalResponseWrapper> wrapper){
       Pincodes=wrapper;        
    }
    
    
    public void execute(QueueableContext context) {
             list<Pincode__c> pnds=new list<Pincode__c>();
        for(PincodeService.PostalResponseWrapper pw:Pincodes){
           Pincode__c pc= new Pincode__c();
            pc.Name=pw.Name;
            pc.Pincode__c=pw.PINCode;
            pc.State__c=pw.State;
            pnds.add(pc);
        }
        
        insert pnds;
        
        
    }

}