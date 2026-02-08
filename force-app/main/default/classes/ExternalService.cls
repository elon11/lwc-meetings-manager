public class ExternalService {

    // קריאה ל-API חיצוני לכל הפגישות
    public static Map<Id, String> fetchData(Set<Id> meetingIds) {
        Map<Id, String> resultMap = new Map<Id, String>();

        if (meetingIds == null || meetingIds.isEmpty()) return resultMap;

        for (Id meetingId : meetingIds) {
            try {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://api.example.com/meeting-info?id=' + meetingId);
                req.setMethod('GET');

                HttpResponse res = http.send(req);

                if (res.getStatusCode() == 200) {
                    resultMap.put(meetingId, res.getBody());
                } else {
                    resultMap.put(meetingId, 'שגיאה בנתוני API: ' + res.getStatus());
                }
            } catch (Exception e) {
                resultMap.put(meetingId, 'שגיאה בקריאה ל-API: ' + e.getMessage());
            }
        }

        return resultMap;
        
    }
}
