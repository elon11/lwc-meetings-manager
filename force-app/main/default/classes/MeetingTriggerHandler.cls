public class MeetingTriggerHandler {

    /**
     * @Method Name: populateAccount
     * @input meetings - List of Meeting__c records from Trigger
     * @Description: Populates Account__c on Meeting__c automatically.
     *              If the meeting has a primary Contact (or other logic), it assigns the related Account.
     *              Bulk-safe implementation.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    public static void populateAccount(List<Meeting__c> meetings) {
        Set<Id> contactIds = new Set<Id>();

        // Step 1: Collect Contact Ids from meetings
        for(Meeting__c m : meetings){
            if(m.Primary_Contact__c != null){ // נניח שיש שדה Primary_Contact__c
                contactIds.add(m.Primary_Contact__c);
            }
        }

        // Step 2: Query Accounts of those contacts
        Map<Id, Id> contactToAccountMap = new Map<Id, Id>();
        if(!contactIds.isEmpty()){
            for(Contact c : [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds]){
                contactToAccountMap.put(c.Id, c.AccountId);
            }
        }

        // Step 3: Assign Account__c on meetings
        for(Meeting__c m : meetings){
            if(m.Primary_Contact__c != null && contactToAccountMap.containsKey(m.Primary_Contact__c)){
                m.Account__c = contactToAccountMap.get(m.Primary_Contact__c);
            }
        }
    }
}
