﻿#language: en
@tree
@Positive
@Test1
@Group1


Feature: basic check documents and catalogs

As an QA
I want to check opening and closing of documents and catalogs forms

Background:
	Given I launch TestClient opening script or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"


	
Scenario: Open list form "AccessGroups" 

	Given I open "AccessGroups" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessGroups" exception
	And I close current window

Scenario: Open object form "AccessGroups"
	And I close all client application windows
	Given I open "AccessGroups" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessGroups" exception
	And I close current window

	
Scenario: Open list form "AccessProfiles" 
	And I close all client application windows
	Given I open "AccessProfiles" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessProfiles" exception
	And I close current window

Scenario: Open object form "AccessProfiles"
	And I close all client application windows
	Given I open "AccessProfiles" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessProfiles" exception
	And I close current window


	
Scenario: Open list form "AddAttributeAndPropertySets" 
	And I close all client application windows
	Given I open "AddAttributeAndPropertySets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertySets" exception
	And I close current window

Scenario: Open object form "AddAttributeAndPropertySets"
	And I close all client application windows
	Given I open "AddAttributeAndPropertySets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertySets" exception
	And I close current window

	
Scenario: Open list form "AddAttributeAndPropertyValues" 
	And I close all client application windows
	Given I open "AddAttributeAndPropertyValues" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertyValues" exception
	And I close current window

Scenario: Open object form "AddAttributeAndPropertyValues"
	And I close all client application windows
	Given I open "AddAttributeAndPropertyValues" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertyValues" exception
	And I close current window


Scenario: Open list form "Partner terms" 
	And I close all client application windows
	Given I open "Agreements" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partner terms" exception
	And I close current window

Scenario: Open object form "Partner terms"
	And I close all client application windows
	Given I open "Agreements" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partner terms" exception
	And I close current window



	
Scenario: Open list form "BusinessUnits" 
	And I close all client application windows
	Given I open "BusinessUnits" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form BusinessUnits" exception
	And I close current window

Scenario: Open object form "BusinessUnits"
	And I close all client application windows
	Given I open "BusinessUnits" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form BusinessUnits" exception
	And I close current window


	
Scenario: Open list form "CashAccounts" 
	And I close all client application windows
	Given I open "CashAccounts" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CashAccounts" exception
	And I close current window

Scenario: Open object form "CashAccounts"
	And I close all client application windows
	Given I open "CashAccounts" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CashAccounts" exception
	And I close current window


	
Scenario: Open list form "ChequeBonds" 
	And I close all client application windows
	Given I open "ChequeBonds" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ChequeBonds" exception
	And I close current window

Scenario: Open object form "ChequeBonds"
	And I close all client application windows
	Given I open "ChequeBonds" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ChequeBonds" exception
	And I close current window

	
Scenario: Open list form "Companies" 
	And I close all client application windows
	Given I open "Companies" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Companies" exception
	And I close current window

Scenario: Open object form "Companies"
	And I close all client application windows
	Given I open "Companies" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Companies" exception
	And I close current window


	
Scenario: Open list form "ConfigurationMetadata" 
	And I close all client application windows
	Given I open "ConfigurationMetadata" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ConfigurationMetadata" exception
	And I close current window

Scenario: Open object form "ConfigurationMetadata"
	And I close all client application windows
	Given I open "ConfigurationMetadata" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ConfigurationMetadata" exception
	And I close current window

	
Scenario: Open list form "Countries" 
	And I close all client application windows
	Given I open "Countries" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Countries" exception
	And I close current window

Scenario: Open object form "Countries"
	And I close all client application windows
	Given I open "Countries" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Countries" exception
	And I close current window

Scenario: Open list form "Currencies" 
	And I close all client application windows
	Given I open "Currencies" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Currencies" exception
	And I close current window

Scenario: Open object form "Currencies"
	And I close all client application windows
	Given I open "Currencies" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Currencies" exception
	And I close current window

	
Scenario: Open list form "ExpenseAndRevenueTypes" 
	And I close all client application windows
	Given I open "ExpenseAndRevenueTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExpenseAndRevenueTypes" exception
	And I close current window

Scenario: Open object form "ExpenseAndRevenueTypes"
	And I close all client application windows
	Given I open "ExpenseAndRevenueTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExpenseAndRevenueTypes" exception
	And I close current window

	
Scenario: Open list form "ExternalDataProc" 
	And I close all client application windows
	Given I open "ExternalDataProc" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExternalDataProc" exception
	And I close current window

Scenario: Open object form "ExternalDataProc"
	And I close all client application windows
	Given I open "ExternalDataProc" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExternalDataProc" exception
	And I close current window


	
Scenario: Open list form "Files" 
	And I close all client application windows
	Given I open "Files" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Files" exception
	And I close current window

Scenario: Open object form "Files"
	And I close all client application windows
	Given I open "Files" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Files" exception
	And I close current window


Scenario: Open list form "FileStoragesInfo" 
	And I close all client application windows
	Given I open "FileStoragesInfo" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStoragesInfo" exception
	And I close current window

Scenario: Open object form "FileStoragesInfo"
	And I close all client application windows
	Given I open "FileStoragesInfo" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStoragesInfo" exception
	And I close current window

Scenario: Open list form "FileStorageVolumes" 
	And I close all client application windows
	Given I open "FileStorageVolumes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStorageVolumes" exception
	And I close current window

Scenario: Open object form "FileStorageVolumes"
	And I close all client application windows
	Given I open "FileStorageVolumes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStorageVolumes" exception
	And I close current window




	
	
Scenario: Open list form "IDInfoAddresses" 
	And I close all client application windows
	Given I open "IDInfoAddresses" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoAddresses" exception
	And I close current window

Scenario: Open object form "IDInfoAddresses"
	And I close all client application windows
	Given I open "IDInfoAddresses" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoAddresses" exception
	And I close current window




	
	
Scenario: Open list form "IDInfoSets" 
	And I close all client application windows
	Given I open "IDInfoSets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoSets" exception
	And I close current window

Scenario: Open object form "IDInfoSets"
	And I close all client application windows
	Given I open "IDInfoSets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoSets" exception
	And I close current window




	
	
Scenario: Open list form "IntegrationSettings" 
	And I close all client application windows
	Given I open "IntegrationSettings" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IntegrationSettings" exception
	And I close current window

Scenario: Open object form "IntegrationSettings"
	And I close all client application windows
	Given I open "IntegrationSettings" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IntegrationSettings" exception
	And I close current window




	
	
Scenario: Open list form "InterfaceGroups" 
	And I close all client application windows
	Given I open "InterfaceGroups" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form InterfaceGroups" exception
	And I close current window

Scenario: Open object form "InterfaceGroups"
	And I close all client application windows
	Given I open "InterfaceGroups" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form InterfaceGroups" exception
	And I close current window




	
	
Scenario: Open list form "ItemKeys" 
	And I close all client application windows
	Given I open "ItemKeys" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemKeys" exception
	And I close current window

Scenario: Open object form "ItemKeys"
	And I close all client application windows
	Given I open "ItemKeys" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemKeys" exception
	And I close current window




	
	
Scenario: Open list form "Items" 
	And I close all client application windows
	Given I open "Items" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Items" exception
	And I close current window

Scenario: Open object form "Items"
	And I close all client application windows
	Given I open "Items" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Items" exception
	And I close current window




	
	
Scenario: Open list form "ItemSegments" 
	And I close all client application windows
	Given I open "ItemSegments" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemSegments" exception
	And I close current window

Scenario: Open object form "ItemSegments"
	And I close all client application windows
	Given I open "ItemSegments" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemSegments" exception
	And I close current window




	
	
Scenario: Open list form "ItemTypes" 
	And I close all client application windows
	Given I open "ItemTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemTypes" exception
	And I close current window

Scenario: Open object form "ItemTypes"
	And I close all client application windows
	Given I open "ItemTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemTypes" exception
	And I close current window




	
	
Scenario: Open list form "PrintTemplates" 
	And I close all client application windows
	Given I open "PrintTemplates" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PrintTemplates" exception
	And I close current window

Scenario: Open object form "PrintTemplates"
	And I close all client application windows
	Given I open "PrintTemplates" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PrintTemplates" exception
	And I close current window




	
	
Scenario: Open list form "ObjectStatuses" 
	And I close all client application windows
	Given I open "ObjectStatuses" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ObjectStatuses" exception
	And I close current window

Scenario: Open object form "ObjectStatuses"
	And I close all client application windows
	Given I open "ObjectStatuses" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ObjectStatuses" exception
	And I close current window




	
	
Scenario: Open list form "Partners" 
	And I close all client application windows
	Given I open "Partners" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partners" exception
	And I close current window

Scenario: Open object form "Partners"
	And I close all client application windows
	Given I open "Partners" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partners" exception
	And I close current window




	
	
Scenario: Open list form "PartnerSegments" 
	And I close all client application windows
	Given I open "PartnerSegments" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnerSegments" exception
	And I close current window

Scenario: Open object form "PartnerSegments"
	And I close all client application windows
	Given I open "PartnerSegments" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnerSegments" exception
	And I close current window




	
	
Scenario: Open list form "PaymentSchedules" 
	And I close all client application windows
	Given I open "PaymentSchedules" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentSchedules" exception
	And I close current window

Scenario: Open object form "PaymentSchedules"
	And I close all client application windows
	Given I open "PaymentSchedules" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentSchedules" exception
	And I close current window




	
	
Scenario: Open list form "PaymentTypes" 
	And I close all client application windows
	Given I open "PaymentTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentTypes" exception
	And I close current window

Scenario: Open object form "PaymentTypes"
	And I close all client application windows
	Given I open "PaymentTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentTypes" exception
	And I close current window




	
	
Scenario: Open list form "PriceKeys" 
	And I close all client application windows
	Given I open "PriceKeys" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceKeys" exception
	And I close current window

Scenario: Open object form "PriceKeys"
	And I close all client application windows
	Given I open "PriceKeys" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceKeys" exception
	And I close current window




	
	
Scenario: Open list form "PriceTypes" 
	And I close all client application windows
	Given I open "PriceTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceTypes" exception
	And I close current window

Scenario: Open object form "PriceTypes"
	And I close all client application windows
	Given I open "PriceTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceTypes" exception
	And I close current window




	
	
Scenario: Open list form "SerialLotNumbers" 
	And I close all client application windows
	Given I open "SerialLotNumbers" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SerialLotNumbers" exception
	And I close current window

Scenario: Open object form "SerialLotNumbers"
	And I close all client application windows
	Given I open "SerialLotNumbers" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SerialLotNumbers" exception
	And I close current window




	
	
Scenario: Open list form "SpecialOfferRules" 
	And I close all client application windows
	Given I open "SpecialOfferRules" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferRules" exception
	And I close current window

Scenario: Open object form "SpecialOfferRules"
	And I close all client application windows
	Given I open "SpecialOfferRules" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferRules" exception
	And I close current window




	
	
Scenario: Open list form "SpecialOffers" 
	And I close all client application windows
	Given I open "SpecialOffers" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOffers" exception
	And I close current window

Scenario: Open object form "SpecialOffers"
	And I close all client application windows
	Given I open "SpecialOffers" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOffers" exception
	And I close current window




	
	
Scenario: Open list form "SpecialOfferTypes" 
	And I close all client application windows
	Given I open "SpecialOfferTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferTypes" exception
	And I close current window

Scenario: Open object form "SpecialOfferTypes"
	And I close all client application windows
	Given I open "SpecialOfferTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferTypes" exception
	And I close current window




	
	
Scenario: Open list form "Specifications" 
	And I close all client application windows
	Given I open "Specifications" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Specifications" exception
	And I close current window

Scenario: Open object form "Specifications"
	And I close all client application windows
	Given I open "Specifications" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Specifications" exception
	And I close current window




	
	
Scenario: Open list form "Stores" 
	And I close all client application windows
	Given I open "Stores" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Stores" exception
	And I close current window

Scenario: Open object form "Stores"
	And I close all client application windows
	Given I open "Stores" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Stores" exception
	And I close current window




	
	
Scenario: Open list form "TaxAnalytics" 
	And I close all client application windows
	Given I open "TaxAnalytics" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxAnalytics" exception
	And I close current window

Scenario: Open object form "TaxAnalytics"
	And I close all client application windows
	Given I open "TaxAnalytics" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxAnalytics" exception
	And I close current window




	
	
Scenario: Open list form "Tax types" 
	And I close all client application windows
	Given I open "Taxes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Taxes" exception
	And I close current window

Scenario: Open object form "Tax types"
	And I close all client application windows
	Given I open "Taxes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Taxes" exception
	And I close current window




	
	
Scenario: Open list form "TaxRates" 
	And I close all client application windows
	Given I open "TaxRates" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxRates" exception
	And I close current window

Scenario: Open object form "TaxRates"
	And I close all client application windows
	Given I open "TaxRates" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxRates" exception
	And I close current window




	
	
Scenario: Open list form "Units" 
	And I close all client application windows
	Given I open "Units" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Units" exception
	And I close current window

Scenario: Open object form "Units"
	And I close all client application windows
	Given I open "Units" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Units" exception
	And I close current window




	
	
Scenario: Open list form "UserGroups" 
	And I close all client application windows
	Given I open "UserGroups" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form UserGroups" exception
	And I close current window

Scenario: Open object form "UserGroups"
	And I close all client application windows
	Given I open "UserGroups" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form UserGroups" exception
	And I close current window




	
	
Scenario: Open list form "Users" 
	And I close all client application windows
	Given I open "Users" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Users" exception
	And I close current window

Scenario: Open object form "Users"
	And I close all client application windows
	Given I open "Users" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Users" exception
	And I close current window




	
	
Scenario: Open list form "CurrencyMovementSets" 
	And I close all client application windows
	Given I open "CurrencyMovementSets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CurrencyMovementSets" exception
	And I close current window

Scenario: Open object form "CurrencyMovementSets"
	And I close all client application windows
	Given I open "CurrencyMovementSets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CurrencyMovementSets" exception
	And I close current window




	
	
Scenario: Open list form "Extensions" 
	And I close all client application windows
	Given I open "Extensions" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Extensions" exception
	And I close current window

Scenario: Open object form "Extensions"
	And I close all client application windows
	Given I open "Extensions" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Extensions" exception
	And I close current window




	
	
Scenario: Open list form "BankPayment" 
	And I close all client application windows
	Given I open "BankPayment" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form BankPayment" exception
	And I close current window

Scenario: Open object form "BankPayment"
	And I close all client application windows
	Given I open "BankPayment" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form BankPayment" exception
	And I close current window




	
	
Scenario: Open list form "BankReceipt" 
	And I close all client application windows
	Given I open "BankReceipt" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form BankReceipt" exception
	And I close current window

Scenario: Open object form "BankReceipt"
	And I close all client application windows
	Given I open "BankReceipt" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form BankReceipt" exception
	And I close current window




	
	
Scenario: Open list form "Bundling" 
	And I close all client application windows
	Given I open "Bundling" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form Bundling" exception
	And I close current window

Scenario: Open object form "Bundling"
	And I close all client application windows
	Given I open "Bundling" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form Bundling" exception
	And I close current window




	
	
Scenario: Open list form "CashExpense" 
	And I close all client application windows
	Given I open "CashExpense" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form CashExpense" exception
	And I close current window

Scenario: Open object form "CashExpense"
	And I close all client application windows
	Given I open "CashExpense" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form CashExpense" exception
	And I close current window




	
	
Scenario: Open list form "CashPayment" 
	And I close all client application windows
	Given I open "CashPayment" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form CashPayment" exception
	And I close current window

Scenario: Open object form "CashPayment"
	And I close all client application windows
	Given I open "CashPayment" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form CashPayment" exception
	And I close current window




	
	
Scenario: Open list form "CashReceipt" 
	And I close all client application windows
	Given I open "CashReceipt" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form CashReceipt" exception
	And I close current window

Scenario: Open object form "CashReceipt"
	And I close all client application windows
	Given I open "CashReceipt" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form CashReceipt" exception
	And I close current window




	
	
Scenario: Open list form "CashRevenue" 
	And I close all client application windows
	Given I open "CashRevenue" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form CashRevenue" exception
	And I close current window

Scenario: Open object form "CashRevenue"
	And I close all client application windows
	Given I open "CashRevenue" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form CashRevenue" exception
	And I close current window




	
	
Scenario: Open list form "CashTransferOrder" 
	And I close all client application windows
	Given I open "CashTransferOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form CashTransferOrder" exception
	And I close current window

Scenario: Open object form "CashTransferOrder"
	And I close all client application windows
	Given I open "CashTransferOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form CashTransferOrder" exception
	And I close current window




	
	
Scenario: Open list form "ChequeBondTransaction" 
	And I close all client application windows
	Given I open "ChequeBondTransaction" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form ChequeBondTransaction" exception
	And I close current window

Scenario: Open object form "ChequeBondTransaction"
	And I close all client application windows
	Given I open "ChequeBondTransaction" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form ChequeBondTransaction" exception
	And I close current window




	
	
Scenario: Open list form "CreditNote" 
	And I close all client application windows
	Given I open "CreditNote" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form CreditNote" exception
	And I close current window

Scenario: Open object form "CreditNote"
	And I close all client application windows
	Given I open "CreditNote" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form CreditNote" exception
	And I close current window

Scenario: Open list form "DebitNote" 
	And I close all client application windows
	Given I open "DebitNote" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form DebitNote" exception
	And I close current window

Scenario: Open object form "DebitNote"
	And I close all client application windows
	Given I open "DebitNote" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form DebitNote" exception
	And I close current window


	
	
Scenario: Open list form "GoodsReceipt" 
	And I close all client application windows
	Given I open "GoodsReceipt" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form GoodsReceipt" exception
	And I close current window

Scenario: Open object form "GoodsReceipt"
	And I close all client application windows
	Given I open "GoodsReceipt" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form GoodsReceipt" exception
	And I close current window




	
	
Scenario: Open list form "IncomingPaymentOrder" 
	And I close all client application windows
	Given I open "IncomingPaymentOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form IncomingPaymentOrder" exception
	And I close current window

Scenario: Open object form "IncomingPaymentOrder"
	And I close all client application windows
	Given I open "IncomingPaymentOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form IncomingPaymentOrder" exception
	And I close current window




	
	
Scenario: Open list form "InternalSupplyRequest" 
	And I close all client application windows
	Given I open "InternalSupplyRequest" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form InternalSupplyRequest" exception
	And I close current window

Scenario: Open object form "InternalSupplyRequest"
	And I close all client application windows
	Given I open "InternalSupplyRequest" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form InternalSupplyRequest" exception
	And I close current window




	
	
Scenario: Open list form "InventoryTransfer" 
	And I close all client application windows
	Given I open "InventoryTransfer" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form InventoryTransfer" exception
	And I close current window

Scenario: Open object form "InventoryTransfer"
	And I close all client application windows
	Given I open "InventoryTransfer" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form InventoryTransfer" exception
	And I close current window




	
	
Scenario: Open list form "InventoryTransferOrder" 
	And I close all client application windows
	Given I open "InventoryTransferOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form InventoryTransferOrder" exception
	And I close current window

Scenario: Open object form "InventoryTransferOrder"
	And I close all client application windows
	Given I open "InventoryTransferOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form InventoryTransferOrder" exception
	And I close current window




	
	
Scenario: Open list form "InvoiceMatch" 
	And I close all client application windows
	Given I open "InvoiceMatch" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form InvoiceMatch" exception
	And I close current window

Scenario: Open object form "InvoiceMatch"
	And I close all client application windows
	Given I open "InvoiceMatch" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form InvoiceMatch" exception
	And I close current window




	
	
Scenario: Open list form "Labeling" 
	And I close all client application windows
	Given I open "Labeling" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form Labeling" exception
	And I close current window

Scenario: Open object form "Labeling"
	And I close all client application windows
	Given I open "Labeling" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form Labeling" exception
	And I close current window




	
	
Scenario: Open list form "OpeningEntry" 
	And I close all client application windows
	Given I open "OpeningEntry" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form OpeningEntry" exception
	And I close current window

Scenario: Open object form "OpeningEntry"
	And I close all client application windows
	Given I open "OpeningEntry" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form OpeningEntry" exception
	And I close current window




	
	
Scenario: Open list form "OutgoingPaymentOrder" 
	And I close all client application windows
	Given I open "OutgoingPaymentOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form OutgoingPaymentOrder" exception
	And I close current window

Scenario: Open object form "OutgoingPaymentOrder"
	And I close all client application windows
	Given I open "OutgoingPaymentOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form OutgoingPaymentOrder" exception
	And I close current window




	
	
Scenario: Open list form "PhysicalCountByLocation" 
	And I close all client application windows
	Given I open "PhysicalCountByLocation" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PhysicalCountByLocation" exception
	And I close current window

Scenario: Open object form "PhysicalCountByLocation"
	And I close all client application windows
	Given I open "PhysicalCountByLocation" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PhysicalCountByLocation" exception
	And I close current window




	
	
Scenario: Open list form "PriceList" 
	And I close all client application windows
	Given I open "PriceList" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PriceList" exception
	And I close current window

Scenario: Open object form "PriceList"
	And I close all client application windows
	Given I open "PriceList" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PriceList" exception
	And I close current window




	
	
Scenario: Open list form "PurchaseInvoice" 
	And I close all client application windows
	Given I open "PurchaseInvoice" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseInvoice" exception
	And I close current window

Scenario: Open object form "PurchaseInvoice"
	And I close all client application windows
	Given I open "PurchaseInvoice" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseInvoice" exception
	And I close current window




	
	
Scenario: Open list form "PurchaseOrder" 
	And I close all client application windows
	Given I open "PurchaseOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseOrder" exception
	And I close current window

Scenario: Open object form "PurchaseOrder"
	And I close all client application windows
	Given I open "PurchaseOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseOrder" exception
	And I close current window




	
	
Scenario: Open list form "PurchaseReturn" 
	And I close all client application windows
	Given I open "PurchaseReturn" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseReturn" exception
	And I close current window

Scenario: Open object form "PurchaseReturn"
	And I close all client application windows
	Given I open "PurchaseReturn" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseReturn" exception
	And I close current window




	
	
Scenario: Open list form "PurchaseReturnOrder" 
	And I close all client application windows
	Given I open "PurchaseReturnOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseReturnOrder" exception
	And I close current window

Scenario: Open object form "PurchaseReturnOrder"
	And I close all client application windows
	Given I open "PurchaseReturnOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PurchaseReturnOrder" exception
	And I close current window




	
	
Scenario: Open list form "ReconciliationStatement" 
	And I close all client application windows
	Given I open "ReconciliationStatement" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form ReconciliationStatement" exception
	And I close current window

Scenario: Open object form "ReconciliationStatement"
	And I close all client application windows
	Given I open "ReconciliationStatement" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form ReconciliationStatement" exception
	And I close current window




	
	
Scenario: Open list form "SalesInvoice" 
	And I close all client application windows
	Given I open "SalesInvoice" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesInvoice" exception
	And I close current window

Scenario: Open object form "SalesInvoice"
	And I close all client application windows
	Given I open "SalesInvoice" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesInvoice" exception
	And I close current window




	
	
Scenario: Open list form "SalesOrder" 
	And I close all client application windows
	Given I open "SalesOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesOrder" exception
	And I close current window

Scenario: Open object form "SalesOrder"
	And I close all client application windows
	Given I open "SalesOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesOrder" exception
	And I close current window




	
	
Scenario: Open list form "SalesReturn" 
	And I close all client application windows
	Given I open "SalesReturn" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesReturn" exception
	And I close current window

Scenario: Open object form "SalesReturn"
	And I close all client application windows
	Given I open "SalesReturn" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesReturn" exception
	And I close current window




	
	
Scenario: Open list form "SalesReturnOrder" 
	And I close all client application windows
	Given I open "SalesReturnOrder" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesReturnOrder" exception
	And I close current window

Scenario: Open object form "SalesReturnOrder"
	And I close all client application windows
	Given I open "SalesReturnOrder" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form SalesReturnOrder" exception
	And I close current window
	
Scenario: Open list form "ShipmentConfirmation" 
	And I close all client application windows
	Given I open "ShipmentConfirmation" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form ShipmentConfirmation" exception
	And I close current window

Scenario: Open object form "ShipmentConfirmation"
	And I close all client application windows
	Given I open "ShipmentConfirmation" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form ShipmentConfirmation" exception
	And I close current window
	
Scenario: Open list form "Unbundling" 
	And I close all client application windows
	Given I open "Unbundling" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form Unbundling" exception
	And I close current window

Scenario: Open object form "Unbundling"
	And I close all client application windows
	Given I open "Unbundling" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form Unbundling" exception
	And I close current window

Scenario: Open list form "StockAdjustmentAsWriteOff" 
	And I close all client application windows
	Given I open "StockAdjustmentAsWriteOff" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form StockAdjustmentAsWriteOff" exception
	And I close current window

Scenario: Open object form "StockAdjustmentAsWriteOff"
	And I close all client application windows
	Given I open "StockAdjustmentAsWriteOff" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form StockAdjustmentAsWriteOff" exception
	And I close current window




	
	
Scenario: Open list form "StockAdjustmentAsSurplus" 
	And I close all client application windows
	Given I open "StockAdjustmentAsSurplus" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form StockAdjustmentAsSurplus" exception
	And I close current window

Scenario: Open object form "StockAdjustmentAsSurplus"
	And I close all client application windows
	Given I open "StockAdjustmentAsSurplus" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form StockAdjustmentAsSurplus" exception
	And I close current window




	
	
Scenario: Open list form "PhysicalInventory" 
	And I close all client application windows
	Given I open "PhysicalInventory" document default form
	If the warning is displayed then
		Then I raise "Failed to open document form PhysicalInventory" exception
	And I close current window

Scenario: Open object form "PhysicalInventory"
	And I close all client application windows
	Given I open "PhysicalInventory" document main form
	If the warning is displayed then
		Then I raise "Failed to open document form PhysicalInventory" exception
	And I close current window
