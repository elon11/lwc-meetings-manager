public class MeetingTriggerHandler {

    public static void afterInsert(List<Meeting__c> meetings) {
        Set<Id> meetingIds = new Set<Id>();
        for (Meeting__c m : meetings) {
            meetingIds.add(m.Id);
        }

        MeetingEmailService.sendMeetingEmails(meetingIds);
    }
}
