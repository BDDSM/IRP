&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	If DocumentStructure.Count() = 0 Then
		For Each BasisDocument In ArrayOfBasisDocuments Do
			ErrorMessage = GetErrorMessage(BasisDocument);
			If ValueIsFilled(ErrorMessage) Then
				ShowMessageBox( , ErrorMessage);
				Return;
			EndIf;
		EndDo;
	EndIf;
	
	For Each FillingData In DocumentStructure Do
		FormParameters = New Structure("FillingValues", FillingData);
		OpenForm("Document.RetailReturnReceipt.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)	
	ArrayOf_RetailSalesReceipt = New Array();
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.RetailSalesReceipt") Then
			ArrayOf_RetailSalesReceipt.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_RetailSalesReceipt(ArrayOf_RetailSalesReceipt));
	
	Return JoinDocumentsStructure(ArrayOfTables, 
	"BasedOn, Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, UnjoinFileds)
	
	ItemList = New ValueTable();
	ItemList.Columns.Add("BasedOn"			, New TypeDescription("String"));
	ItemList.Columns.Add("Company"			, New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Partner"			, New TypeDescription("CatalogRef.Partners"));
	ItemList.Columns.Add("LegalName"		, New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Agreement"		, New TypeDescription("CatalogRef.Agreements"));
	ItemList.Columns.Add("PriceIncludeTax"	, New TypeDescription("Boolean"));
	ItemList.Columns.Add("Currency"			, New TypeDescription("CatalogRef.Currencies"));
	ItemList.Columns.Add("ItemKey"			, New TypeDescription("CatalogRef.ItemKeys"));
	ItemList.Columns.Add("Store"			, New TypeDescription("CatalogRef.Stores"));
	ItemList.Columns.Add("RetailSalesReceipt", New TypeDescription("DocumentRef.RetailSalesReceipt"));
	ItemList.Columns.Add("Unit"				, New TypeDescription("CatalogRef.Units"));
	ItemList.Columns.Add("Quantity"			, New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ItemList.Columns.Add("TaxAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("TotalAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("NetAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("OffersAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("PriceType"		, New TypeDescription("CatalogRef.PriceTypes"));
	ItemList.Columns.Add("Price"			, New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("Key"				, New TypeDescription("UUID"));
	ItemList.Columns.Add("RowKey"			, New TypeDescription("String"));
	
	TaxListMetadataColumns = Metadata.Documents.RetailReturnReceipt.TabularSections.TaxList.Attributes;
	TaxList = New ValueTable();
	TaxList.Columns.Add("Key"					, TaxListMetadataColumns.Key.Type);
	TaxList.Columns.Add("Tax"					, TaxListMetadataColumns.Tax.Type);
	TaxList.Columns.Add("Analytics"				, TaxListMetadataColumns.Analytics.Type);
	TaxList.Columns.Add("TaxRate"				, TaxListMetadataColumns.TaxRate.Type);
	TaxList.Columns.Add("Amount"				, TaxListMetadataColumns.Amount.Type);
	TaxList.Columns.Add("IncludeToTotalAmount"	, TaxListMetadataColumns.IncludeToTotalAmount.Type);
	TaxList.Columns.Add("ManualAmount"			, TaxListMetadataColumns.ManualAmount.Type);
	TaxList.Columns.Add("Ref"					, New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	SpecialOffersMetadataColumns = Metadata.Documents.RetailReturnReceipt.TabularSections.SpecialOffers.Attributes;
	SpecialOffers = New ValueTable();
	SpecialOffers.Columns.Add("Key"		, SpecialOffersMetadataColumns.Key.Type);
	SpecialOffers.Columns.Add("Offer"	, SpecialOffersMetadataColumns.Offer.Type);
	SpecialOffers.Columns.Add("Amount"	, SpecialOffersMetadataColumns.Amount.Type);
	SpecialOffers.Columns.Add("Ref"		, New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	SerialLotNumbersMetadataColumns = Metadata.Documents.RetailReturnReceipt.TabularSections.SerialLotNumbers.Attributes;
	SerialLotNumbers = New ValueTable();
	SerialLotNumbers.Columns.Add("Key"		       , SerialLotNumbersMetadataColumns.Key.Type);
	SerialLotNumbers.Columns.Add("SerialLotNumber" , SerialLotNumbersMetadataColumns.SerialLotNumber.Type);
	SerialLotNumbers.Columns.Add("Quantity"	       , SerialLotNumbersMetadataColumns.Quantity.Type);
	SerialLotNumbers.Columns.Add("Ref"		       , New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	
	For Each TableStructure In ArrayOfTables Do
		For Each Row In TableStructure.ItemList Do
			FillPropertyValues(ItemList.Add(), Row);
		EndDo;
		For Each Row In TableStructure.TaxList Do
			FillPropertyValues(TaxList.Add(), Row);
		EndDo;
		For Each Row In TableStructure.SpecialOffers Do
			FillPropertyValues(SpecialOffers.Add(), Row);
		EndDo;
		For Each Row In TableStructure.SerialLotNumbers Do
			FillPropertyValues(SerialLotNumbers.Add(), Row);
		EndDo;		
	EndDo;
	
	ItemListCopy = ItemList.Copy();
	ItemListCopy.GroupBy(UnjoinFileds);
	
	ArrayOfResults = New Array();
	
	For Each Row In ItemListCopy Do
		Result = New Structure(UnjoinFileds);
		FillPropertyValues(Result, Row);
		
		Result.Insert("ItemList"		 , New Array());
		Result.Insert("TaxList"			 , New Array());
		Result.Insert("SpecialOffers"	 , New Array());
		Result.Insert("SerialLotNumbers" , New Array());
		
		Filter = New Structure(UnjoinFileds);
		FillPropertyValues(Filter, Row);
		
		ArrayOfTaxListFilters = New Array();
		ArrayOfSpecialOffersFilters = New Array();
		ArrayOfSerialLotNumbersFilters = New Array();
		
		ItemListFiltered = ItemList.Copy(Filter);
		For Each RowItemList In ItemListFiltered Do
			NewRow = New Structure();
			
			For Each ColumnItemList In ItemListFiltered.Columns Do
				NewRow.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			
			NewRow.Key = New UUID(RowItemList.RowKey);
			
			ArrayOfTaxListFilters.Add(New Structure("Key", NewRow.Key));
			ArrayOfSpecialOffersFilters.Add(New Structure("Key", NewRow.Key));
			ArrayOfSerialLotNumbersFilters.Add(New Structure("Key", NewRow.Key));
			
			Result.ItemList.Add(NewRow);
		EndDo;
		
		For Each TaxListFilter In ArrayOfTaxListFilters Do
			For Each RowTaxList In TaxList.Copy(TaxListFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key"					, RowTaxList.Key);
				NewRow.Insert("Tax"					, RowTaxList.Tax);
				NewRow.Insert("Analytics"			, RowTaxList.Analytics);
				NewRow.Insert("TaxRate"				, RowTaxList.TaxRate);
				NewRow.Insert("Amount"				, RowTaxList.Amount);
				NewRow.Insert("IncludeToTotalAmount", RowTaxList.IncludeToTotalAmount);
				NewRow.Insert("ManualAmount"		, RowTaxList.ManualAmount);
				Result.TaxList.Add(NewRow);
			EndDo;
		EndDo;
		
		For Each SpecialOffersFilter In ArrayOfSpecialOffersFilters Do
			For Each RowSpecialOffers In SpecialOffers.Copy(SpecialOffersFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key", RowSpecialOffers.Key);
				NewRow.Insert("Offer", RowSpecialOffers.Offer);
				NewRow.Insert("Amount", RowSpecialOffers.Amount);
				Result.SpecialOffers.Add(NewRow);
			EndDo;
		EndDo;
		
		For Each SerialLotNumbersFilter In ArrayOfSerialLotNumbersFilters Do
			For Each RowSerialLotNumbers In SerialLotNumbers.Copy(SerialLotNumbersFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key",             RowSerialLotNumbers.Key);
				NewRow.Insert("SerialLotNumber", RowSerialLotNumbers.SerialLotNumber);
				NewRow.Insert("Quantity"       , RowSerialLotNumbers.Quantity);
				Result.SerialLotNumbers.Add(NewRow);
			EndDo;
		EndDo;
		
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_RetailSalesReceipt(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "RetailSalesReceipt");
EndFunction

&AtServer
Function GetDocumentTable(ArrayOfBasisDocuments, BasedOn)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	&BasedOn AS BasedOn,
		|	Table.SalesInvoice AS RetailSalesReceipt,
		|	Table.ItemKey,
		|	Table.RowKey,
		|	CASE
		|		WHEN Table.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN Table.ItemKey.Unit
		|		ELSE Table.ItemKey.Item.Unit
		|	END AS Unit,
		|	Table.QuantityTurnover AS Quantity,
		|	Table.Company AS Company,
		|	Table.SerialLotNumber
		|FROM
		|	AccumulationRegister.SalesTurnovers.Turnovers(,,, SalesInvoice IN (&ArrayOfBasises)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS Table
		|WHERE
		|	Table.QuantityTurnover > 0";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	Query.SetParameter("BasedOn", BasedOn);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows(QueryTable);
EndFunction

&AtServer
Function ExtractInfoFromOrderRows(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.BasedOn,
		|	QueryTable.RetailSalesReceipt,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
		|	QueryTable.RowKey,
		|	QueryTable.Unit,
		|	QueryTable.Quantity,
		|	QueryTable.SerialLotNumber
		|INTO tmpQueryTableFull
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmpQueryTableFull.BasedOn,
		|	tmpQueryTableFull.RetailSalesReceipt,
		|	tmpQueryTableFull.ItemKey,
		|	tmpQueryTableFull.Key,
		|	tmpQueryTableFull.RowKey,
		|	tmpQueryTableFull.Unit,
		|	SUM(tmpQueryTableFull.Quantity) AS Quantity
		|INTO tmpQueryTable
		|FROM
		|	tmpQueryTableFull AS tmpQueryTableFull
		|GROUP BY
		|	tmpQueryTableFull.BasedOn,
		|	tmpQueryTableFull.RetailSalesReceipt,
		|	tmpQueryTableFull.ItemKey,
		|	tmpQueryTableFull.Key,
		|	tmpQueryTableFull.RowKey,
		|	tmpQueryTableFull.Unit
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	tmpQueryTable.BasedOn AS BasedOn,
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.RetailSalesReceipt AS RetailSalesReceipt,
		|	CAST(tmpQueryTable.RetailSalesReceipt AS Document.RetailSalesReceipt).Partner AS Partner,
		|	CAST(tmpQueryTable.RetailSalesReceipt AS Document.RetailSalesReceipt).LegalName AS LegalName,
		|	CAST(tmpQueryTable.RetailSalesReceipt AS Document.RetailSalesReceipt).Agreement AS Agreement,
		|	CAST(tmpQueryTable.RetailSalesReceipt AS Document.RetailSalesReceipt).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.RetailSalesReceipt AS Document.RetailSalesReceipt).Currency AS Currency,
		|	CAST(tmpQueryTable.RetailSalesReceipt AS Document.RetailSalesReceipt).Company AS Company,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(ItemList.Store, VALUE(Catalog.Stores.EmptyRef)) AS Store
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|		INNER JOIN Document.RetailSalesReceipt.ItemList AS ItemList
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.RetailSalesReceipt = ItemList.Ref
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	TaxList.Ref,
		|	TaxList.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.RetailSalesReceipt.TaxList AS TaxList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.RetailSalesReceipt = TaxList.Ref
		|		AND tmpQueryTable.Key = TaxList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount
		|FROM
		|	Document.RetailSalesReceipt.SpecialOffers AS SpecialOffers
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.RetailSalesReceipt = SpecialOffers.Ref
		|		AND tmpQueryTable.Key = SpecialOffers.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SerialLotNumbers.Ref,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	tmpQueryTableFull.Quantity
		|FROM
		|	Document.RetailSalesReceipt.SerialLotNumbers AS SerialLotNumbers
		|		INNER JOIN tmpQueryTableFull AS tmpQueryTableFull
		|		ON tmpQueryTableFull.RetailSalesReceipt = SerialLotNumbers.Ref
		|		AND tmpQueryTableFull.Key = SerialLotNumbers.Key
		|		AND tmpQueryTableFull.SerialLotNumber = SerialLotNumbers.SerialLotNumber
		|WHERE
		|	tmpQueryTableFull.Quantity > 0";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[2].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[3].Unload();
	QueryTable_SpecialOffers = QueryResults[4].Unload();
	QueryTable_SerialLotNumbers = QueryResults[5].Unload();
	
	Return New Structure("ItemList, TaxList, SpecialOffers, SerialLotNumbers", 
	QueryTable_ItemList, 
	QueryTable_TaxList, 
	QueryTable_SpecialOffers,
	QueryTable_SerialLotNumbers);
EndFunction

#Region Errors

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.RetailSalesReceipt") Then
		ErrorMessage = R().Error_076;
	EndIf;
	
	Return ErrorMessage;
EndFunction

#EndRegion

