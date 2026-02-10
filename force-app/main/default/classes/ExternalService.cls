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

                // קריאה ל-JSONPlaceholder
                req.setEndpoint('callout:Meeting_API/users');
                req.setTimeout(5000);

                HttpResponse res = http.send(req);

                if (res.getStatusCode() == 200) {

                    // המרה ל-List של Maps
                    List<Object> users =
                        (List<Object>) JSON.deserializeUntyped(res.getBody());

                    String formattedResult = '';

                    for (Object obj : users) {
                        Map<String, Object> user =
                            (Map<String, Object>) obj;

                        String name = (String) user.get('name');
                        String email = (String) user.get('email');

                        formattedResult +=
                            'שם: ' + name + '\n' +
                            'אימייל: ' + email + '\n\n';
                    }

                    resultMap.put(meetingId, formattedResult);

                } else {
                    resultMap.put(
                        meetingId,
                        'שגיאה בנתוני API: ' +
                        res.getStatusCode() + ' - ' + res.getBody()
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
