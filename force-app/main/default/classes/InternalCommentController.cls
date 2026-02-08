/**
 * @Class Name: InternalCommentController
 * @Description: Controller class for handling Internal Comments related operations.
 *               Provides methods to create internal comments and retrieve information
 *               such as user names and title colors based on account and user data.
 * @Created by Elon Yifrah
 */
public with sharing class InternalCommentController {
    /**
     * @Method Name: createInternalComment
     * @Input Id accountId - The Id of the Account to associate the internal comment with.
     *        String bodyText - The text content of the internal comment.
     * @Description: Creates a new Internal_Comment__c record linked to the specified account.
     *               Throws an exception if the comment text is empty or if there is a DML error during insert.
     * @Created by Elon Yifrah
     */
    @AuraEnabled
    public static void createInternalComment(Id accountId, String bodyText) {
        if(String.isBlank(bodyText)) {
            throw new AuraHandledException('Comment cannot be empty.');
        }

        Internal_Comment__c comment = new Internal_Comment__c();
        comment.Account__c = accountId;
        comment.Body__c = bodyText;

        try {
            insert comment;
        } catch (DmlException e) {
            throw new AuraHandledException('Error creating comment: ' + e.getMessage());
        }
    }

    /**
     * @Method Name: getTitleColor
     * @Input Id accountId - The Id of the Account to check.
     *        String userName - The name of the User to compare with the Account name.
     * @Return String - Returns a color string ("black" or "green") based on whether
     *                  the Account name matches the User name.
     * @Description: Determines the color for the title based on a comparison of Account
     *               and User names. If names match, returns "green"; otherwise, "black".
     * @Created by Elon Yifrah
     */
   @AuraEnabled(cacheable=true)
    public static String getTitleColor(Id accountId, String userName) {
        String color = 'black';

        Account acc = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];

        User u;
        try {
            u = [SELECT Name FROM User WHERE Id = :userName LIMIT 1];
        } catch (Exception e) {
            u = null;
        }

        if(acc != null && u != null && acc.Name == u.Name) {
            color = 'green';
        }

        return color;
    }

       /**
     * @Method Name: getUserNameById
     * @Input Id userId - The Id of the User whose name is to be retrieved.
     * @Return String - The name of the User corresponding to the provided Id.
     * @Description: Retrieves the name of a User given their Salesforce Id.
     *               This method is cacheable for better performance in Lightning components.
     * @Created by Elon Yifrah
     */
    @AuraEnabled(cacheable=true)
    public static String getUserNameById(Id userId) {
        User u = [SELECT Name FROM User WHERE Id = :userId LIMIT 1];
        return u.Name;
    }

     

}
