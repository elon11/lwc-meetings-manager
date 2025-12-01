trigger MeetingTrigger on Meeting__c (before insert, before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            MeetingTriggerHandler.populateAccount(Trigger.new);
        }
    }
}
