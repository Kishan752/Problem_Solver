public with sharing class ServiceDMLController {
    
    
    @AuraEnabled
    public static string makeServiceCall(String pincode){
        System.enqueueJob(new PincodeService(pincode));
        return 'Success';
        
    }
}