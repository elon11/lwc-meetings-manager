public class MeetingEmailQueueable implements Queueable, Database.AllowsCallouts {
    private Set<Id> meetingIds;

    // Constructor - מקבל את ה-IDs של הפגישות
    public MeetingEmailQueueable(Set<Id> meetingIds) {
        this.meetingIds = meetingIds;
    }

    // הפונקציה שמופעלת ברקע
    public void execute(QueueableContext context) {
        if (meetingIds == null || meetingIds.isEmpty()) return;

        // קריאה למחלקת המייל הקיימת לשליחת מיילים
        MeetingEmailService.sendMeetingEmails(meetingIds);

        // בעתיד ניתן להוסיף כאן Callouts לשירות חיצוני
    }
}
