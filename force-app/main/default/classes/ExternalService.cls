public class ExternalService {

    // קריאה ל-API חיצוני לכל הפגישות
    public static Map<Id, String> fetchData(Set<Id> meetingIds) {

        Map<Id, String> resultMap = new Map<Id, String>();

        if (meetingIds == null || meetingIds.isEmpty()) {
            return resultMap;
        }

        Http http = new Http();

        for (Id meetingId : meetingIds) {
            try {
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');

                // שימוש ב-Named Credential (בלי דומיין בקוד)
                req.setEndpoint(
                    'callout:Meeting_API/meeting-info?id=' + meetingId
                );

                req.setTimeout(5000);

                HttpResponse res = http.send(req);

                if (res.getStatusCode() == 200) {
                    resultMap.put(meetingId, res.getBody());
                } else {
                    resultMap.put(
                        meetingId,
                        'שגיאה בנתוני API: ' + res.getStatusCode() + ' - ' + res.getBody()
                    );
                }

            } catch (Exception e) {
                resultMap.put(
                    meetingId,
                    'שגיאה בקריאה ל-API: ' + e.getMessage()
                );
            }
        }

        return resultMap;
    }
}
