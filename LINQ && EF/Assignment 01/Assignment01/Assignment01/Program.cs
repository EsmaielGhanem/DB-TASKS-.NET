namespace Assignment01 ;

class Program
{
    static void Main(string[] args)
    {

        // 1. Find All Available Books#
        // Write a LINQ query to find all books that are currently available. 
        
        var Result01 = LibraryData.Books.Where(B => B.IsAvailable == true); // Fluent Sytax
        Result01 = from B in LibraryData.Books     // Query Syntax
            where B.IsAvailable == true
            select B;
        Result01.ToConsoleTable();


        // --------------------------------------------------------

        // 2. Get All Book Titles#
        // Write a LINQ query to get a list of all book titles.
        // Using Fluent Syntax
        var Result02 = LibraryData.Books.Select(B => new        
        { 
            Title = B.Title
        });
        
        // Using Query Syntax
        Result02 = from B in LibraryData.Books
            select new
            {
                Title = B.Title 
            };
        Result02.ToConsoleTable();
        


        // ------------------------------------------------------------

        // 3. Find Books by Genre#
        // Write a LINQ query to find all books in the "Programming" genre.
        
        // Using Fluent Syntax
        
        var Result03 = LibraryData.Books.Where(B => B.Genre == "Programming");
        
        // Using Query Syntax

        Result03 = from B in LibraryData.Books
            where B.Genre == "Programming"
            select B;
        Result03.ToConsoleTable();


        // ------------------------------------------------------------ 
        // 4. Sort Books by Title#
        // Write a LINQ query to sort all books alphabetically by title. 
        
        // Using Fluent Syntax 
         var Result04 = LibraryData.Books.OrderBy(B => B.Title);
        
        // Using Query Syntax
         Result04 = from B in LibraryData.Books
             orderby B.Title
             select B;
         Result04.ToConsoleTable( );
        
        // ------------------------------------------------------------
        
        // 5. Find Expensive Books#
        // Write a LINQ query to find all books that cost more than $30.

        var Result05 = LibraryData.Books.Where(B => B.Price > 30);
        
        // Using Query Syntax 
        Result05 = from B in LibraryData.Books
            where B.Price > 30
            select B;
        Result05.ToConsoleTable();
        
        // ----------------------------------------------------------
        // 6. Get Unique Genres#
        // Write a LINQ query to get a list of all unique genres in the library.
        
        // Using Fluent Syntax

        var Result06 = LibraryData.Books.Select(B => new
        {
            Genre = B.Genre
        }).Distinct();
        
        // Using Query Syntax 
        Result06 = (from book in LibraryData.Books
            select new
        {
            Genre = book.Genre
        }).Distinct();
            
        Result06.ToConsoleTable();


        // --------------------------------------------------------

        // 7. Count Books by Genre#
        // Write a LINQ query to count how many books are in each genre.
        
        // Using Fluent Syntax 
        var Result07 = LibraryData.Books.GroupBy(B => B.Genre).Select(G => new
        {
            GName = G.Key, 
            count = G.Count() 
        });
        
        // Using Query Syntax 

         Result07 = from B in LibraryData.Books
            group B by B.Genre
            into grouped
            select new
            {
                GName = grouped.Key,
                count = grouped.Count()
            };
              
        
        Result07.ToConsoleTable();
        
        // --------------------------------------------------------
        
        
    //     8. Find Recent Books#
    //     Write a LINQ query to find all books published after 2010.
    
    // Using Fluent Syntax
    var Result08 = LibraryData.Books.Where(B => B.PublishedYear > 2010);
    
    // Using Query Syntax
    Result08 = from B in LibraryData.Books
        where B.PublishedYear > 2010
        select B;
    Result08.ToConsoleTable(); 
    
    
    // ---------------------------------------------------------
    // 9. Get First 5 Books#
    // Write a LINQ query to get the first 5 books from the collection.
    
    
    // Using Fluent Syntax
    var Result09 = LibraryData.Books.Take(5); 
    
    //Using Query Syntax
    Result09 = (from B in LibraryData.Books
        select B).Take(5);
    Result09.ToConsoleTable();
       
    
    // ------------------------------------------------------------
    // 10. Check if Any Expensive Books Exist#
    // Write a LINQ query to check if there are any books priced over $50.
    
    
    // Using Fluent Syntax 

    var Result10 = LibraryData.Books.Any(B => B.Price > 50); 
    
    // Using Query Syntax
    Result10 = (from B in LibraryData.Books
        where B.Price > 50
        select B).Any(); 
    
    
    // -----------------------------------------------
    // 11. Books with Author Information#
    // Write a LINQ query to join books with their authors and return book title, author name, and genre.
    //

    
    
    
    // Using Fluent Syntax 
    var Result11 = LibraryData.Authors.Join(
    
        LibraryData.Books,
        A => A.Id,
        B => B.AuthorId,
        (A, B) => new
        {
           Title =  B.Title , 
            Name = A.Name , 
            Genre = B.Genre
        }
    
    );
    
    // Using Query Syntax
    

    Result11 = from A in LibraryData.Authors
        join B in LibraryData.Books
            on A.Id equals B.AuthorId
        select new
        {
            Title = B.Title,
            Name = A.Name,
            Genre = B.Genre
        };
        
    Result11.ToConsoleTable(); 
    
    
    // --------------------------------------------------------------
    // 12. Average Price by Genre#
    // Write a LINQ query to calculate the average price of books for each genre.

    var Result12 = LibraryData.Books.GroupBy(B => B.Genre).Select(G => new
    {
        Genre = G.Key,
        AVG = G.Average(B => B.Price)
    });
    Result12 = from B in LibraryData.Books
        group B by B.Genre
        into G
        select new
        {
            Genre = G.Key,
            AVG = G.Average(B => B.Price)
        };
    
    Result12.ToConsoleTable();


    
    // -------------------------------------------
    // 13. Most Expensive Book#
    // Write a LINQ query to find the most expensive book in the library.

    var Result13 = LibraryData.Books.OrderBy(B => B.Price).TakeLast(1);
    Result13 = (from B in LibraryData.Books
        orderby B.Price
        select B).TakeLast(1);
    Result13.ToConsoleTable();
    
    // -------------------------------------
    // 14. Group Books by Published Decade#
    // Write a LINQ query to group books by the decade they were published (1990s, 2000s, 2010s, etc.).

    
    // Using Fluent Syntax
    var Result14 = LibraryData.Books.GroupBy(B => ((B.PublishedYear / 10) * 10)).Select(D => new
    {
        Decade = D.Key,
        books = D.ToList()
    
    });
    
    // Using Query Syntax 
    Result14 = from B in LibraryData.Books
        group B by ((B.PublishedYear / 10) * 10)
        into D
        select new
        {
            Decade = D.Key,
            books = D.ToList()
    
        };



    foreach (var Item in Result14)
    {
        Console.WriteLine(Item.Decade);
        foreach (var book in Item.books)
        {
            Console.WriteLine(book.Title);
        }
    
        Console.WriteLine("--------------------------------");
    }
    Result14.ToConsoleTable();

    // -----------------------------------------------------


    // 15. Members with Active Loans#
    // Write a LINQ query to find all members who have active loans (books not yet returned).
    
    // Using Fluent Syntax 
    var Result15 = LibraryData.Loans.Where(L => L.ReturnDate == null);
    // Using Query Syntax 
    Result15 = from L in LibraryData.Loans
        where L.ReturnDate == null
        select L;
    
    Result15.ToConsoleTable();
    
    // -------------------------------------------------
    // 16. Books Borrowed More Than Once#
    // Write a LINQ query to find books that have been borrowed more than once.
    
    // Using Fluent Syntax
        var loanedBookIds = LibraryData.Loans.GroupBy(L => L.BookId)
            .Where(C => C.Count() > 1).Select(G => G.Key);
        
        var Result16 = LibraryData.Books.Where(B => loanedBookIds.Contains(B.Id));
        Result16.ToConsoleTable();
        


    // -----------------------------------------------------

    // 17. Overdue Books#
    // Write a LINQ query to find all overdue books (books with due dates in the past that haven't been returned).
    
    var Result17 =
        from l in LibraryData.Loans
        where l.DueDate < DateTime.Now && l.ReturnDate == null
        join b in LibraryData.Books on l.BookId equals b.Id
        select new 
        {
            b.Title,
            l.DueDate
        };
    Result17.ToConsoleTable();
    

    // -------------------------------------------

    // 18. Author Book Counts#
    // Write a LINQ query to find how many books each author has written, sorted by book count descending.
    
    var Results18 =
       
        from a in LibraryData.Authors
        join b in LibraryData.Books
            on a.Id equals b.AuthorId
        group b by new { a.Id, a.Name } into g
        orderby g.Count() descending
        select new
        {
            AuthorId = g.Key.Id,
            AuthorName = g.Key.Name,
            BookCount = g.Count()
        };
    
    Results18.ToConsoleTable();

    // ---------------------------------------------------
    // 19. Price Range Analysis#
    // Write a LINQ query to categorize books into price ranges (Cheap: $20, Medium: $20-$40, Expensive: $40) and count books in each range.
    //

    var Result19 =
        from b in LibraryData.Books
        let range = 
            b.Price < 20 ? "Cheap" :
            b.Price <= 40 ? "Medium" :
            "Expensive"
        group b by range into g
        select new 
        {
            PriceRange = g.Key,
            Count = g.Count()
        };

    
    // Result19.ToConsoleTable();

    // --------------------------------------
        // 20. Member Loan Statistics#
        // Write a LINQ query to calculate loan statistics for each member: total loans, active loans, and average days borrowed.


        var Result20 =
            from m in LibraryData.Members
            join l in LibraryData.Loans
                on m.Id equals l.MemberId into memberLoans
            select new
            {
                MemberName = m.FullName,
                TotalLoans = memberLoans.Count(),
                ActiveLoans = memberLoans.Count(x => x.ReturnDate == null),
                AverageDaysBorrowed = memberLoans
                    .Where(x => x.ReturnDate != null)
                    .Average(x => (x.ReturnDate.Value - x.LoanDate).TotalDays)
            };
        
        Result20.ToConsoleTable();




    }
    
}