﻿#language: en
@tree
@Positive
@Group9
Feature: write off expenses and record income directly to/from the account

As an accountant
I want to create Cash revenue and Cash expence documents
For write off expenses and record income directly to/from the account

Background:
	Given I launch TestClient opening script or connect the existing one

# Cash revenue

Scenario: check tax calculation in the document Cash revenue
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Tax calculation check
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit'      | 'Revenue type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '100,00'     | 'Accountants office' | 'Fuel'         | '118,00'       | 'TRY'      | '18%' | '18,00'      |
		And "TaxTree" table contains lines
			| 'Tax' | 'Tax rate' | 'Currency' | 'Business unit'      | 'Amount' | 'Revenue type' | 'Manual amount' |
			| 'VAT' | ''         | 'TRY'      | ''                   | '18,00'  | ''             | '18,00'         |
			| 'VAT' | '18%'      | 'TRY'      | 'Accountants office' | '18,00'  | 'Fuel'         | '18,00'         |
		And I close all client application windows

Scenario: check movements of the document Cash revenue
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Change the document number
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
		And I click "Post" button
	* Check movements
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| 'Cash revenue 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en description is empty' | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Revenues turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
		| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Revenue type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Multi currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
		| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en description is empty' | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en description is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		And I close all client application windows
	* Clear movements and check that there is no movement on the registers
		* Clear movements Cash revenue 1
			Given I open hyperlink "e1cib/list/Document.CashRevenue"
			And I go to line in "List" table
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.TaxesTurnovers"
			And "List" table does not contain lines
			| 'Recorder'        |
			| 'Cash revenue 1*' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.RevenuesTurnovers"
			And "List" table does not contain lines
			| 'Recorder'        |
			| 'Cash revenue 1*' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
			| 'Recorder'        |
			| 'Cash revenue 1*' |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Post document
			Given I open hyperlink "e1cib/list/Document.CashRevenue"
			And I go to line in "List" table
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Cash revenue 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
			| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en description is empty' | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash revenue 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Revenues turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
			| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Revenue type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Multi currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
			| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en description is empty' | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Receipt'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en description is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Receipt'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			And I close all client application windows





Scenario: check the unavailability of currency selection in Cash revenue when it is strongly fixed in the Account
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Currency field unavailability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		When I Check the steps for Exception
			|'And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table'|

Scenario: check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №1' |
		And I select current line in "List" table
	* Check the Currency field availability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And in "PaymentList" table "Currency" attribute is available


# Cash expence

Scenario: check tax calculation in the document Cash expense
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Tax calculation check
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '100,00'     | 'Accountants office' | 'Fuel'         | '118,00'       | 'TRY'      | '18%' | '18,00'      |
		And "TaxTree" table contains lines
			| 'Tax' | 'Tax rate' | 'Currency' | 'Business unit'      | 'Amount' | 'Expense type' | 'Manual amount' |
			| 'VAT' | ''         | 'TRY'      | ''                   | '18,00'  | ''             | '18,00'         |
			| 'VAT' | '18%'      | 'TRY'      | 'Accountants office' | '18,00'  | 'Fuel'         | '18,00'         |
		And I close all client application windows

Scenario: check movements of the document Cash expense
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Fuel'        |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Change the document number
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
		And I click "Post" button
	* Check movements
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| 'Cash expense 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Expenses turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
		| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Expense type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Multi currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
		| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en description is empty' | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en description is empty' | 'No'                   |
		| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
		| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en description is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
		And I close all client application windows
	* Clear movements and check that there is no movement on the registers
		* Clear movements Cash expense 1
			Given I open hyperlink "e1cib/list/Document.CashExpense"
			And I go to line in "List" table
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.TaxesTurnovers"
			And "List" table does not contain lines
				| 'Recorder'        |
				| 'Cash expense 1*' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.RevenuesTurnovers"
			And "List" table does not contain lines
				| 'Recorder'        |
				| 'Cash expense 1*' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
				| 'Recorder'        |
				| 'Cash expense 1*' |
			And I close all client application windows
	* Posting the document back and check movements
		* Post document
			Given I open hyperlink "e1cib/list/Document.CashExpense"
			And I go to line in "List" table
				| 'Account'           | 'Company'      | 'Number' |
				| 'Bank account, TRY' | 'Main Company' | '1'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Cash expense 1*'                | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Document registrations records' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Expenses turnovers"' | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | 'Dimensions'    | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | 'Attributes'           | ''         | ''                         | ''                     |
			| ''                               | ''            | 'Amount'    | 'Company'       | 'Business unit'      | 'Expense type'      | 'Item key' | 'Currency'                 | 'Additional analytic'  | 'Multi currency movement type'   | 'Deferred calculation' | ''         | ''                         | ''                     |
			| ''                               | '*'           | '17,12'     | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'USD'                      | ''                     | 'Reporting currency'       | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'en description is empty' | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | '*'           | '100'       | 'Main Company'  | 'Accountants office' | 'Fuel'              | ''         | 'TRY'                      | ''                     | 'Local currency'           | 'No'                   | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Period'      | 'Resources' | ''              | ''                   | 'Dimensions'        | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | 'Attributes'           |
			| ''                               | ''            | 'Amount'    | 'Manual amount' | 'Net amount'         | 'Document'          | 'Tax'      | 'Analytics'                | 'Tax rate'             | 'Include to total amount'  | 'Row key'              | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                               | '*'           | '3,08'      | '3,08'          | '17,12'              | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'en description is empty' | 'No'                   |
			| ''                               | '*'           | '18'        | '18'            | '100'                | 'Cash expense 1*'   | 'VAT'      | ''                         | '18%'                  | 'Yes'                      | '*'                    | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                               | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'    | ''            | ''          | ''              | ''                   | ''                  | ''         | ''                         | ''                     | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'         | ''                  | ''         | ''                         | 'Attributes'           | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | ''            | ''          | 'Amount'        | 'Company'            | 'Account'           | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Expense'     | '*'         | '20,21'         | 'Main Company'       | 'Bank account, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'en description is empty' | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			| ''                               | 'Expense'     | '*'         | '118'           | 'Main Company'       | 'Bank account, TRY' | 'TRY'      | 'Local currency'           | 'No'                   | ''                         | ''                     | ''         | ''                         | ''                     |
			And I close all client application windows



Scenario: check the unavailability of currency selection in Cash expense when it is strongly fixed in the Account
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Currency field unavailability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		When I Check the steps for Exception
			|'And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table'|


Scenario: check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №1' |
		And I select current line in "List" table
	* Check the Currency field availability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And in "PaymentList" table "Currency" attribute is available
	

