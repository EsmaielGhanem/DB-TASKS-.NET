namespace BankAccount_InheritanceANDPolymorphism_Assignment;

internal class BankAccount
{
    #region Atrributes [Member Value] 

    public static string BankCode = "BNK001";
    readonly DateTime createdDate;
    private int _accountNumber;
    private string _fullName;
    private string _nationalID;
    private string _phoneNumber;

    private decimal balance;
    

    #endregion


    #region Properties 
    public string Address { get; set; } // auto prop


    public int AccountNumber
    {
        get
        {
            return _accountNumber; 
        }
        set
        {
            _accountNumber = value;
        }
    }

    public string FullName
    {
        get
        {
            return _fullName;
        }
        set
        {
            if (string.IsNullOrEmpty(value))
            {
                throw new ArgumentException("FullName must not be null or empty.");
            }
            else _fullName = value;
        }
    }

    public string NationalID
    {
        get
        {
            return _nationalID;
        }
        set
        {
            if (value.Length != 14)
            {
                throw new ArgumentException("NationalID must have exactly 14 characters.");
            }
            else _nationalID = value;
        }
    }

    public string PhoneNumber
    {
        get
        {
            return _phoneNumber;
        }
        set
        {

            if (value.Length != 11 &&
                value[0] != '0' && value[1] != '1')
            {
                throw new ArgumentException("PhoneNumber must have exactly 11 characters and start with 01");
                
            }
            else _phoneNumber = value;
            
        }
    }

    public decimal Balance
    {
        get
        {
            return balance;
        }
        set
        {
            if (value < 0)
            {
                throw new ArgumentException("Balance must not be negative.");
            }
            else balance = value;
        }
    }

    public DateTime CreatedDate
    {
        get
        {
            return createdDate;
        }
    }
    

    #endregion


    #region Constructors

    public BankAccount()
    {
        
    }

    public BankAccount(BankAccount bankAccount)
    {
        this._accountNumber = bankAccount.AccountNumber;
        this._fullName = bankAccount.FullName;
        this._nationalID = bankAccount.NationalID;
        this._phoneNumber = bankAccount.PhoneNumber;
        this.balance = bankAccount.Balance;
        
    }
    public BankAccount(string fullName , string nationalID, string phoneNumber,string address, decimal balance)
    {
        this.FullName = fullName;
        this.NationalID = nationalID;
        this.PhoneNumber = phoneNumber;
        this.Address = address;
        this.Balance = balance;
        this.createdDate = DateTime.Now;
    }
    public BankAccount(string fullName , string nationalID, string phoneNumber,string address)
    {
        this.FullName = fullName;
        this.NationalID = nationalID;
        this.PhoneNumber = phoneNumber;
        this.Address = address;
       this.createdDate = DateTime.Now;

        this.Balance = 0;
    }

    #endregion

    public virtual string ShowAccountDetails()
    {
        return ToString();
    }

    public bool IsValidNationalID()
    {
        if (NationalID.Length != 14)
        {
            return false;
        }
        return true;
    }

    public bool IsValidPhoneNumber()
    {
        if (PhoneNumber.Length != 11 || PhoneNumber[0] != '0' || PhoneNumber[1] != '1') return false;
        return true;
    }
    public override string ToString()
    {
        return $"Bank Code = {BankCode} \n  account Number = {_accountNumber}\n CreatedDate = {CreatedDate} \n Name =  {_fullName} \n NationalID = {_nationalID} \n Balance = {Balance} \n Phone Number = {_phoneNumber}\n ===================";
    }
}