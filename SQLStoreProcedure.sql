USE booksSQL

--1--
CREATE PROCEDURE MyProcedure1 @themes NVARCHAR(100)
AS
 BEGIN
    SELECT books.Name AS BookName
    FROM books
    WHERE Themes=@themes
    GROUP BY books.Name
    ORDER BY books.Name DESC
 END

 EXEC MyProcedure1 'Операционные системы'

--2--

CREATE PROCEDURE MyProcedure2 
AS
 BEGIN
   SELECT books.Date,COUNT(books.Name) AS BookCount
   FROM books
   WHERE books.Date IS NULL
   GROUP BY books.Date
 END

 EXEC MyProcedure2 

 --3--
 CREATE PROCEDURE MyProcedure3A
AS
 BEGIN
   UPDATE books
	SET books.Date=GETDATE()
	WHERE Date IS NULL
 END

 EXEC MyProcedure3A
--OR--

CREATE PROCEDURE MyProcedure3B
AS
 BEGIN
   DECLARE @date datetime                                      
   SELECT @date=books.Date                                                               
   FROM books
  IF @date IS NULL
   BEGIN
    UPDATE books
	SET books.Date=GETDATE()
	WHERE Date IS NULL
   END
 END
  
  EXEC MyProcedure3B

  
SELECT Date,Name    --for to check--
FROM books

--4--

CREATE PROCEDURE MyProcedure4 @IzdName NVARCHAR(50)
AS
  BEGIN
   UPDATE books
   SET books.Date=DATEADD(YEAR,4,books.Date)
   WHERE Izd=@IzdName
  END

  EXEC MyProcedure4 N'DiaSoft'

SELECT Date,Izd,Name
FROM books                 --for to check--
where Izd='DiaSoft'

--5--
CREATE PROCEDURE MyProcedure5 @PresNumber FLOAT
AS
 BEGIN
   DECLARE @TheirPresNumber FLOAT
   SELECT @TheirPresNumber=books.Pressrun
   FROM books
   IF @PresNumber<@TheirPresNumber
   BEGIN
    UPDATE books
	SET books.Pressrun=15000
	WHERE @PresNumber<@TheirPresNumber
   END
 END

 EXEC MyProcedure5 9000

SELECT Pressrun,Name
FROM books                  --for to check--
WHERE Pressrun>9000

--6--
CREATE PROCEDURE MyProcedure6 
AS
 BEGIN
   DELETE 
   FROM books
   WHERE books.Pages=0
 END

 EXEC MyProcedure6

 SELECT*
 FROM books     --for to check--

 --7--
 CREATE PROCEDURE MyProcedure7 @myyear DATETIME,@myTheme NVARCHAR(100)
 AS
  BEGIN
	 DELETE 
	 FROM books
	 WHERE Themes=@myTheme AND YEAR(Date)<YEAR(@myyear)
  END
                                        
  EXEC MyProcedure7 '2020-01-21',N'Программирование для Интернет'

--OR--
CREATE PROCEDURE MyProcedure7b @myyear DATETIME,@myTheme NVARCHAR(100)
 AS
  BEGIN
     DECLARE @Theiryear DATETIME
	 SELECT  @Theiryear=YEAR(books.Date)
	 FROM books                                                                               
	 IF YEAR(@myyear)<@Theiryear
	 BEGIN
	     DELETE 
		 FROM books
		 WHERE books.Themes=@myTheme and YEAR(@myyear)>@Theiryear
	 END
  END
 DROP PROCEDURE MyProcedure7b
  EXEC MyProcedure7b '2020-01-21',N'Программирование для Интернет'

  SELECT*
  FROM books

  --8--
  CREATE PROCEDURE MyProcedure8
  AS
   BEGIN
        SELECT Izd as Biggest,COUNT(Name) as booksCount
        FROM books
        GROUP BY Izd
        HAVING COUNT(Books.Name) = (SELECT MAX(BookCount)
                                    FROM (SELECT COUNT(Books.Name) AS BookCount                        
                                          FROM books
                                          GROUP BY Izd) AS BookSCount)
   END

EXEC MyProcedure8

  --9--
  CREATE PROCEDURE MyProcedure9
  AS 
    BEGIN
	    SELECT Izd,MAX(Price) as MostExpencive
        FROM books
        WHERE Izd='BHV Киев'
        GROUP BY Izd                       
	END

EXEC MyProcedure9

  --OR--

  CREATE PROCEDURE MyProcedure9B
  AS 
    BEGIN
	    SELECT MAX(Price) as MostExpencive,Name AS BookName,Izd
        FROM books
        WHERE Izd='BHV Киев'
        GROUP BY Name,Izd
		HAVING MAX(Price)=(SELECT MAX(BooksPrice) AS MostExpencive
                           FROM (SELECT MAX(Price) as BooksPrice,Name AS BookName,Izd
                                  FROM books
                                  WHERE Izd='BHV Киев'
                                  GROUP BY Name,Izd) AS BookPrice)
		
	END

	EXEC MyProcedure9B
