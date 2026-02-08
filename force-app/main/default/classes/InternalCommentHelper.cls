/**
 * @Class Name: InternalCommentHelper
 * @Description: Helper class for Internal_Comment__c records.
 *               Provides methods to adjust the body length of comments
 *               according to a maximum line length defined in custom metadata.
 * @Created by Elon Yifrah
 */
public class InternalCommentHelper {

     /**
     * @Method Name: adjustBodyLength
     * @Input List<Internal_Comment__c> comments - A list of Internal Comment records to adjust.
     * @Description: Adjusts the Body__c field of each Internal_Comment__c in the list
     *               by wrapping text according to the maximum line length defined
     *               in Internal_Comment_Settings__mdt custom metadata. Defaults to 40 characters if not defined.
     * @Created by Elon Yifrah
     */
    public static void adjustBodyLength(List<Internal_Comment__c> comments) {
        Integer maxLength = 40; 
        try {
            	Internal_Comment_Settings__mdt setting = [
                SELECT Max_Line_Length__c 
                FROM Internal_Comment_Settings__mdt 
                LIMIT 1
            ];
            if(setting != null && setting.Max_Line_Length__c != null) {
                maxLength = Integer.valueOf(setting.Max_Line_Length__c);
            }
        } catch(Exception e) {
          
        }
        
        for(Internal_Comment__c comment : comments) {
            if(comment.Body__c != null) {
                comment.Body__c = wrapText(comment.Body__c, maxLength);
            }
        }
    }

  /**
     * @Method Name: wrapText
     * @Input String text - The text to wrap.
     *        Integer maxLength - The maximum number of characters per line.
     * @Return String - The text wrapped with newline characters according to maxLength.
     * @Description: Splits a string into multiple lines without exceeding maxLength.
     *               Attempts to break at spaces when possible, otherwise breaks at maxLength.
     * @Created by Elon Yifrah
     */
    private static String wrapText(String text, Integer maxLength) {
        List<String> resultLines = new List<String>();
        String[] lines = text.split('\n'); 

        for(String line : lines) {
            while(line.length() > maxLength) {
        
                Integer splitPos = line.lastIndexOf(' ', maxLength);
                if(splitPos <= 0) {
                    splitPos = maxLength; 
                }
                resultLines.add(line.substring(0, splitPos).trim());
                line = line.substring(splitPos).trim();
            }
            resultLines.add(line);
        }
        return String.join(resultLines, '\n');
    }
}
