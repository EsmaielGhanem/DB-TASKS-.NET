using System.Numerics;

namespace BankAccount_InheritanceANDPolymorphism_Assignment;

internal class SavingAccount : BankAccount
{
    public decimal InterestRate  { get; set; }

    public SavingAccount (string fullName , string nationalID, string phoneNumber,string address, decimal balance) : base(fullName, nationalID, phoneNumber,address , balance)

    {
            InterestRate = 9;
    }

    public SavingAccount(BankAccount bankAccount) : base(bankAccount)
    {
        InterestRate = 9;
    }

    public override string ShowAccountDetails()
    {
        return ToString(); 
    }
    
    public override string ToString()
    {
        return $"Bank Code = {BankCode} \n  account Number = {AccountNumber}\n CreatedDate = {CreatedDate} \n Name =  {FullName} \n NationalID = {NationalID} \n Balance = {Balance} \n Phone Number = {PhoneNumber}\n InterestRate = {InterestRate} \n ===================";
    }
}