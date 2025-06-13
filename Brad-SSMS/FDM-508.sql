--[Consolidated].[Commission_Statements]
if object_id('tempdb..#tmp_commission_statements') is not null drop table #tmp_commission_statements;
create table #tmp_commission_statements (
	[CommissionStatementId] BIGINT,
	[FileName]              NVARCHAR (500),
	[ComulateID]            NVARCHAR (255),
	[CompanyID]             NVARCHAR (100),
	[StagedDate]            DATETIME,
	[IsDeleted]             BIT
);

insert into #tmp_commission_statements
	select
		stmt.[CommissionStatementId],
		stmt.[FileName],
		stmt.[ComulateID],
		stmt.[CompanyID],
		stmt.[StagedDate],
		stmt.[IsDeleted]
	from [FDM].[Consolidated].[Commission_Statements] as stmt
	join (
			select
				cs.ComulateID,
				max(cs.StagedDate) as StagedDate
			from [FDM].[Consolidated].[Commission_Statements] as cs
			group by cs.ComulateID
		) as com on stmt.ComulateID = com.ComulateID and stmt.StagedDate != com.StagedDate	-- NON-LATEST DUPLICATE RECORDS.
	order by stmt.CommissionStatementId, stmt.ComulateID
;

select * from #tmp_commission_statements;

delete tx
from FDM.Consolidated.Commissions_Transactions as tx
join #tmp_commission_statements as tmp on tx.CommissionStatementId = tmp.CommissionStatementId
;

delete sbta
from FDM.Consolidated.StatementBankingTransactionAssociation as sbta
join #tmp_commission_statements as tmp on sbta.CommissionStatementId = tmp.CommissionStatementId
;

delete stmt
from FDM.Consolidated.Commission_Statements as stmt
join #tmp_commission_statements as tmp on stmt.CommissionStatementId = tmp.CommissionStatementId
;

ALTER TABLE [FDM].[Consolidated].[Commission_Statements]
 ADD  CONSTRAINT [UKC_CS_ComulateIDXX] UNIQUE NONCLUSTERED 
(
	[ComulateID] ASC
)WITH (
	PAD_INDEX = OFF,
	STATISTICS_NORECOMPUTE = OFF,
	SORT_IN_TEMPDB = OFF,
	IGNORE_DUP_KEY = OFF,
	ONLINE = OFF,
	ALLOW_ROW_LOCKS = ON,
	ALLOW_PAGE_LOCKS = ON,
	OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
	) ON [PRIMARY]
;

if object_id('tempdb..#tmp_commission_statements') is not null drop table #tmp_commission_statements;

--[Consolidated].[Commissions_Transactions]
if object_id('tempdb..#tmp_commissions_transactions') is not null drop table #tmp_commissions_transactions;
create table #tmp_commissions_transactions (
	[CommissionTransactionID] BIGINT,
    [PostingTime]             DATETIME,
    [Policy_Number]           NVARCHAR (100),
    [Contract_Id]             NVARCHAR (100),
    [Member_Id]               NVARCHAR (100),
    [Product_Id]              NVARCHAR (100),
    [Agent_Id]                NVARCHAR (100),
    [Department_Id]           NVARCHAR (100),
    [Transaction_Type]        NVARCHAR (100),
    [Commission_Category]     NVARCHAR (100),
    [Commission_Date]         DATE,
    [Policy_Effective_Date]   DATE,
    [Paid_Through_Date]       DATE,
    [Term_Date]               DATE,
    [Policy_State]            NVARCHAR (100),
    [City]                    NVARCHAR (100),
    [County]                  NVARCHAR (100),
    [Amount_Paid]             DECIMAL (19, 2),
    [Downline_Amount]         DECIMAL (19, 2),
    [Premium_Amount]          DECIMAL (19, 2),
    [Comm_Rate]               NVARCHAR (50),
    [Policy_Duration]         NVARCHAR (50),
    [Renewal_Indicator]       NVARCHAR (100),
    [Policy_Type]             NVARCHAR (100),
    [Company_ID]              NVARCHAR (100),
    [Carrier_ID]              NVARCHAR (100),
    [GL_Account]              NVARCHAR (100),
    [CommissionStatementID]   BIGINT,
    [ComulateID]              NVARCHAR (255),
    [StagedDate]              DATETIME,
    [IsDeleted]               BIT,
    [Sub_Carrier]             NVARCHAR (100)
);

insert into #tmp_commissions_transactions
	select
		tx.[CommissionTransactionID],
		tx.[PostingTime],
		tx.[Policy_Number],
		tx.[Contract_Id],
		tx.[Member_Id],
		tx.[Product_Id],
		tx.[Agent_Id],
		tx.[Department_Id],
		tx.[Transaction_Type],
		tx.[Commission_Category],
		tx.[Commission_Date],
		tx.[Policy_Effective_Date],
		tx.[Paid_Through_Date],
		tx.[Term_Date],
		tx.[Policy_State],
		tx.[City],
		tx.[County],
		tx.[Amount_Paid],
		tx.[Downline_Amount],
		tx.[Premium_Amount],
		tx.[Comm_Rate],
		tx.[Policy_Duration],
		tx.[Renewal_Indicator],
		tx.[Policy_Type],
		tx.[Company_ID],
		tx.[Carrier_ID],
		tx.[GL_Account],
		tx.[CommissionStatementID],
		tx.[ComulateID],
		tx.[StagedDate],
		tx.[IsDeleted],
		tx.[Sub_Carrier]
	from [FDM].[Consolidated].[Commissions_Transactions] as tx
	join (
			select
				ct.ComulateID,
				max(ct.CommissionTransactionID) as CommissionTransactionID,
				max(ct.StagedDate) as StagedDate
			from [FDM].[Consolidated].[Commissions_Transactions] as ct
			group by ct.ComulateID
		) as com on
			tx.ComulateID = com.ComulateID
			and (
				tx.StagedDate != com.StagedDate	-- NON-LATEST DUPLICATE RECORDS.
				or (tx.StagedDate = com.StagedDate and tx.CommissionTransactionID < com.CommissionTransactionID)	-- DUPLICATE STAGEDDATE RECORDS.
			)
	order by tx.CommissionTransactionID, tx.ComulateID
;

--select * from #tmp_commissions_transactions as tx;

delete tx
from FDM.Consolidated.Commissions_Transactions as tx
join #tmp_commissions_transactions as tmp on tx.CommissionTransactionID = tmp.CommissionTransactionID
;

ALTER TABLE [FDM].[Consolidated].[Commissions_Transactions]
 ADD  CONSTRAINT [UKC_CT_ComulateIDXX] UNIQUE NONCLUSTERED 
(
	[ComulateID] ASC
)WITH (
	PAD_INDEX = OFF,
	STATISTICS_NORECOMPUTE = OFF,
	SORT_IN_TEMPDB = OFF,
	IGNORE_DUP_KEY = OFF,
	ONLINE = OFF,
	ALLOW_ROW_LOCKS = ON,
	ALLOW_PAGE_LOCKS = ON,
	OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
	) ON [PRIMARY]
;

if object_id('tempdb..#tmp_commissions_transactions') is not null drop table #tmp_commissions_transactions;