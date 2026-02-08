public class MeetingTriggerHandler {

    public static void afterInsert(List<Meeting__c> meetings) {
        if (meetings == null || meetings.isEmpty()) {
            return;
        }

        // אוסף את כל ה-IDs של הפגישות
        Set<Id> meetingIds = new Set<Id>();
        for (Meeting__c m : meetings) {
            meetingIds.add(m.Id);
        }

        // שליחת מיילים אסינכרונית דרך Queueable
        System.enqueueJob(new MeetingEmailQueueable(meetingIds));
    }
}
