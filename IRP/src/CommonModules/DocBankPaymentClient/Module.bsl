
#Region FormEvents

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

Procedure SetAvailability(Object, Form) Export
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange")
		OR Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder") Then
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder")
				And ValueIsFilled(Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		Form.Items.Account.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Account);
		Form.Items.Company.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		Form.Items.Currency.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);
	EndIf;
EndProcedure

#EndRegion

#Region FormItemsEvents

Procedure DateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CurrencyOnChange(Object, Form, Item) Export
	Form.CurrentCurrency = Object.Currency;
	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
	If Object.Currency <> AccountCurrency AND ValueIsFilled(AccountCurrency) Then
		Object.Account = Undefined;
		Form.CurrentAccount = Object.Account;
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#Region ItemTransactionType

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	CleanDataByTransactionType(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CleanDataByTransactionType(Object, Form) Export
	SetTransitAccount(Object, Form);
	
	If Object.PaymentList.Count() = 0 Or Object.TransactionType = Form.CurrentTransactionType Then
		Return;
	EndIf;
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object", Object);
	AdditionalParameters.Insert("Form", Form);
	
	ShowQueryBox(New NotifyDescription("CleanDataByTransactionTypeContinue", ThisObject, AdditionalParameters), 
					R().QuestionToUser_014, QuestionDialogMode.OKCancel);
EndProcedure

Procedure CleanDataByTransactionTypeContinue(Result, AdditionalParameters) Export
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	
	If Result = DialogReturnCode.OK Then
		ArrayAll = New Array();
		ArrayByType = New Array();
		DocBankPaymentServer.FillAttributesByType(AdditionalParameters.Object.TransactionType, ArrayAll, ArrayByType);
		DocumentsClientServer.CleanDataByArray(AdditionalParameters.Object, ArrayAll, ArrayByType);
		For Each Row In Object.PaymentList Do
			Row.PlaningTransactionBasis = Undefined;
		EndDo;
	Else
		Object.TransactionType = Form.CurrentTransactionType;	
		SetTransitAccount(Object, Form);
		Form.SetVisibilityAvailability();	
	EndIf;
	
	Form.CurrentTransactionType = Object.TransactionType;
EndProcedure

Procedure SetTransitAccount(Object, Form) Export
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
		TransitAccount = ServiceSystemServer.GetObjectAttribute(Object.Account, "TransitAccount");	
		Object.TransitAccount = TransitAccount;
		Form.Items.TransitAccount.ReadOnly = ValueIsFilled(Object.TransitAccount);	
	EndIf;
EndProcedure

#EndRegion

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Item);
EndProcedure

Function CompanySettings() Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, CalculateSettings");
	Actions = New Structure();
	Actions.Insert("ChangeAccount"		, "ChangeAccount");
	Settings.Insert("TableName"		, "PaymentList");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Account";
	Settings.FormAttributes = "";
	Settings.CalculateSettings = New Structure();
	Settings.Insert("AccountType", PredefinedValue("Enum.CashAccountTypes.Bank"));
	Return Settings;
EndFunction

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark",
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", 
																	True, DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("Our", True);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ItemAccount

Procedure AccountOnChange(Object, Form, Item = Undefined) Export
	If Form.CurrentAccount = Object.Account Then
		Return;
	EndIf;
	
	Form.CurrentAccount = Object.Account;
	SetTransitAccount(Object, Form);

	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
	If ValueIsFilled(AccountCurrency) Then
		Object.Currency = AccountCurrency;
		Form.CurrentCurrency = Object.Currency;
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export	
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																								PredefinedValue("Enum.CashAccountTypes.Bank"),
																								,
																								DataCompositionComparisonType.Equal));
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Bank"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																							PredefinedValue("Enum.CashAccountTypes.Bank"),
																							ComparisonType.Equal));
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);	
EndProcedure

#EndRegion

#Region ItemPaymentList

Procedure PaymentListOnChange(Object, Form, Item) Export
	For Each Row In Object.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
	SetAvailability(Object, Form);
EndProcedure

Procedure PaymentListOnActivateRow(Object, Form, Item) Export
	Return;
EndProcedure

Procedure PaymentListBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	
	StandardProcessing = False;
	
	TransferParameters = New Structure;
	TransferParameters.Insert("Unmarked", True);
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		TransferParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
	EndIf;
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payee) Then
		TransferParameters.Insert("LegalName", Form.Items.PaymentList.CurrentData.Payee);
	EndIf;
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Agreement) Then
		TransferParameters.Insert("Agreement", Form.Items.PaymentList.CurrentData.Agreement);
	EndIf;
	TransferParameters.Insert("Posted", True);
	
	FilterStructure = JorDocumentsForOutgoingPaymentServer.CreateFilterByParameters(TransferParameters);
	FormParameters = New Structure("CustomFilter", FilterStructure);
	
	NotifyChoiceFormCloseParameters = New Structure();
	NotifyChoiceFormCloseParameters.Insert("Form", Form);
	
	NotifyChoiceFormClose = New NotifyDescription("PaymentListBasisDocumentStartChoiceEnd", 
			ThisObject, NotifyChoiceFormCloseParameters);
	
	OpenForm("DocumentJournal.DocumentsForOutgoingPayment.Form.ChoiceForm",
		FormParameters,
		Item,
		Form.UUID,
		,
		Form.URL,
		NotifyChoiceFormClose,
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Procedure PaymentListBasisDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If ValueIsFilled(Result) Then
		Form = AdditionalParameters.Form;
		Form.Items.PaymentList.CurrentData.BasisDocument = Result;
	EndIf;
EndProcedure

Procedure PaymentListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	If Clone Then
		Return;
	EndIf;
	Cancel = True;
	NewRow = Object.PaymentList.Add();
	Form.Items.PaymentList.CurrentRow = NewRow.GetID();
	Form.Items.PaymentList.ChangeRow();
	PaymentListOnChange(Object, Form, Item);
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData <> Undefined And Not Saas.SeparationUsed() Then
		CurrentData.Partner = DocBankPaymentServer.GetPartnerByLegalName(CurrentData.Payee, CurrentData.Partner);
		PaymentListPartnerOnChange(Object, Form, Item);
	EndIf;
EndProcedure

Procedure PaymentListPlaningTransactionBasisOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If ValueIsFilled(CurrentData.PlaningTransactionBasis) 
		And TypeOf(CurrentData.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
		CashTransferOrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankPayment(CurrentData.PlaningTransactionBasis);
			If Not ValueIsFilled(Object.Account) Then
				Object.Account = CashTransferOrderInfo.Account;
				If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
					Object.TransitAccount = ServiceSystemServer.GetCompositeObjectAttribute(Object.Account, "TransitAccount");
				EndIf;
			EndIf;
			
			If Not ValueIsFilled(Object.Company) Then
				Object.Company = CashTransferOrderInfo.Company;
			EndIf;
			
			If Not ValueIsFilled(Object.Currency) Then
				Object.Currency = CashTransferOrderInfo.Currency;
			EndIf;
			
			ArrayOfPlaningTransactionBasises = New Array();
			ArrayOfPlaningTransactionBasises.Add(CurrentData.PlaningTransactionBasis);
			ArrayOfBalance = DocBankPaymentServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfPlaningTransactionBasises, Object.Ref);
			If ArrayOfBalance.Count() Then
				RowOfBalance = ArrayOfBalance[0];
				CurrentData.Amount = RowOfBalance.Amount;
			EndIf;
	EndIf;
	
	DocumentsClient.PaymentListPlaningTransactionBasisOnChange(Object, Form, Item);
EndProcedure

Procedure TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("OwnerRef", Object.Ref);
	
	ArrayOfSelectedDocuments = New Array();
	For Each Row In Object.PaymentList Do
		ArrayOfSelectedDocuments.Add(Row.PlaningTransactionBasis);
	EndDo;
	OpenSettings.FormParameters.Insert("ArrayOfSelectedDocuments", ArrayOfSelectedDocuments);
		
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	
	// Account
	If ValueIsFilled(Object.Account) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Sender", Object.Account, DataCompositionComparisonType.Equal));
	EndIf;
		
	// Company
	If ValueIsFilled(Object.Company) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
		
	// Currency
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("SendCurrency", Object.Currency, DataCompositionComparisonType.Equal));
	EndIf;

	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", True, DataCompositionComparisonType.Equal));
		
		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	ElsIf Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", False, DataCompositionComparisonType.Equal));
		
		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	EndIf;
EndProcedure

Procedure OnActiveCell(Object, Form, Item, Cancel = Undefined) Export
	If Item.CurrentItem = Undefined Then
		Return;
	EndIf;
	
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	CanModify = True;
	
	If Item.CurrentItem.Name = "PaymentListBasisDocument" Then
	
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
		If Not AgreementInfo.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
			CanModify = False;
		EndIf;
	
		If Cancel <> Undefined Then
			If Not CanModify Then
				Cancel = True;
			EndIf;
		Else
			Item.CurrentItem.ReadOnly = Not CanModify;
		EndIf;	
	EndIf;
EndProcedure

#Region Partner

Procedure PaymentListPartnerOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
		Return;
	EndIf;
	
	If ValueIsFilled(CurrentData.Partner) Then
		CurrentData.Payee = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.Payee);
	
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, CurrentData.Partner);
		AgreementParameters.Insert("Agreement"		, CurrentData.Agreement);
		AgreementParameters.Insert("CurrentDate"	, Object.Date);
		AgreementParameters.Insert("ArrayOfFilters"	, New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		NewAgreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
		If Not CurrentData.Agreement = NewAgreement Then
			CurrentData.Agreement = NewAgreement;
			PaymentListAgreementOnChange(Object, Form);
		EndIf;
	EndIf;
EndProcedure

Procedure PaymentListPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payee) Then
		OpenSettings.FormParameters.Insert("Company", Form.Items.PaymentList.CurrentData.Payee);
		OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Company", Form.Items.PaymentList.CurrentData.Payee);
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payee) Then
		AdditionalParameters.Insert("Company", Form.Items.PaymentList.CurrentData.Payee);
		AdditionalParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, 
				ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region Payee

Procedure PaymentListPayeeOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If ValueIsFilled(CurrentData.Payee) Then
		CurrentData.Partner = DocBankPaymentServer.GetPartnerByLegalName(CurrentData.Payee, CurrentData.Partner);
	EndIf;
EndProcedure

Procedure PaymentListPayeeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Form.Items.PaymentList.CurrentData.Partner);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPayeeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, 
				ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region Agreement

Procedure PaymentListAgreementOnChange(Object, Form, Item = Undefined) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	
	CurrentData.ApArPostingDetail = AgreementInfo.ApArPostingDetail;
	If Not AgreementInfo.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		CurrentData.BasisDocument = Undefined;
	ElsIf Not CurrentData.BasisDocument = Undefined And
		 Not ServiceSystemServer.GetObjectAttribute(CurrentData.BasisDocument, "Agreement") = CurrentData.Agreement Then 
		CurrentData.BasisDocument = Undefined;
	EndIf;
	 
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, 
																	DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
																	PredefinedValue("Enum.AgreementKinds.Standard"), 
																	DataCompositionComparisonType.NotEqual));																
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner"						, CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner"			, True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments"			, True);
	OpenSettings.FormParameters.Insert("EndOfUseDate"					, Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate"	, True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"	, CurrentData.Partner);
	OpenSettings.FillingData.Insert("LegalName"	, CurrentData.Payee);
	OpenSettings.FillingData.Insert("Company"	, Object.Company);
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
																	PredefinedValue("Enum.AgreementKinds.Standard"), 
																	ComparisonType.NotEqual));	
																																	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion

#Region GroupTitle

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

#EndRegion

#Region Common

Procedure PaymentListBasisDocumentOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(CurrentData.BasisDocument) Then
		CurrentData.BasisDocument = Undefined;
	EndIf;

EndProcedure

#EndRegion