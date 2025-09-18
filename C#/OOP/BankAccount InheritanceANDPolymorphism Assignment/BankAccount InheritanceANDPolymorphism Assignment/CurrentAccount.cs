namespace BankAccount_InheritanceANDPolymorphism_Assignment;

internal class CurrentAccount : BankAccount
{

    public decimal  OverdraftLimit  { get; set; }

    public CurrentAccount(string fullName , string nationalID, string phoneNumber,string address, decimal balance) : base(fullName, nationalID, phoneNumber,address , balance)
    {
        this.OverdraftLimit = 10;
    }
    
    public override string ShowAccountDetails()
    {
        return ToString(); 
    }
    
    public override string ToString()
    {
        return $"Bank Code = {BankCode} \n  account Number = {AccountNumber}\n CreatedDate = {CreatedDate} \n Name =  {FullName} \n NationalID = {NationalID} \n Balance = {Balance} \n Phone Number = {PhoneNumber}\n  OverdraftLimit = {OverdraftLimit} \n ===================";
    }

    
        
    
}