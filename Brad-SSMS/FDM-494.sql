Select * from FDM.Consolidated.Bank_Statements as BS WITH(NOLOCK)
where Bank_Name = 'BOA'
and Src_File_Name like '%BOA CashPro%'
and Bank_Account_Number != 'X1935'
;

update FDM.Consolidated.Bank_Statements
set bank_account_number = 'X1935'
where bank_account_number != 'X1935'
and Bank_Name = 'BOA'
and Src_File_Name like '%BOA CashPro%'
;