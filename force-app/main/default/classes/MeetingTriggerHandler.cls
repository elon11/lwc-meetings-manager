public class MeetingTriggerHandler {
    /**
     * Populates Account__c on Meeting__c automatically with OwnerId.
     */
    public static void populateAccount(List<Meeting__c> meetings) {
        for(Meeting__c m : meetings){
            if(m.OwnerId != null){
                m.Account__c = m.OwnerId;
            }
        }
    }
}
