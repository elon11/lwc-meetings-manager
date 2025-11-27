/**
 * @Class Name: UserLookupController
 * @Description: 
 *   Apex controller class that provides methods for searching User records 
 *   in Salesforce for use in Lightning Web Components. 
 *   The class is declared as "with sharing" to enforce the user's record sharing rules.
 * 
 * @Created by: Elon Yifrah
 * @Created Date: 27/11/2025
 */
public with sharing class UserLookupController {

    /**
     * @Method Name: searchUsers
     * @Description: 
     *   Searches for User records based on a partial match of the user's Name.
     *   Returns a list of up to 10 users whose Name contains the provided search key.
     *   This method is annotated with @AuraEnabled(cacheable=true) to allow 
     *   Lightning Web Components to call it with caching enabled for better performance.
     *
     * @Input: 
     *   searchKey (String) - the text to search for in User Name.
     *
     * @Return: 
     *   List<User> - a list of User records containing Id and Name fields.
     */
    @AuraEnabled(cacheable=true)
    public static List<User> searchUsers(String searchKey) {
        return [SELECT Id, Name 
                FROM User 
                WHERE Name LIKE :('%'+searchKey+'%') 
                LIMIT 10];
    }
}
