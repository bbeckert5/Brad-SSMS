ALTER TABLE [Consolidated].[StatementBankingTransactionAssociation]
ADD FOREIGN KEY ([CommissionStatementID])
REFERENCES [Consolidated].[CommissionStatements] ([CommissionStatementID])
;
