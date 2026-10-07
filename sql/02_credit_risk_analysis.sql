-- ====================================================================================================================================================================================
-- 02 CREDIT RISK ANALYSIS
-- ====================================================================================================================================================================================


-- ========================================================================================================================
-- BUSINESS QUESTION 1: HOW IS THE PORTFOLIO DISTRIBUTED ACROSS CREDIT GRADES?
-- ========================================================================================================================

-- Purpose:
-- Examine the distribution of loans across the portfolio's credit grades.
--
-- This analysis measures the number of loans, percentage of total portfolio volume, total original loan exposure, and average loan amount associated with each credit grade.
--
-- Understanding the distribution of credit grades helps assesshow the portfolio is positioned across different levels of borrower credit quality.


SELECT
    grade,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY grade
ORDER BY grade;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Grade A: 9,689 loans, representing 25.12% of the portfolio, with $84,252,225 in original loan exposure and an average loan amount of $8,695.66.
--
-- Grade B: 11,674 loans, representing 30.26% of the portfolio, with $130,703,975 in original loan exposure and an average loan amount of $11,196.16.
--
-- Grade C: 7,904 loans, representing 20.49% of the portfolio, with $87,456,450 in original loan exposure and an average loan amount of $11,064.83.
--
-- Grade D: 5,182 loans, representing 13.43% of the portfolio, with $63,920,800 in original loan exposure and an average loan amount of $12,335.16.
--
-- Grade E: 2,786 loans, representing 7.22% of the portfolio, with $44,165,100 in original loan exposure and an average loan amount of $15,852.51.
--
-- Grade F: 1,028 loans, representing 2.66% of the portfolio, with $18,910,450 in original loan exposure and an average loan amount of $18,395.38.
--
-- Grade G: 313 loans, representing 0.81% of the portfolio, with $6,348,075 in original loan exposure and an average loan amount of $20,281.39.
--
-- Grades A through C account for 29,267 loans, representing 75.87% of the total portfolio volume.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The portfolio is concentrated toward Grades A through C, which together account for 29,267 loans or 75.87% of total portfolio volume.
--
-- Grade B is the largest individual segment, with 11,674 loans and 30.26% of total portfolio volume. It also represents the largest original exposure at $130,703,975.
--
-- The results also show that average loan size increases as credit grade moves from A toward G. Average loan amount rises from $8,695.66 for Grade A to $20,281.39 for Grade G.
--
-- Although Grades E through G represent only 10.69% of total portfolio volume, they account for $69,423,625 in original loan exposure. Their relatively small number of loans is therefore accompanied by substantially larger average loan amounts.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The concentration of 75.87% of portfolio volume in Grades A through C means that these segments represent the largest portion of lending activity and should remain important inoverall portfolio monitoring.
--
-- At the same time, the lower credit-grade segments require attention from an exposure perspective. Grades E through G account for only 10.69% of loans but represent $69,423,625 in original exposure because their average loan amounts are substantially higher.
--
-- This demonstrates why portfolio monitoring should consider both loan volume and financial exposure. A smaller segment can still represent a meaningful concentration of financial exposure when the average amount extended per loan is higher.


-- ========================================================================================================================
-- BUSINESS QUESTION 2: HOW DOES INTEREST-RATE EXPOSURE VARY ACROSS THE PORTFOLIO?
-- ========================================================================================================================

-- Purpose:
-- Examine how loans and original loan exposure are distribute across different interest-rate ranges.
--
-- This analysis helps assess the portfolio's exposure todifferent lending-rate segments and determine whether higher-rate lending represents a meaningful portion of overall portfolio activity and exposure.


SELECT
    CASE
        WHEN int_rate < 0.10 THEN '5-10%'
        WHEN int_rate < 0.15 THEN '10-15%'
        WHEN int_rate < 0.20 THEN '15-20%'
        ELSE '20-25%'
    END AS interest_rate_band,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(int_rate) * 100, 2) AS average_interest_rate,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY interest_rate_band
ORDER BY
    CASE interest_rate_band
        WHEN '5-10%' THEN 1
        WHEN '10-15%' THEN 2
        WHEN '15-20%' THEN 3
        WHEN '20-25%' THEN 4
    END;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The 5-10% interest-rate band contains 11,652 loans, representing 30.21% of the portfolio, with $104,236,000 in original loan exposure. The average interest rate is 7.74% and the average loan amount is $8,945.76.
--
-- The 10-15% band contains 18,594 loans, representing 48.20% of the portfolio, with $208,412,075 in original loan exposure.
--
--The average interest rate is 12.38% and the average loan amount is $11,208.57.
--
-- The 15-20% band contains 7,472 loans, representing 19.37% of the portfolio, with $105,168,875 in original loan exposure.
-- 
--The average interest rate is 16.88% and the average loan amount is $14,075.06.
--
-- The 20-25% band contains 858 loans, representing 2.22% of the portfolio, with $17,940,125 in original loan exposure.
-- 
--The average interest rate is 21.20% and the average loan amount is $20,909.24.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The portfolio is concentrated in the 10-15% interest-rate band, which accounts for 18,594 loans or 48.20% of total portfolio volume and $208,412,075 in original exposure.
--
-- The results also show a clear increase in average loan size as interest-rate bands increase. Average loan amount rises from $8,945.76 in the 5-10% band to $20,909.24 in the 20-25% band.
--
-- The highest-rate segment represents only 2.22% of portfolio volume but contains $17,940,125 in original exposure. Its average loan amount of $20,909.24 is more than twice the $8,945.76 average observed in the 5-10% band.
--
-- Loans in the 15-25% bands together account for 8,330 loans, or 21.59% of portfolio volume, and $123,109,000 in original loan exposure.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The concentration of 48.20% of portfolio volume and $208,412,075 in original exposure within the 10-15% band makes this the most significant interest-rate segment by both loan volume and financial exposure.
--
-- However, the higher-rate segments warrant attention because loan size increases substantially as interest rates increase. Loans in the 20-25% band have an average loan amount of $20,909.24, compared with $8,945.76 in the 5-10% band.
--
-- Although the 20-25% segment represents only 2.22% of loans, it accounts for $17,940,125 in original exposure. This shows that a relatively small number of loans can still represent meaningful financial exposure when the average amount originated is substantially larger.
--
-- From a portfolio management perspective, interest-rate monitoring should therefore consider both the distribution of loans and the size of exposure within each rate segment. Focusing only on the number of loans could understate the financial significance of higher-rate lending.





-- ========================================================================================================================
-- BUSINESS QUESTION 3: HOW DOES BORROWER DEBT BURDEN VARY ACROSS THE PORTFOLIO?
-- ========================================================================================================================

-- Purpose:
-- Examine how loans and original loan exposure are distributed across different levels of borrower debt-to-income ratio (DTI).
--
-- DTI provides an indication of the borrower's existing debt burden relative to income. Segmenting the portfolio by DTI helps assess how much lending exposure is associated with different levels of borrower financial leverage.


SELECT
    CASE
        WHEN dti < 0.05 THEN '0-5%'
        WHEN dti < 0.10 THEN '5-10%'
        WHEN dti < 0.15 THEN '10-15%'
        WHEN dti < 0.20 THEN '15-20%'
        WHEN dti < 0.25 THEN '20-25%'
        ELSE '25-30%'
    END AS dti_band,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(dti) * 100, 2) AS average_dti,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY dti_band
ORDER BY
    CASE dti_band
        WHEN '0-5%' THEN 1
        WHEN '5-10%' THEN 2
        WHEN '10-15%' THEN 3
        WHEN '15-20%' THEN 4
        WHEN '20-25%' THEN 5
        WHEN '25-30%' THEN 6
    END;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The 0-5% DTI band contains 4,953 loans, representing 12.84% of the portfolio, with $48,634,475 in original loan exposure.
-- The average DTI is 2.64% and the average loan amount is $9,819.20.
--
-- The 5-10% band contains 7,822 loans, representing 20.28% of the portfolio, with $86,917,850 in original loan exposure.
-- The average DTI is 7.65% and the average loan amount is $11,111.97.
--
-- The 10-15% band contains 9,646 loans, representing 25.01% of the portfolio, with $111,761,450 in original loan exposure.
-- The average DTI is 12.53% and the average loan amount is $11,586.30.
--
-- The 15-20% band contains 8,864 loans, representing 22.98% of the portfolio, with $104,226,500 in original loan exposure.
-- The average DTI is 17.42% and the average loan amount is $11,758.40.
--
-- The 20-25% band contains 6,643 loans, representing 17.22% of the portfolio, with $75,947,925 in original loan exposure.
-- The average DTI is 22.31% and the average loan amount is $11,432.78.
--
-- The 25-30% band contains 648 loans, representing 1.68% of the portfolio, with $8,268,875 in original loan exposure.
-- The average DTI is 27.21% and the average loan amount is $12,760.61.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The portfolio is concentrated in the middle DTI ranges.
-- The 10-15% band is the largest segment, containing 9,646 loans or 25.01% of the portfolio, with $111,761,450 in original exposure.
--
-- The 10-20% DTI range accounts for 18,510 loans, representing 47.99% of total portfolio volume, and $215,987,950 in original exposure.
--
-- Borrower debt burden increases steadily across the bands, with average DTI rising from 2.64% in the 0-5% segment to 27.21% in the 25-30% segment.
--
-- Average loan size also generally increases as DTI rises, from $9,819.20 in the 0-5% band to $12,760.61 in the 25-30% band. However, the 20-25% band has a slightly lower average loan amount of $11,432.78 than the 15-20% band at $11,758.40.
--
-- The highest-DTI segment is relatively small, representing only 1.68% of loans and $8,268,875 in original exposure.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The concentration of 47.99% of portfolio volume within the 10-20% DTI range means that this borrower segment represents a substantial portion of the portfolio and should remain an important area of portfolio monitoring.
--
-- The 25-30% DTI segment represents a much smaller share of lending activity, with 648 loans and $8,268,875 in original exposure. However, its average DTI of 27.21% and average loan amount of $12,760.61 indicate that these borrowers carry a higher debt burden while receiving relatively larger loans.
--
-- From a portfolio management perspective, DTI segmentation provides a useful view of borrower financial leverage. It allows the portfolio to be monitored not only by the number of borrowers but also by the amount of credit extended to borrowers at different levels of debt burden.
--
-- The results also demonstrate that the highest-DTI segment does not necessarily represent the largest financial exposure. Portfolio monitoring should therefore consider both borrower concentration and original loan exposure when assessing financial leverage across the portfolio.





-- ========================================================================================================================
-- BUSINESS QUESTION 4: WHICH CREDIT GRADES CONTAIN THE GREATEST CONCENTRATION OF HIGH-VALUE LOANS?
-- ========================================================================================================================

-- Purpose:
-- Examine how high-value loans are distributed across the portfolio's credit grades.
--
-- This analysis identifies the number and total exposure of loans above a defined loan-value threshold within each credit grade.
--
-- Understanding where high-value loans are concentrated helps identify credit segments that may carry greater individual loan exposure, even when those segments represent a smaller share of total portfolio volume.


SELECT
    grade,
    COUNT(*) AS high_value_loans,
    SUM(loan_amount) AS high_value_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
WHERE loan_amount >= 20000
GROUP BY grade
ORDER BY high_value_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Grade B contains the largest number of high-value loans, with 1,832 loans, representing 29.87% of the high-value loan volume and $44,220,150 in high-value loan exposure. Its average loan amount is $24,137.64.
--
-- Grade C contains 1,218 high-value loans, representing 19.86% of the high-value loan volume, with $29,563,475 in high-value loan exposure and an average loan amount of $24,272.15.
--
-- Grade D contains 1,014 high-value loans, representing 16.53% of the high-value loan volume, with $25,039,650 in high-value loan exposure and an average loan amount of $24,693.93.
--
-- Grade E contains 948 high-value loans, representing 15.46% of the high-value loan volume, with $24,899,000 in high-value loan exposure and an average loan amount of $26,264.77.
--
-- Grade F contains 480 high-value loans, representing 7.83% of the high-value loan volume, with $12,753,925 in high-value loan exposure and an average loan amount of $26,570.68.
--
-- Grade A contains 455 high-value loans, representing 7.42% of the high-value loan volume, with $10,997,050 in high-value loan exposure and an average loan amount of $24,169.34.
--
-- Grade G contains 186 high-value loans, representing 3.03% of the high-value loan volume, with $4,844,300 in high-value loan exposure and an average loan amount of $26,044.62.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Grade B represents the largest concentration of high-value loans, accounting for 29.87% of high-value loan volume and 29.03% of total high-value loan exposure.
--
-- Grades A through C together account for 3,505 high-value loans, representing 57.16% of high-value loan volume and $74,780,675 in high-value loan exposure, or approximately 49.10% of total high-value loan exposure.
--
-- Grades E through G account for 1,614 high-value loans, representing 26.32% of high-value loan volume and $42,496,225 in high-value loan exposure, or approximately 27.90% of total high-value loan exposure.
--
-- Average loan size is generally higher across the lower credit grades, increasing from $24,137.64 in Grade B and $24,169.34 in Grade A to $26,264.77 in Grade E, $26,570.68 in Grade F, and $26,044.62 in Grade G.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Grade B should remain a key area of portfolio monitoring because it represents the largest concentration of high-value loans, with 1,832 loans and $44,220,150 in exposure.
--
-- The concentration of 57.16% of high-value loan volume and approximately 49.10% of high-value loan exposure within Grades A through C means that these segments have a significant influence on the high-value portion of the portfolio because of their scale.
--
-- At the same time, Grades E through G demonstrate why loan volume alone is insufficient for monitoring high-value exposures. These segments account for only 26.32% of high-value loans but represent approximately 27.90% of high-value loan exposure.
--
-- Their higher average loan amounts, particularly $26,264.77 for Grade E, $26,570.68 for Grade F, and $26,044.62 for Grade G, mean that changes affecting these lower-grade segments can have a meaningful financial impact relative to their number of accounts.
--
-- From a portfolio management perspective, high-value loan monitoring should therefore consider both credit-grade concentration and financial exposure. This provides a more complete view of where portfolio monitoring and risk-management attention may be most relevant.