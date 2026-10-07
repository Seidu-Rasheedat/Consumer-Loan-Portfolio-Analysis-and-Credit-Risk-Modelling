-- ====================================================================================================================================================================================
-- 04 PORTFOLIO CONCENTRATION
-- ====================================================================================================================================================================================


-- ========================================================================================================================
-- BUSINESS QUESTION 1: HOW CONCENTRATED IS PORTFOLIO EXPOSURE ACROSS LOAN PURPOSES?
-- ========================================================================================================================

-- Purpose:
-- Examine how original loan exposure is distributed and accumulated across different loan purposes.
--
-- This analysis ranks loan purposes by total original exposure and measures their individual and cumulative share of total portfolio exposure.
--
-- Understanding cumulative exposure concentration helps identify whether a large proportion of the portfolio's financial exposure is concentrated within a relatively small number of loan purposes, which may indicate potential risk concentration.


WITH purpose_exposure AS (
    SELECT
        purpose,
        SUM(loan_amount) AS total_exposure
    FROM loans
    GROUP BY purpose
),

ranked_purposes AS (
    SELECT
        purpose,
        total_exposure,
        ROUND(
            total_exposure * 100.0 /
            (SELECT SUM(total_exposure) FROM purpose_exposure),
            2
        ) AS exposure_pct,
        ROW_NUMBER() OVER (
            ORDER BY total_exposure DESC
        ) AS exposure_rank
    FROM purpose_exposure
)

SELECT
    exposure_rank,
    purpose,
    total_exposure,
    exposure_pct,
    ROUND(
        SUM(exposure_pct) OVER (
            ORDER BY exposure_rank
        ),
        2
    ) AS cumulative_exposure_pct
FROM ranked_purposes
ORDER BY exposure_rank;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Debt consolidation is the largest loan purpose by exposure, with $232,459,675 in total exposure, representing 53.35% of the portfolio.
--
-- Credit card ranks second, with $58,885,175 in exposure, representing 13.51% of the portfolio.
--
-- Home improvement ranks third, with $33,350,775 in exposure, representing 7.65% of the portfolio.
--
-- Other accounts for $31,155,750 in exposure, representing 7.15% of the portfolio.
--
-- Small business accounts for $24,123,100 in exposure, representing 5.54% of the portfolio.
--
-- Major purchase accounts for $17,251,600 in exposure, representing 3.96% of the portfolio.
--
-- Car accounts for $10,223,575 in exposure, representing 2.35% of the portfolio.
--
-- Wedding accounts for $9,225,800 in exposure, representing 2.12% of the portfolio.
--
-- Medical accounts for $5,533,225 in exposure, representing 1.27% of the portfolio.
--
-- House accounts for $4,824,925 in exposure, representing 1.11% of the portfolio.
--
-- Moving accounts for $3,748,125 in exposure, representing 0.86% of the portfolio.
--
-- Educational accounts for $2,161,650 in exposure, representing 0.50% of the portfolio.
--
-- Vacation accounts for $1,967,950 in exposure, representing 0.45% of the portfolio.
--
-- Renewable energy accounts for $845,750 in exposure, representing 0.19% of the portfolio.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Debt consolidation is the dominant source of portfolio exposure, accounting for 53.35% of total exposure on its own.
--
-- The top two purposes, debt consolidation and credit card, collectively account for 66.86% of total portfolio exposure, indicating a strong concentration in debt-related borrowing.
--
-- The top three purposes, including home improvement, account for 74.51% of total exposure.
--
-- The top five purposes account for 87.20% of total portfolio exposure, with debt consolidation, credit card, home improvement, other, and small business representing the largest exposure concentrations.
--
-- By the tenth-ranked purpose, house, cumulative exposure reaches 98.01%, meaning that almost the entire portfolio exposure is concentrated across the ten largest loan purposes.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Debt consolidation should remain a key area of portfolio monitoring because it represents the largest individual exposure concentration, accounting for $232,459,675 or 53.35% of total portfolio exposure.
--
-- The combined 66.86% exposure concentration across debt consolidation and credit card purposes indicates that changes in consumer borrowing behaviour within these two segments could have a substantial impact on overall portfolio exposure.
--
-- The top five loan purposes account for 87.20% of total exposure, suggesting that portfolio monitoring and risk-management resources should prioritize these major exposure drivers.
--
-- The high concentration in debt-related purposes also highlights the importance of monitoring borrower repayment capacity and credit performance within these segments, as deterioration could affect a significant portion of the portfolio.
--
-- Lower-ranked purposes such as vacation, educational, and renewable energy represent relatively small individual exposures. However, their contribution should still be monitored as part of a complete portfolio view.
--
-- From a portfolio management perspective, exposure should therefore be assessed not only by the number of loans but also by the concentration of financial exposure across loan purposes. This helps identify the segments where changes in borrower behaviour could have the greatest financial impact.





-- ========================================================================================================================
-- QUESTION 2: WHICH CREDIT-GRADE SEGMENTS ACCOUNT FOR THE LARGEST CONCENTRATIONS OF PORTFOLIO EXPOSURE?
-- ========================================================================================================================

-- Purpose:
-- Assess how original loan exposure is distributed across borrower credit grades and identify the credit segments that represent the greatest concentration of portfolio exposure.

SELECT
    grade,
    COUNT(*) AS total_loans,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,

    SUM(loan_amount) AS total_loan_exposure,

    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,

    ROUND(AVG(loan_amount), 2) AS average_loan_amount

FROM loans

GROUP BY grade

ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Grade B represents the largest concentration of portfolio exposure, with 11,674 loans (30.26% of loan volume) and $130,703,975 in original exposure (29.99% of total exposure).
--
-- Grade C follows with 7,904 loans (20.49%) and $87,456,450 in exposure (20.07%), while Grade A contains 9,689 loans (25.12%) and $84,252,225 in exposure (19.33%).
--
-- Together, Grades A-C account for 29,267 loans, representing 75.87% of total loan volume and approximately 69.40% of total portfolio exposure.
--
-- Lower credit grades represent smaller portions of loan volume but carry progressively larger average loan amounts. Grade E accounts for 7.22% of loans but 10.14% of exposure, while Grades F and G account for 2.66% and 0.81% of loans but 4.34% and 1.46% of exposure, respectively.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The portfolio is concentrated primarily in Grades A-C, with these three grades accounting for 75.87% of all loans and approximately 69.40% of total original exposure.
--
-- However, exposure is not distributed proportionally across all grades. Average loan size increases from $8,695.66 in Grade A to $20,281.39 in Grade G.
--
-- This means that although the lower grades contain fewer loans, they represent a disproportionately large amount of exposure relative to their loan volume.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Portfolio monitoring should focus on the large A-C exposure base because these grades represent the majority of lending activity and exposure.
--
-- At the same time, higher-risk grades require closer exposure monitoring because their average loan sizes are substantially larger. Grade E, for example, represents only 7.22% of loan volume but accounts for 10.14% of portfolio exposure.





-- ========================================================================================================================
-- BUSINESS QUESTION 3: WHICH GEOGRAPHIC MARKETS HAVE DISPROPORTIONATELY HIGH AVERAGE LOAN EXPOSURE?
-- ========================================================================================================================

-- Purpose:
-- Examine differences in average loan exposure across geographic markets.
--
-- This analysis compares the number of loans, total original exposure, exposure share, and average loan amount across geographic markets to identify states where individual loan exposure is relatively high.
--
-- Understanding geographic differences in average loan size helps identify markets where portfolio exposure per loan may be higher, even when those markets do not represent the largest share of total loan volume.


SELECT
    address_state AS state,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY address_state
ORDER BY average_loan_amount DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- California has the largest state-level exposure, with 6,894 loans and $78,484,125 in exposure, representing 18.01% of the portfolio.
--
-- New York ranks second with $42,077,050 in exposure (9.66%), followed by Texas with $31,236,650 (7.17%) and Florida with $30,046,125 (6.90%).
--
-- The remaining states each account for less than 5% of total portfolio exposure, with New Jersey having the highest among them at 4.97%.
--
-- Average loan amounts range from $3,066.67 in Maine to $13,228.21 in Alaska.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- California, New York, Texas, and Florida collectively account for 41.74% of total portfolio exposure, indicating significant geographic concentration.
--
-- The largest loan volumes are also concentrated in these states, with California having 6,894 loans, New York 3,701, Florida 2,773, and Texas 2,664.
--
-- Geographic exposure varies not only by loan volume but also by average loan size, with Alaska recording the highest average loan amount despite having a relatively small portfolio.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- California, New York, Texas, and Florida should remain the primary focus of geographic portfolio monitoring because of their combined 41.74% share of total exposure.
--
-- States with smaller loan volumes should still be evaluated based on average loan size, as lower account counts can still represent meaningful exposure.
--
-- Geographic risk management should therefore consider both loan volume and total exposure when prioritising monitoring and portfolio resources.





-- ====================================================================================================================================
-- QUESTION 4: WHICH COMBINATIONS OF BORROWER CREDIT QUALITY AND LOAN TERM REPRESENT THE LARGEST CONCENTRATIONS OF PORTFOLIO EXPOSURE?
-- ====================================================================================================================================

-- Purpose:
-- Identify the credit-grade and loan-term combinations that account for the greatest portfolio exposure and determine whether longer-term lending creates larger exposure within different credit-grade segments.


SELECT
    grade,
    term_months,

    COUNT(*) AS total_loans,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,

    SUM(loan_amount) AS total_loan_exposure,

    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,

    ROUND(AVG(loan_amount), 2) AS average_loan_amount

FROM loans

GROUP BY grade, term_months

ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The largest concentration is Grade B loans with a 36-month term, comprising 9,075 loans (23.52% of loan volume) and $91,470,600 in original exposure (20.99%).
--
-- Grade A 36-month loans are the second-largest concentration, with 9,274 loans (24.04%) and $79,984,575 in exposure (18.36%).
--
-- Grade C 36-month loans follow with 5,613 loans (14.55%)and $52,150,050 in exposure (11.97%).
--
-- Among 60-month loans, Grade B represents the largest concentration at $39,233,375 (9.00%), followed by Grade C at $35,306,400 (8.10%).
--
-- Longer-term loans generally have higher average loan amounts within the same credit grade. For example, Grade B has an average loan amount of $10,079.40 for 36-month loans compared with $15,095.57 for 60-month loans.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================
-- Portfolio exposure is concentrated primarily in 36-month loans within Grades A-C. Grade A, B and C 36-month loans collectively account for $223,605,225 in original exposure, representing approximately 51.32% of the total portfolio.
--
-- The results also show that 60-month loans create larger exposure per loan across most credit grades. For example, the average Grade E loan increases from $12,911.08 for a 36-month term to $17,150.52 for a 60-month term.
--
-- This means that although 36-month loans dominate the portfolio by volume and exposure, 60-month lending can create sizeable exposure concentrations because of its larger average loan amounts.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Portfolio monitoring should consider credit grade and loan term together rather than evaluating either characteristic in isolation.
--
-- The large exposure concentrated in A-C 36-month loans means these segments represent an important part of the portfolio and should remain central to exposure monitoring.
--
-- At the same time, 60-month loans warrant attention because their larger average loan sizes can create significant exposure even when the number of loans is relatively smaller.





-- ============================================================================================================================
-- QUESTION 5: WHICH COMBINATIONS OF LOAN PURPOSE AND CREDIT GRADE REPRESENT THE LARGEST CONCENTRATIONS OF PORTFOLIO EXPOSURE?
-- ============================================================================================================================

-- Purpose:
-- Assess portfolio concentration across loan purposes and credit grades simultaneously, identifying the combinations that account for the largest amounts of original loan exposure.


SELECT
    purpose,
    grade,

    COUNT(*) AS total_loans,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,

    SUM(loan_amount) AS total_loan_exposure,

    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,

    ROUND(AVG(loan_amount), 2) AS average_loan_amount

FROM loans

GROUP BY purpose, grade

ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Debt consolidation represents the largest concentration across purpose-grade combinations. Grade B within debt consolidation accounts for 5,504 loans (14.27% of loan volume) and $68,427,300 in original exposure (15.70% of total portfolio exposure).
--
-- Debt consolidation Grade C is the second-largest combination, with 3,868 loans (10.03%) and $47,588,125 in exposure (10.92%).
--
-- Debt consolidation Grades A, D and E account for a further $37,216,300 (8.54%), $37,007,125 (8.49%) and $27,033,875 (6.20%) in exposure, respectively.
--
-- Together, Debt consolidation across Grades A-E accounts for $217,272,725 in original exposure, representing approximately 49.86% of total portfolio exposure.
--
-- Other notable concentrations include Credit Card Grade B at $18,282,500 (4.20%), Home Improvement Grade B at $10,596,875 (2.43%), and Other Grade B at $9,624,375 (2.21%).


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Portfolio exposure is heavily concentrated in debt consolidation across several credit grades, rather than being concentrated within a single grade.
--
-- Grades B and C within debt consolidation alone account for $116,015,425 in original exposure, representing approximately 26.62% of total portfolio exposure.
--
-- The concentration extends across Grades A-E, which together account for approximately 49.86% of total portfolio exposure within the debt consolidation purpose. This shows that the overall concentration is driven by the combination of a large lending purpose and substantial exposure acrosS multiple credit-quality segments.
--
-- The results also show that higher-grade segments can still represent significant exposure when they occur within a high-volume loan purpose. For example, Debt consolidation. Grade B has the largest exposure despite not having the largest average loan size across all purpose-grade combinations.


-- ========================================================================================================================
-- Business Implication:
-- ========================================================================================================================
-- Portfolio concentration monitoring should evaluate loaN purpose and credit grade together because significant exposure can be concentrated within specific combinations that may not be fully visible when either dimension is assessed separately.
--
-- Debt consolidation should receive particular attention, especially Grades B and C, because these two combinations alone represent approximately 26.62% of total portfolio exposure.
--
-- More broadly, the approximately 49.86% of portfolio exposure concentrated in Debt consolidation across Grades A-E highlights the importance of monitoring this lending purpose across its different credit-quality segments rather than treating the purpose as a single undifferentiated category.