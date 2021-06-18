global class lwcvfController {
    
    public string lexOrigin {get{ 
        return URL.getOrgDomainUrl().toExternalForm().split('.my.')[0]+'.lightning.force.com';
    } set;}
    
    @AuraEnabled(cacheable=true)
    public static string getVFOrigin() {
        string vfOrigin = '';
        string baseURL = URL.getOrgDomainUrl().toExternalForm(); 
        vfOrigin = baseURL.split('.my.')[0] + '--c.' + 'visualforce.com';
        return vfOrigin;
    }
    
    @RemoteAction
    global static String getAccounts(String random){
        System.debug(random);
        map<id,Account> mapAcc=new Map<ID, Account>([select id,name from Account]);
        list<id> lid = new list<id>();
        lid.addAll(mapAcc.keySet());
        System.debug(lid.size());
        String ids = String.join(lid, ',');
        return ids;
    }
    @AuraEnabled 
    public static responseWrapper queryAccount(String ids){
        List<Id> lstAccIds = getIDfromAccountString (ids);
        System.debug('lstAccIds.Size'+lstAccIds.Size());
        List<List<Id>> partionLists = (List<List<Id>>)doPartition(lstAccIds,500, List<List<Id>>.class);
        List<Id> leftId=new List<Id>();
        Boolean isIdsLeft=false;
        lstAccIds=partionLists[0];
        for(integer i=1;i<partionLists.size();i++){
            leftId.addAll(partionLists[i]);
        }
        if(leftId.Size()>0){
            isIdsLeft=true;
        }
        list<Account> lstAccounts=[select id, name,AccountSource,Rating from Account where id in :lstAccIds ];
        responseWrapper res=new responseWrapper();
        res.currentAccount=lstAccounts;
        if(isIdsLeft){
            res.isAccLeft=True;
            res.leftAccids = String.join(leftId, ',');
            
        }
        
        return res;
        
    }
    public static List<Id> getIDfromAccountString (String strAccIds) {
        Integer intDiv = (Integer)Math.ceil(strAccIds.length()/190000);
        intDiv = intDiv + 1;
        Integer intMinLimit = 0;
        Integer intMaxLimit = 0;
        List<ID> lstAc = new List<ID>();
        List<ID> lstAccIds = new List<Id>();
        for (Integer i=0; i < intDiv; i++) {
            intMinLimit = i * 190000;
            intMaxLimit = intMinLimit + 190000;
            if (strAccIds.length() > intMinLimit && strAccIds.length() <= intMaxLimit) {
                String str1 = strAccIds.substring(intMinLimit);
                lstAc = (List<Id>) str1.split(',');
                system.debug('lstAccIds :: ' + lstAc.size());
                lstAccIds.addAll(lstAc);
            }
            else if (strAccIds.length() > intMinLimit && strAccIds.length() > intMaxLimit) {
                String str1 = strAccIds.substring(intMinLimit,intMaxLimit);
                system.debug('str1 :: ' + str1);
                lstAc = (List<Id>) str1.split(',');
                system.debug('lstAccIds :: ' + lstAc.size());
                lstAccIds.addAll(lstAc);
            }
        }
        return lstAccIds;
    }
     public static List<List<Object>> doPartition(List<Object> items, Integer splitSize, Type destType){
            List<List<Object>> result = (List<List<Object>>)destType.newInstance();
            List<Object> protoList = items.clone();
            protoList.clear();
            List<Object> tempList = protoList.clone();
            Integer index = 0, count = 0, size = items.size();
            while(index < size) {
                tempList.add(items.get(index++));
                ++count;
                if(count == splitSize) {
                    result.add(tempList);
                    tempList = protoList.clone();
                    count = 0;
                }
            }
            if(!tempList.isEmpty()) {
                result.add(tempList);
            }
            return result;
        }
    Public class responseWrapper{
        @AuraEnabled public List<Account> currentAccount {get;set;}
         @AuraEnabled public String leftAccids {get;set;}
         @AuraEnabled public Boolean isAccLeft {get;set;}
    }
    
}