#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	RetailReturnReceiptItemList.Ref.Company AS Company,
		|	RetailReturnReceiptItemList.Store AS Store,
		|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
		|	RetailReturnReceiptItemList.Ref AS SalesReturn,
		|	SUM(RetailReturnReceiptItemList.Quantity) AS Quantity,
		|	SUM(RetailReturnReceiptItemList.TotalAmount) AS TotalAmount,
		|	RetailReturnReceiptItemList.Ref.Partner AS Partner,
		|	RetailReturnReceiptItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN RetailReturnReceiptItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND RetailReturnReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN RetailReturnReceiptItemList.Ref.Agreement.StandardAgreement
		|		ELSE RetailReturnReceiptItemList.Ref.Agreement
		|	END AS Agreement,
		|	ISNULL(RetailReturnReceiptItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	0 AS BasisQuantity,
		|	RetailReturnReceiptItemList.Unit,
		|	RetailReturnReceiptItemList.ItemKey.Item.Unit AS ItemUnit,
		|	RetailReturnReceiptItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	RetailReturnReceiptItemList.ItemKey.Item AS Item,
		|	RetailReturnReceiptItemList.Ref.Date AS Period,
		|	RetailReturnReceiptItemList.RetailSalesReceipt AS RetailSalesReceipt,
		|	RetailReturnReceiptItemList.Key AS RowKey,
		|	RetailReturnReceiptItemList.Ref.IsOpeningEntry AS IsOpeningEntry
		|FROM
		|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
		|WHERE
		|	RetailReturnReceiptItemList.Ref = &Ref
		|GROUP BY
		|	RetailReturnReceiptItemList.Ref.Company,
		|	RetailReturnReceiptItemList.Ref.Partner,
		|	RetailReturnReceiptItemList.Ref.LegalName,
		|	CASE
		|		WHEN RetailReturnReceiptItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND RetailReturnReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN RetailReturnReceiptItemList.Ref.Agreement.StandardAgreement
		|		ELSE RetailReturnReceiptItemList.Ref.Agreement
		|	END,
		|	ISNULL(RetailReturnReceiptItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	RetailReturnReceiptItemList.Store,
		|	RetailReturnReceiptItemList.ItemKey,
		|	RetailReturnReceiptItemList.Ref,
		|	RetailReturnReceiptItemList.Unit,
		|	RetailReturnReceiptItemList.ItemKey.Item.Unit,
		|	RetailReturnReceiptItemList.ItemKey.Unit,
		|	RetailReturnReceiptItemList.ItemKey.Item,
		|	RetailReturnReceiptItemList.Ref.Date,
		|	VALUE(Catalog.Units.EmptyRef),
		|	RetailReturnReceiptItemList.RetailSalesReceipt,
		|	RetailReturnReceiptItemList.Key,
		|	RetailReturnReceiptItemList.Ref.IsOpeningEntry";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.SalesReturn AS ReceiptBasis,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RetailSalesReceipt AS RetailSalesReceipt,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.IsOpeningEntry AS IsOpeningEntry
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 2//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 3//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.RetailSalesReceipt,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RetailSalesReceipt,
		|	tmp.RowKey
		|";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("StockBalance", QueryResults[1].Unload());
	Tables.Insert("StockReservation", QueryResults[2].Unload());
	Tables.Insert("SalesReturnTurnovers", QueryResults[3].Unload());
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextRetailReturnReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultPaymentList.Unload();
	Tables.Insert("AccountBalance", QueryTablePaymentList);
	
	QuerySalesTurnovers = New Query();
	QuerySalesTurnovers.Text = GetQueryTextRetailReturnReceiptSalesTurnovers();
	QuerySalesTurnovers.SetParameter("Ref", Ref);
	QueryResultSalesTurnovers = QuerySalesTurnovers.Execute();
	QueryTableSalesTurnovers = QueryResultSalesTurnovers.Unload();
	Tables.Insert("SalesTurnovers", QueryTableSalesTurnovers);
			
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function GetQueryTextRetailReturnReceiptSalesTurnovers()
	Return "SELECT
	|	RetailReturnReceiptItemList.Ref.Company AS Company,
	|	RetailReturnReceiptItemList.Ref.Currency AS Currency,
	|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailReturnReceiptItemList.Quantity) AS Quantity,
	|	SUM(ISNULL(RetailReturnReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailReturnReceiptItemList.Ref.Date AS Period,
	|	RetailReturnReceiptItemList.RetailSalesReceipt AS RetailSalesReceipt,
	|	SUM(RetailReturnReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailReturnReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailReturnReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailReturnReceiptItemList.Key AS RowKey,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber
	|INTO tmp
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|		LEFT JOIN Document.RetailReturnReceipt.SerialLotNumbers AS RetailReturnReceiptSerialLotNumbers
	|		ON RetailReturnReceiptItemList.Key = RetailReturnReceiptSerialLotNumbers.Key
	|		AND RetailReturnReceiptItemList.Ref = RetailReturnReceiptSerialLotNumbers.Ref
	|		AND RetailReturnReceiptItemList.Ref = &Ref
	|		AND RetailReturnReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptItemList.Ref.Company,
	|	RetailReturnReceiptItemList.Ref.Currency,
	|	RetailReturnReceiptItemList.ItemKey,
	|	RetailReturnReceiptItemList.Ref.Date,
	|	RetailReturnReceiptItemList.Ref,
	|	RetailReturnReceiptItemList.Key,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber,
	|	RetailReturnReceiptItemList.RetailSalesReceipt
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.Currency AS Currency,
	|	tmp.ItemKey AS ItemKey,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN tmp.Quantity
	|		ELSE tmp.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmp.Period AS Period,
	|	tmp.RetailSalesReceipt AS RetailSalesReceipt,
	|	tmp.RowKey AS RowKey,
	|	tmp.SerialLotNumber AS SerialLotNumber,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.OffersAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.OffersAmount
	|	END AS OffersAmount
	|FROM
	|	tmp AS tmp";
EndFunction	

Function GetQueryTextRetailReturnReceiptPaymentList()
	Return "SELECT
	|	RetailReturnReceiptPayments.Ref.Company,
	|	RetailReturnReceiptPayments.Ref.Currency,
	|	RetailReturnReceiptPayments.Account,
	|	SUM(RetailReturnReceiptPayments.Amount) AS Amount,
	|	RetailReturnReceiptPayments.Ref.Date AS Period
	|FROM
	|	Document.RetailReturnReceipt.Payments AS RetailReturnReceiptPayments
	|WHERE
	|	RetailReturnReceiptPayments.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptPayments.Ref.Company,
	|	RetailReturnReceiptPayments.Ref.Currency,
	|	RetailReturnReceiptPayments.Account,
	|	RetailReturnReceiptPayments.Ref.Date";
EndFunction	

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
		
	// SalesTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("SalesInvoice", "RetailSalesReceipt");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.SalesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.SalesTurnovers));
	
	// SalesReturnTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("SalesInvoice", "RetailSalesReceipt");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.SalesReturnTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.SalesReturnTurnovers));
	
	// StockBalance	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.StockBalance));
	
	// StockReservation	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
		New Structure("Fields, Data", Fields, DocumentDataTables.StockReservation));
	
	// AccountBalance
	AccountBalance = AccumulationRegisters.AccountBalance.GetLockFields(DocumentDataTables.AccountBalance);
	DataMapWithLockFields.Insert(AccountBalance.RegisterName, AccountBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// SalesTurnovers
	Parameters.DocumentDataTables.SalesTurnovers.Columns.RetailSalesReceipt.Name = "SalesInvoice";
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesTurnovers,
			Parameters.IsReposting));
	
	// SalesReturnTurnovers
	Parameters.DocumentDataTables.SalesReturnTurnovers.Columns.RetailSalesReceipt.Name = "SalesInvoice";
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesReturnTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesReturnTurnovers,
			Parameters.IsReposting));
		
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockBalance,
			Parameters.IsReposting));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockReservation,
			Parameters.IsReposting));
		
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.AccountBalance));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

