BankSys bank1 = new BankSys();
BankSys bank2 = new BankSys("Mohammad Said", "30215671731589", "01274904587", "Cairo", 10000); 
bank1.ShowAccountDetails();
bank2.ShowAccountDetails();


class BankSys
{
    public const string BankCode = "BNK001";  
    public readonly DateTime createdDate;
    private int accountNumber;
    private string fullName;
    private string nationalID ;
    private string phoneNumber;
    private string address;
    private decimal balance;

    public string FullName
    {
        get{return fullName;}
        set
        {
            if (string.IsNullOrEmpty(value))
            {
                Console.WriteLine("Nulls and empty full names rejected");
            }
            else fullName = value;
        }
    }
    public string NationalID
    {
        get{return nationalID;}
        set
        {
            if (value.Length != 14)
            {
                Console.WriteLine("ID must contain 14 digits exactly");
            }
            else nationalID = value;
        }
    }
    public string PhoneNumber
    {
        get{return phoneNumber;}
        set
        {
            if (value.Length != 11 || (value[0] != '0' || value[1] != '1') )
            {
                Console.WriteLine("phone number must contain 11 digits exactly and start with 01");
            }
            else phoneNumber = value;
        }
    }
    public string Address
    {
        get{return address;}
        set
        { 
            address = value;
        }
    }
    public decimal Balance
    {
        get{return balance;}
        set
        {
            if (value < 0) 
            {
                Console.WriteLine("balance must be positive");
            }
            else balance = value;
        }
    }
    // Create constructors
    public BankSys()
    {
        FullName = "Esmaiel";
        NationalID = "01234567891234";
        PhoneNumber = "01203591585";
        Address = "Sers";
        Balance = 20000;
        createdDate = DateTime.Now;
    }

    public BankSys(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
    {
        FullName = fullName;
        NationalID = nationalID;
        PhoneNumber = phoneNumber;
        Address = address;
        Balance = balance;
        createdDate = DateTime.Now;
    }
    public BankSys(string fullName, string nationalID, string phoneNumber, string address)
    {
        FullName = fullName;
        NationalID = nationalID;
        PhoneNumber = phoneNumber;
        Address = address;
        Balance = 0;
        createdDate = DateTime.Now;
        return;
    }
    // methods
    public void ShowAccountDetails()
    {
        Console.WriteLine("The details of the account as Follow  ");
        Console.WriteLine($"Full Name: {FullName}");
        Console.WriteLine($"National ID: {NationalID}");
        Console.WriteLine($"Phone Number: {PhoneNumber}");
        Console.WriteLine($"Address: {Address}");
        Console.WriteLine($"Balance: {Balance}");
        Console.WriteLine($"Bank Code: {BankCode}");
        Console.WriteLine($"Created Date: {createdDate}");
    }

    public bool  IsValidNationalID()
    {
        return nationalID.Length == 14;
    }

    public bool IsValidPhoneNumber()
    {
        return (phoneNumber.Length ==11 && phoneNumber[0] != '0' && phoneNumber[1] != '1');
    }

    
  

}

