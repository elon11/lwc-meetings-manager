public class MeetingEmailQueueable implements Queueable, Database.AllowsCallouts {
    private Set<Id> meetingIds;

    // Constructor - מקבל את ה-IDs של הפגישות
    public MeetingEmailQueueable(Set<Id> meetingIds) {
        this.meetingIds = meetingIds;
    }

    // הפונקציה שמופעלת ברקע
    public void execute(QueueableContext context) {
        if (meetingIds == null || meetingIds.isEmpty()) return;

        // 🔹 קריאה לשירות חיצוני
        Map<Id, String> apiData = ExternalService.fetchData(meetingIds);

        // 🔹 שליחת מיילים עם המידע מה-API
        MeetingEmailService.sendMeetingEmails(meetingIds, apiData);
    }
}
