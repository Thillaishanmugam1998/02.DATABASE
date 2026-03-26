-- ============================================================
--  FoodDeliveryDB — NULL Handling : Correct Answers
--  Topic  : ISNULL / COALESCE / NULLIF / CASE NULL Checks
--  Levels : Easy (3) + Medium (3) + Hard (3)
-- ============================================================


-- ============================================================
-- ★ EASY 1
-- EN : Show agent_id for each order. Replace NULL with 0 using ISNULL.
-- ============================================================
SELECT
    order_id,
    ISNULL(agent_id, 0)         AS agent_id
FROM Orders;


-- ============================================================
-- ★ EASY 2
-- EN : Show review_text for each review. If NULL, show 'No review given'.
-- ============================================================
SELECT
    review_id,
    ISNULL(review_text, 'No review given')  AS review_text
FROM Reviews;


-- ============================================================
-- ★ EASY 3
-- EN : Count how many orders have NULL agent_id.
-- ============================================================
SELECT
    COUNT(*)        AS null_agent_order_count
FROM Orders
WHERE agent_id IS NULL;


-- ============================================================
-- ★★ MEDIUM 1
-- EN : Use COALESCE to show: agent_name if assigned, else 'Unassigned'.
--      Join DeliveryAgents table.
-- ============================================================
SELECT
    o.order_id,
    o.agent_id,
    COALESCE(da.agent_name, 'Unassigned')   AS agent_name
FROM Orders AS o
LEFT JOIN DeliveryAgents AS da
    ON da.agent_id = o.agent_id;


-- ============================================================
-- ★★ MEDIUM 2
-- EN : Use NULLIF to convert discount = 0 to NULL.
--      Then compute average discount excluding zero-discount orders.
-- ============================================================
SELECT
    AVG(NULLIF(discount, 0))    AS avg_discount_excluding_zero
FROM Orders;


-- ============================================================
-- ★★ MEDIUM 3
-- EN : Show the effective agent rating: use the agent's rating if available,
--      else use the restaurant's average review rating, else 0.
--      Use COALESCE with multiple fallbacks.
--
-- NOTE : DeliveryAgents.rating       → agent's own rating
--        Reviews.food_rating         → per-order food rating (used as review proxy)
--        Restaurants table has rating too but Reviews is more granular
-- ============================================================
SELECT
    da.agent_id,
    da.agent_name,
    da.rating                                       AS agent_own_rating,
    AVG(CAST(r.food_rating AS DECIMAL(5,2)))        AS avg_restaurant_review_rating,
    COALESCE(
        da.rating,                                  -- 1st: Agent's own rating
        AVG(CAST(r.food_rating AS DECIMAL(5,2))),   -- 2nd: Avg food rating from reviews
        0                                           -- 3rd: Final fallback
    )                                               AS effective_agent_rating
FROM DeliveryAgents AS da
LEFT JOIN Orders AS o
    ON o.agent_id = da.agent_id
LEFT JOIN Reviews AS r
    ON r.restaurant_id = o.restaurant_id
GROUP BY
    da.agent_id,
    da.agent_name,
    da.rating;


-- ============================================================
-- ★★★ HARD 1
-- EN : Identify all columns across all tables that allow NULL values.
--      Query INFORMATION_SCHEMA.COLUMNS.
-- ============================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE IS_NULLABLE = 'YES'
ORDER BY TABLE_NAME, COLUMN_NAME;


-- ============================================================
-- ★★★ HARD 2
-- EN : Write a query that shows the "completeness score" of each order:
--      +1 for agent assigned, +1 for review exists, +1 for discount > 0.
--      Max score = 3. Use CASE + NULL checks.
-- ============================================================
SELECT
    o.order_id,
    o.agent_id,
    o.discount,
    re.review_id,

    -- Individual score components
    CASE WHEN o.agent_id   IS NOT NULL THEN 1 ELSE 0 END    AS agent_assigned_score,
    CASE WHEN re.review_id IS NOT NULL THEN 1 ELSE 0 END    AS review_exists_score,
    CASE WHEN o.discount   > 0         THEN 1 ELSE 0 END    AS discount_score,

    -- Final completeness score (max = 3)
    CASE WHEN o.agent_id   IS NOT NULL THEN 1 ELSE 0 END
  + CASE WHEN re.review_id IS NOT NULL THEN 1 ELSE 0 END
  + CASE WHEN o.discount   > 0         THEN 1 ELSE 0 END    AS completeness_score

FROM Orders AS o
LEFT JOIN Reviews AS re
    ON re.order_id = o.order_id;


-- ============================================================
-- ★★★ HARD 3
-- EN : Show all orders where either delivery_rating IS NULL (no review) or
--      food_rating < 3. These are "attention needed" orders.
--      Show customer name, restaurant, and a reason column.
-- ============================================================
SELECT
    o.order_id,
    c.full_name                 AS customer_name,
    rs.restaurant_name,
    r.delivery_rating,
    r.food_rating,
    CASE
        WHEN r.delivery_rating IS NULL AND r.food_rating IS NULL
            THEN 'No Review Submitted'
        WHEN r.delivery_rating IS NULL AND r.food_rating >= 3
            THEN 'Delivery Rating Missing'
        WHEN r.food_rating < 3 AND r.delivery_rating IS NOT NULL
            THEN 'Poor Food Rating'
        WHEN r.delivery_rating IS NULL AND r.food_rating < 3
            THEN 'Delivery Rating Missing + Poor Food Rating'
        ELSE 'OK'
    END                         AS reason_for_attention
FROM Orders AS o
LEFT JOIN Reviews      AS r  ON r.order_id       = o.order_id
LEFT JOIN Customers    AS c  ON c.customer_id    = o.customer_id
LEFT JOIN Restaurants  AS rs ON rs.restaurant_id = o.restaurant_id
WHERE
    r.delivery_rating IS NULL
    OR r.food_rating < 3;


-- ============================================================
-- END OF FILE
-- ============================================================