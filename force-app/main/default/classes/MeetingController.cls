/**
 * @Class Name: MeetingController
 * @Description: 
 *   Apex controller class that provides methods to retrieve Meeting__c records
 *   for Lightning Web Components. The class is declared as "with sharing" 
 *   to enforce the user's record sharing rules.
 * 
 * @Created by: Elon Yifrah
 * @Created Date: 27/11/2025
 */
public with sharing class MeetingController {

    /**
     * @Method Name: getMeetings
     * @Description: 
     *   Returns a list of Meeting__c records including the fields Id, Name, 
     *   Meeting_Date__c, and Status__c. The records are ordered by Meeting_Date__c 
     *   in descending order (latest meetings first). 
     *   This method is annotated with @AuraEnabled(cacheable=true) to allow
     *   LWC components to call it with caching enabled.
     *
     * @Input: None
     * @Return: List<Meeting__c> - a list of Meeting__c records
     */
    @AuraEnabled(cacheable=true)
    public static List<Meeting__c> getMeetings() {
        return [SELECT Id, Name, Meeting_Date__c, Status__c 
                FROM Meeting__c 
                ORDER BY Meeting_Date__c DESC];
    }
}
