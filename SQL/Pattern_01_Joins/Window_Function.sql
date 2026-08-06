/* Window Functions - Without reducing the number of rows, each row-ku additional calculation perform pannuradhu.

ROW_NUMBER() - ROW_NUMBER() is a window function that assigns a unique sequential number to each row in the result set based on the specified ORDER BY clause.

Problem - Generate a serial number for complaints ordered by complaint date. This report will be used during the weekly complaint review meeting.

*/

SELECT
    complaint_id,
    complaint_date,
    severity,
    ROW_NUMBER() OVER (ORDER BY complaint_date) AS complaint_number
FROM complaints;

--For every product, identify the first complaint that was reported.

SELECT
    complaint_id,
    product_id,
    complaint_date,
    ROW_NUMBER() OVER
    (
        PARTITION BY product_id
        ORDER BY complaint_date
    ) AS complaint_rank
FROM complaints;


/* RANK() - RANK() is a window function that assigns a rank to each row based on the ORDER BY clause. 
Rows with the same value receive the same rank, and the next rank is skipped.

Rank products based on the number of complaints received. Products with the same complaint count should receive the same rank

*/

SELECT
    product_id,
    COUNT(*) AS total_complaints,
    RANK() OVER
    (
        ORDER BY COUNT(*) DESC
    ) AS product_rank
FROM complaints
GROUP BY product_id;


/* Dense Rank - DENSE_RANK() is a window function that assigns the same rank to rows with equal values, but unlike RANK(), it does not skip the next rank.

Prepare a product ranking report without skipping rank numbers when multiple products have the same complaint count.

*/

SELECT
    product_id,
    COUNT(*) AS total_complaints,
    DENSE_RANK() OVER
    (
        ORDER BY COUNT(*) DESC
    ) AS product_rank
FROM complaints
GROUP BY product_id;


/* Lead() - LEAD() is used to access the value from the next row without using a self join.

Compare each complaint with the next complaint reported for the same product to analyze complaint arrival patterns

*/

SELECT
    complaint_id,
    product_id,
    complaint_date,
    LEAD(complaint_date)
    OVER
    (
        PARTITION BY product_id
        ORDER BY complaint_date
    ) AS next_complaint_date
FROM complaints;

--Compare current investigation open date with the next investigation opened for the same device.

SELECT
    complaint_id,
    open_date,
    LEAD(open_date)
    OVER
    (
        ORDER BY open_date
    ) AS next_open_date
FROM investigations;

/* LAG() - LAG() is a window function that returns the value from the previous row without using a self join.

Compare each complaint with the next complaint reported for the same product to analyze complaint arrival patterns

*/

SELECT
    complaint_id,
    product_id,
    complaint_date,
    LAG(complaint_date)
    OVER
    (
        PARTITION BY product_id
        ORDER BY complaint_date
    ) AS previous_complaint_date
FROM complaints;

--Compare today's complaint count with the previous day's complaint count.

SELECT
    complaint_date,
    COUNT(*) AS complaint_count,
    LAG(COUNT(*))
    OVER
    (
        ORDER BY complaint_date
    ) AS previous_day_count
FROM complaints
GROUP BY complaint_date;

