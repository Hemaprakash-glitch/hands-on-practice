SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM countries;

SELECT COUNT(*) FROM complaints;

SELECT COUNT(*) FROM investigations;

=======================================================================
-- Joins - Use a common key to combine information from two or more related tables.

/* INNER JOIN is used to combine rows from two or more tables based on a matching condition. 
It returns only the records that have matching values in both tables.

Problem: Prepare a report showing every complaint along with its corresponding device name. 
This report will be used in today's Quality Review meeting

*/

select 

c.complaint_id,
p.device_name,
c.severity

from complaints c
inner join products p
on c.product_id = p.product_id;

select 

c.complaint_id,
p.device_name,
p.device_family,
c.severity,
c.event_description

from products p 
inner join complaints c 
on p.product_id = c.product_id;

=============================================================================

/* Left Join - LEFT JOIN returns all rows from the left table and the matching rows from the right table. 
If there is no match, the right table columns will contain NULL.

Problem: Before the FDA audit, identify all complaints that have not yet been assigned or completed an investigation. 
These cases require immediate follow-up.

*/

select
c.complaint_id,
c.complaint_date,
c.severity,
i.investigation_status

from complaints c
left join investigations i
on c.complaint_id = i.complaint_id
WHERE i.complaint_id IS NULL;

/* Right Join - RIGHT JOIN returns all rows from the right table and the matching rows from the left table. 
If there is no match, the left table columns will contain NULL.

Problem: Identify investigation records that do not have a matching complaint record. These may indicate data migration or ETL issues.

*/

SELECT
    c.complaint_id,
    i.investigation_id,
    i.investigation_status
FROM complaints c
RIGHT JOIN investigations i
ON c.complaint_id = i.complaint_id
WHERE c.complaint_id IS NULL;

/* Self Join - A SELF JOIN is a join in which a table is joined with itself using table aliases to compare or retrieve related rows from the same table..

Problem: Identify potential duplicate complaints reported for the same product on the same date so that duplicate investigations can be avoided.

*/

SELECT
    c1.complaint_id,
    c2.complaint_id,
    c1.product_id,
    c1.complaint_date
FROM complaints c1
JOIN complaints c2
ON c1.product_id = c2.product_id
AND c1.complaint_date = c2.complaint_date
AND c1.complaint_id <> c2.complaint_id;


/* Multi-Table JOIN - A Multi Table JOIN is the process of joining three or more related tables in a single SQL query 
to retrieve consolidated information from multiple sources.

Problem: Prepare an executive report containing complaint details, associated device information, country, and investigation status. 
This report will be presented during the Monthly Quality Management Review.

*/

SELECT
    c.complaint_id,
    p.device_name,
    co.country,
    c.severity,
    c.status,
    i.investigation_status,
    i.reportable
FROM complaints c
INNER JOIN products p
    ON c.product_id = p.product_id
INNER JOIN countries co
    ON c.country_id = co.country_id
LEFT JOIN investigations i
    ON c.complaint_id = i.complaint_id;



