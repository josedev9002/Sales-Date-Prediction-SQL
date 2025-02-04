CREATE FUNCTION Sales.GetNextOrderDate()
RETURNS TABLE
AS
RETURN
(
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
    GROUP BY CustomerName
);

