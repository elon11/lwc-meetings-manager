public class MeetingEmailService {

    public static void sendMeetingEmails(Set<Id> meetingIds) {

        // 1️⃣ פגישות + יוצר
        Map<Id, Meeting__c> meetingsMap = new Map<Id, Meeting__c>(
            [SELECT Id, Name, CreatedById
             FROM Meeting__c
             WHERE Id IN :meetingIds]
        );

        // 2️⃣ משתתפים (אנשי קשר)
        List<Meeting_Attendee__c> participants = [
            SELECT Meeting__c, Contact__r.Email
            FROM Meeting_Attendee__c
            WHERE Meeting__c IN :meetingIds
            AND Contact__r.Email != null
        ];

        // 3️⃣ מיילים של אנשי קשר לפי פגישה
        Map<Id, Set<String>> meetingToEmails = new Map<Id, Set<String>>();

        for (Meeting_Attendee__c p : participants) {
            if (!meetingToEmails.containsKey(p.Meeting__c)) {
                meetingToEmails.put(p.Meeting__c, new Set<String>());
            }
            meetingToEmails.get(p.Meeting__c).add(p.Contact__r.Email);
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        // 4️⃣ בניית המיילים
        for (Meeting__c meeting : meetingsMap.values()) {

            Set<String> toAddresses = new Set<String>();

            // יוצר הפגישה
            User creator = [
                SELECT Email FROM User WHERE Id = :meeting.CreatedById LIMIT 1
            ];
            if (creator.Email != null) {
                toAddresses.add(creator.Email);
            }

            // משתתפים
            if (meetingToEmails.containsKey(meeting.Id)) {
                toAddresses.addAll(meetingToEmails.get(meeting.Id));
            }

            if (!toAddresses.isEmpty()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(toAddresses));
                mail.setSubject('נוצרה פגישה חדשה: ' + meeting.Name);
                mail.setPlainTextBody(
                    'שלום,\n\n' +
                    'נוצרה פגישה חדשה במערכת.\n' +
                    'שם הפגישה: ' + meeting.Name + '\n\n' +
                    'בברכה,\nמערכת הפגישות'
                );

                emails.add(mail);
            }
        }

        // 5️⃣ שליחה
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}
