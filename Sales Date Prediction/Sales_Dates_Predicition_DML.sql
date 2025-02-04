-- 1. Predecir la fecha de la próxima orden por cliente 
WITH OrderIntervals AS (
    SELECT 
        o.custid,
        c.CompanyName AS CustomerName,
        o.OrderDate,
        LEAD(o.OrderDate) OVER (PARTITION BY o.custid ORDER BY o.OrderDate) AS NextOrderDate
    FROM Sales.Orders o
    JOIN Sales.Customers c ON o.custid = c.custid
)

SELECT 
    CustomerName,
    MAX(OrderDate) AS LastOrderDate,
    DATEADD(DAY, AVG(DATEDIFF(DAY, OrderDate, NextOrderDate)), MAX(OrderDate)) AS NextPredictedOrder
FROM OrderIntervals
WHERE NextOrderDate IS NOT NULL
GROUP BY CustomerName;

-- 2. Obtener las órdenes de un cliente 
SELECT OrderID, RequiredDate, ShippedDate, ShipName, ShipAddress, ShipCity 
FROM Sales.Orders 
WHERE custid = @CustomerID;--Parametro ID para consulta

-- 3. Obtener todos los empleados 
SELECT EmpID, CONCAT(FirstName, ' ', LastName) AS FullName 
FROM HR.Employees;

-- 4. Obtener todos los Shippers 
SELECT ShipperID, CompanyName 
FROM Sales.Shippers;

-- 5. Obtener todos los productos 
SELECT ProductID, ProductName 
FROM Production.Products;

--6. Insertar una nueva orden con su detalle 
DECLARE @NewOrderID INT;

INSERT INTO Sales.Orders (CustomerID, EmpID, OrderDate, RequiredDate, ShippedDate, ShipName, ShipAddress, ShipCity, Freight, ShipCountry, ShipperID)
VALUES (@CustomerID, @EmpID, GETDATE(), @RequiredDate, @ShippedDate, @ShipName, @ShipAddress, @ShipCity, @Freight, @ShipCountry, @ShipperID);

SET @NewOrderID = SCOPE_IDENTITY();

INSERT INTO Sales.OrderDetails (OrderID, ProductID, UnitPrice, Qty, Discount)
VALUES (@NewOrderID, @ProductID, @UnitPrice, @Qty, @Discount);

SELECT @NewOrderID AS NewOrderID;



