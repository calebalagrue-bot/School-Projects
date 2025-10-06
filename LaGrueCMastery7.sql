
/*1. Write a script that creates and calls a stored procedure named spAddCategory. First, code a statement that creates a procedure that adds a new row to the Categories table. To do that, this procedure should have one parameter for the category name.
      Code at least two EXEC statements that test this procedure. (Note that this table doesn’t allow duplicate category names.)*/
Create Procedure clagruesp252333.sp_AddCategory (@CategoryName VARCHAR(100)) As
Begin Insert Into clagruesp252333.categories (CategoryName)
Values (@CategoryName);
End;
GO

Exec clagruesp252333.sp_AddCategory 'Electronics';
Exec clagruesp252333.sp_AddCategory 'Clothing';

/*2. Write a script that creates and calls a function named fnCategoryCount return the number of Products as ProductCount in the product table that match a category name. To do that, this function should accept one parameter for the category name. You can use the category name to match the CategoryID in the Products table to count the items.
      The SELECT statement that calls the function passing it ‘Guitars’.*/

Create Function clagruesp252333.fn_CategoryCount (@CategoryName VARCHAR(100))
Returns Int As
Begin
Declare @ProductCount Int;
Select @ProductCount = Count(*)
From clagruesp252333.products p Join clagruesp252333.categories c on p.categoryid = c.categoryid
Where c.categoryname = @CategoryName;
Return @ProductCount;
End;
GO

Select clagruesp252333.fn_CategoryCount('Guitars');


/*3. Write a script that creates and calls a function named fnCustomerTotal that calculates the total order purchases of a customer in the Orders and OrderItems table. To do that, this function should accept one parameter for the Customer ID, and it should return the sum of the item prices ordered by the Customer.  The function should return the CustomerID and calculated sum.
Write two SELECT statements that call the function with customer numbers 1 and 3.*/

Create Function clagruesp252333.fn_CustomerTotal (@CustomerID INT)
Returns DECIMAL(18,2) As
Begin
Declare @Total DECIMAL(18,2);

Select @Total = Sum(oi.quantity * p.listprice)
From clagruesp252333.orders o Join clagruesp252333.orderitems oi on o.orderid = oi.orderid Join clagruesp252333.products p on oi.productid = p.productid
Where o.customerid = @CustomerID;

Return @Total;
End;
GO

Select clagruesp252333.fn_CustomerTotal(1);
Select clagruesp252333.fn_CustomerTotal(3);


/*4. Write a script that creates and calls a stored procedure named spInsertCustomer that inserts a row into the Customers table. This stored procedure should accept one parameter for each of these columns: EmailAddress, Password, LastName, FirstName.
      This stored procedure should set the Billing and Shipping addresses to NULL.
      Code at least two EXEC statements that test this procedure.*/

Create Procedure clagruesp252333.sp_InsertCustomer (@EmailAddress VARCHAR(100), @Password VARCHAR(100), @LastName VARCHAR(50), @FirstName VARCHAR(50))
As
Begin
Insert Into clagruesp252333.customers (EmailAddress, Password, LastName, FirstName, BillingAddressID, ShippingAddressID)
Values (@EmailAddress, @Password, @LastName, @FirstName, NULL, NULL);
End;
GO


Exec clagruesp252333.sp_InsertCustomer 'StephCurry30@gmail.com', 'ShephCurry30', 'Steph', 'Curry';
Exec clagruesp252333.sp_InsertCustomer 'GoatJames@gmail.com.com', 'GoatJames13', 'LeBron', 'James';


/*5. Write a script that creates and calls a stored procedure named spSetPrice that updates the ListPrice column in the Products table. This procedure should have one parameter for the product ID and another for the new price.
      If the value for the ListPrice column is a negative number, the stored procedure should raise an error that indicates that the value for this column must be a positive number.
      Code at least two EXEC statements that test this procedure.*/

-
IF OBJECT_ID('clagruesp252333.sp_SetPrice', 'P') IS NOT NULL
DROP PROCEDURE clagruesp252333.sp_SetPrice;
GO

Create Procedure clagruesp252333.sp_SetPrice (@ProductID INT, @NewPrice DECIMAL(18,2))
As
Begin
If @NewPrice < 0
Begin
Print 'The ListPrice cannot be negative. Setting price to default value of 10.00.';
Set @NewPrice = 10.00;
End;
Update clagruesp252333.products
Set listprice = @NewPrice
Where productid = @ProductID;
End;
GO


Exec clagruesp252333.sp_SetPrice 101, 15.99; 
Exec clagruesp252333.sp_SetPrice 102, -5.00;  

/*6. Create a trigger named Products_UPDATE that checks the new value for the ListPrice column of the Products table. This trigger should raise an appropriate error if the value is negative, and Rollback the operation.
      Test this trigger by running the EXEC for problem 5 and passing a negative number*/

Create Trigger clagruesp252333.Products_UPDATE
On clagruesp252333.products
For Update
As
Begin
If (Select listprice From inserted) < 0
Begin
RAISERROR ('The ListPrice cannot be negative.', 16, 1);
Rollback Transaction;
End;
End;
GO


Exec clagruesp252333.sp_SetPrice 101, -5.00;


/*7. Create a trigger named Products_INSERT that inserts the current date for the DataAdded column of the Products table if the value for that column is null.
      Test this trigger with an appropriate INSERT statement.*/

Create Trigger clagruesp252333.Products_INSERT
On clagruesp252333.products
For Insert
As
Begin
    -- If the DataAdded column is NULL, set it to the current date
    Update clagruesp252333.products
    Set DateAdded = GETDATE()
    Where DateAdded IS NULL;
End;
GO

INSERT INTO clagruesp252333.products (ProductName, CategoryID, ListPrice, DateAdded)
VALUES ('Basketball', 5, 100.00, NULL);

 

/*8. Write a script that includes SQL statements coded as a transaction to delete the row with a CustomerID of 100 from the Customers table. To do this, you must first delete all Addresses for that Customer from the Addresses table.
      If these statements execute successfully, commit the changes. Otherwise, roll back the changes.*/

Begin Transaction;
Begin Try
Delete From clagruesp252333.addresses
Where customerid = 100;
Delete From clagruesp252333.customers
Where customerid = 100;

Commit Transaction; 
End Try
Begin Catch
Rollback Transaction;
Print 'An error occurred, and the transaction has been rolled back.';
End Catch;


/*9. Write the statement to delete the Stored procedure from Problem 1*/
 
Drop Procedure clagruesp252333.sp_AddCategory;


/*10. Write the statement to delete the trigger from problem 6.*/

Drop Trigger clagruesp252333.Products_UPDATE;
