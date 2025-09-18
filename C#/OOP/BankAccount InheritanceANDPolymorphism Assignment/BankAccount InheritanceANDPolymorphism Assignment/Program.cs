namespace BankAccount_InheritanceANDPolymorphism_Assignment;

internal class Program
{
    static void Main(string[] args)
    {
        BankAccount B1 = new BankAccount();
        BankAccount B2 = new BankAccount("Rana" , "10000000000000" , "01203591585" , "Sirs" , 500);
        BankAccount B3 = new BankAccount("Rana" , "10000333020100" , "01203591585" , "Sirs");
        // Console.WriteLine(B1.ShowAccountDetails());
        // Console.WriteLine(B2.ShowAccountDetails());
        // Console.WriteLine(B3.ShowAccountDetails());
        
        SavingAccount S1 = new SavingAccount(B2);
        // Console.WriteLine(S1.ShowAccountDetails());

        CurrentAccount C1 = new CurrentAccount("Rana", "10000000000000", "01203591585", "Sirs", 500);
        // Console.WriteLine(C1.ShowAccountDetails());



        List<BankAccount> BankAccounts = new List<BankAccount>();
        BankAccounts.Add(C1);
        BankAccounts.Add(S1);
        foreach (BankAccount account in BankAccounts)
        {
            Console.WriteLine(account.ShowAccountDetails());
        }
        // {
        //     new BankAccount("Rana", "10000000000000", "01203591585", "Sirs", 5000),
        //     new BankAccount("Ali",  "10000000000001", "01203591586", "Cairo", 1500),
        //     new BankAccount("Sara", "10000000000002", "01203591587", "Giza", 2500) ,
        //     new BankAccount("Mona", "10000000000005", "01203591590", "Tanta", 2000),
        //     new BankAccount("Nada", "10000000000006", "01203591591", "Luxor", 3500)
        //
        // };
        // BankAccounts.Add(new BankAccount("Laila", "10000000000007", "01203591592", "Aswan", 5000));
        // BankAccounts.Add(new BankAccount("Omar",  "10000000000011", "01203591596", "Alex", 9000));
        // foreach (BankAccount account in BankAccounts)
        // {
        //     Console.WriteLine(account.ShowAccountDetails());
        // }




    }

         

}