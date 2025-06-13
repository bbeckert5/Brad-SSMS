SELECT DISTINCT
	CommissionStatementID
FROM fdm.Consolidated.Commissions_Transactions
WHERE CommissionStatementID = 56733
	--CommissionStatementID NOT IN (
	--	SELECT CommissionStatementID
	--	FROM fdm.Consolidated.Commission_Statements
	--)
;

SELECT *
FROM fdm.Consolidated.Commissions_Transactions as tx
WHERE tx.CommissionStatementID = 47061 -- 56733
;