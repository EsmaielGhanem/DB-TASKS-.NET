namespace Task01;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Hello!\nInput the first number: ");
        int a = int.Parse(Console.ReadLine());
        Console.WriteLine("Input the second number : ");
        int b = int.Parse(Console.ReadLine());
        string input = Console.ReadLine();        
        char operation = input[0];
        int ans = 0;
        if (operation == 'A')
        {
            ans = a + b;
        }
        else if (operation == 'S')
        {
            ans = a - b; 
        }
        else if(operation == 'M')ans = a * b ;

        Console.WriteLine(ans);

    }
}