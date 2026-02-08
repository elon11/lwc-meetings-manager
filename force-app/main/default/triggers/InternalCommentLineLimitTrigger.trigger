trigger InternalCommentLineLimitTrigger on Internal_Comment__c (before insert, before update) {
    InternalCommentHelper.adjustBodyLength(Trigger.new);
}
