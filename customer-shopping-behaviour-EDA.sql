USE defaultdb;
SHOW TABLES;
SELECT * FROM customer_shopping_behavior LIMIT 10;
SELECT gender,SUM(purchase_amount) as revenue FROM customer_shopping_behavior GROUP BY gender;
SELECT customer_id FROM customer_shopping_behavior WHERE (discount_applied='Yes' AND purchase_amount>(SELECT AVG(purchase_amount) FROM customer_shopping_behavior));

SELECT item_purchased,AVG(review_rating) as Average_review_rating
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY Average_review_rating DESC
LIMIT 5;


SELECT shipping_type,AVG(purchase_amount)
FROM customer_shopping_behavior
WHERE shipping_type IN('Standard','Express')
GROUP BY shipping_type;


SELECT subscription_status,AVG(purchase_amount) AS Average_Revenue,SUM(purchase_amount) AS Total_Revenue
FROM customer_shopping_behavior
GROUP BY subscription_status;


SELECT item_purchased,
(100*SUM(CASE WHEN discount_applied='Yes' THEN 1 ELSE 0 END)/COUNT(*)) AS discount_rate
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


WITH customer_type AS(
SELECT customer_id,previous_purchases,
CASE
WHEN previous_purchases=1 THEN 'New'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyal'
END 
AS customer_segment
FROM customer_shopping_behavior
)

SELECT customer_segment,COUNT(*) AS Number_of_customers
FROM customer_type
GROUP BY customer_segment;


WITH item_counts AS(
SELECT category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() OVER(PARTITION BY(category) ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customer_shopping_behavior
GROUP BY category,item_purchased
)

SELECT item_rank,category,item_purchased,total_orders
FROM item_counts
WHERE item_rank<=3;



SELECT subscription_status,COUNT(customer_id) as total_count
FROM customer_shopping_behavior
WHERE previous_purchases>5
GROUP BY subscription_status;


SELECT age_group,SUM(purchase_amount) as total_revenue
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY total_revenue DESC;


