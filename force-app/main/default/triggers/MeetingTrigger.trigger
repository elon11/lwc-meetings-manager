trigger MeetingTrigger on Meeting__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        MeetingTriggerHandler.afterInsert(Trigger.new);
    }
}
