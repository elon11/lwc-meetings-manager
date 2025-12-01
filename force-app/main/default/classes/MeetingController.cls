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


        /**
     * @Method Name: insertAttendees
     * @input 
     *   meetingId - Id of the Meeting to which attendees should be added.
     *   contactIds - List of Contact Ids to be added as attendees.
     * @Description: 
     *   Static method that adds a list of Contacts as attendees to a specific Meeting.
     *   The method creates new Meeting_Attendee__c records, linking each Contact from
     *   the input list to the given Meeting. Finally, all attendee records are inserted 
     *   into the database.
     * @Behavior:
     *   - The method is annotated with @AuraEnabled, making it accessible from LWC or Aura Components.
     *   - If the contactIds list is empty, no records will be created.
     *   - All attendees are inserted in a single DML operation.
     * @Exceptions:
     *   - If there is an issue inserting records (e.g., validation rules, missing permissions),
     *     a DMLException will be thrown.
     * @Created by Elon Yifrah
     * @Created Date: 01/12/2025
     */
    @AuraEnabled
    public static void insertAttendees(Id meetingId, List<Id> contactIds) {

        List<Meeting_Attendee__c> attendees = new List<Meeting_Attendee__c>();

        for (Id cId : contactIds) {
            attendees.add(new Meeting_Attendee__c(
                Meeting__c = meetingId,
                Contact__c = cId
            ));
        }

        insert attendees;
    }

    
    /**
     * @Method Name: searchContacts
     * @input searchKey - Partial or full name of the contact to search for
     * @Description: Returns a list of Contacts whose Name matches the searchKey (LIKE %searchKey%)
     *              Limited to 50 results, ordered by Name. This method is cacheable to improve performance.
     * @Created by Elon Yifrah
     * @Created Date: 2025-12-01
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name FROM Contact WHERE Name LIKE :key ORDER BY Name LIMIT 50];
    }
}
