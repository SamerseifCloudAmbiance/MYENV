public class AccountsController {
    @AuraEnabled
    public static list<account> getAccounts(){
        return [Select Id,name, type, numberOfEmployees, TickerSymbol, Phone
               	FROM Account
                ORDER BY createdDate ASC];
    }
}