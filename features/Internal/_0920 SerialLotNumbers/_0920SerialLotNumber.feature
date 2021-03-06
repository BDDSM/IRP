﻿#language: en
@tree
@Positive
@Group13

Feature: check that the item marked for deletion is not displayed


As a developer
I want to hide the items marked for deletion from the product selection form.
So the user can't select it in the sales and purchase documents


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _092001 checkbox Use serial lot number in the Item type
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Check saving
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "Yes"
	And I close all client application windows
	
Scenario: _092002 check serial lot number in the Retail sales receipt
	* Create Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Retail customer' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail partner term' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Store 01'    | 'Store 01'  |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		And I save the window as "$$RetailSalesReceipt092002$$"
		And I save the value of the field named "Number" as "$$NumberRetailSalesReceipt092002$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                     | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                                    | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '68,49'  |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '111,30' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$RetailSalesReceipt092002$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009998" text in "Serial number" field
				And I click "Save and close" button
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009998' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click "Post" button
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009998'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                     | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                                    | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '68,49'  |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '111,30' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '800,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '800,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '136,99' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '800,00' |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$RetailSalesReceipt092002$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that doesn't use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change item that doesn't use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	And I close all client application windows
	
	
Scenario: _092003 check serial lot number in the Retail return receipt
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			|'Number'|
			|'$$NumberRetailSalesReceipt092002$$'|
		And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
	* Check filling in serial lot number
		And "ItemList" table contains lines
			| 'Serial lot numbers'             | 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Retail sales receipt'         |
			| '99098809009999; 99098809009998' | '400,00' | 'Trousers' | '38/Yellow' | '3,000' | 'pcs'  | '$$RetailSalesReceipt092002$$' |
			| ''                               | '650,00' | 'Boots'    | '38/18SD'   | '1,000' | 'pcs'  | '$$RetailSalesReceipt092002$$' |
			| ''                               | '700,00' | 'Boots'    | '37/18SD'   | '1,000' | 'pcs'  | '$$RetailSalesReceipt092002$$' |
		And "SerialLotNumbersTree" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Serial lot number' | 'Item key quantity' |
			| 'Trousers' | '3,000'    | '38/Yellow' | ''                  | '3,000'             |
			| ''         | '1,000'    | ''          | '99098809009999'    | ''                  |
			| ''         | '2,000'    | ''          | '99098809009998'    | ''                  |
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail return receipt and check movements in the register Sales turnovers
		And I click "Post" button
		And I save the window as "$$RetailReturnReceipt092003$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                      | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                | 'Item key'  | 'Serial lot number' | 'Quantity'  | 'Amount' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-400,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-400,00' |
			| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-68,49'  |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-650,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-650,00' |
			| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-111,30' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-400,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-650,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-800,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-800,00' |
			| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-136,99' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-800,00' |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$RetailReturnReceipt092003$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '3,000' |
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Quantity [1] does not match the quantity [3] by serial/lot numbers" substring will appear in "30" seconds
		* Delete 1 serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '1,000'    | '99098809009999'    |
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersContextMenuDelete"
			And I click "Ok" button
		And I click "Post" button
		Then I wait that in user messages the "Quantity [1] does not match the quantity [2] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '2,000'    | '99098809009998'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                      | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount'  | 'Net amount' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-400,00' | '-338,98'    |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-400,00' | '-338,98'    |
		| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-68,49'  | '-58,04'     |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' | '-550,85'    |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' | '-550,85'    |
		| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-111,30' | '-94,32'     |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' | '-593,22'    |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' | '-593,22'    |
		| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-119,86' | '-101,58'    |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-400,00' | '-338,98'    |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' | '-550,85'    |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' | '-593,22'    |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$RetailReturnReceipt092003$$" window
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that doesn't use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change item that doesn't use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	And I close all client application windows


	
Scenario: _092004 check serial lot number in the Sales invoice
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Kalipso' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Kalipso' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Store 01'    | 'Store 01'  |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009910" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009910' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		And I save the window as "$$SalesInvoice092004$$"
		And I save the value of the field named "Number" as "$$NumberSalesInvoice092004$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'               | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '68,49'  |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '111,30' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$SalesInvoice092004$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009911" text in "Serial number" field
				And I click "Save and close" button
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009911' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click "Post" button
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009911'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'               | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '68,49'  |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '111,30' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '800,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '800,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '136,99' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '800,00' |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$SalesInvoice092004$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that doesn't use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change item that doesn't use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	And I close all client application windows

Scenario: _092005 check serial lot number in the Sales return
	* Create Sales return
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			|'Number'|
			|'$$NumberSalesInvoice092004$$'|
		And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check filling in serial lot number
		And "ItemList" table contains lines
			| 'Serial lot numbers'             | 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Sales invoice'          |
			| '99098809009910; 99098809009911' | '400,00' | 'Trousers' | '38/Yellow' | '3,000' | 'pcs'  | '$$SalesInvoice092004$$' |
			| ''                               | '650,00' | 'Boots'    | '38/18SD'   | '1,000' | 'pcs'  | '$$SalesInvoice092004$$' |
			| ''                               | '700,00' | 'Boots'    | '37/18SD'   | '1,000' | 'pcs'  | '$$SalesInvoice092004$$' |
		And "SerialLotNumbersTree" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Serial lot number' | 'Item key quantity' |
			| 'Trousers' | '3,000'    | '38/Yellow' | ''                  | '3,000'             |
			| ''         | '1,000'    | ''          | '99098809009910'    | ''                  |
			| ''         | '2,000'    | ''          | '99098809009911'    | ''                  |
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail return receipt and check movements in the register Sales turnovers
		And I click "Post" button
		And I save the window as "$$SalesReturn092005$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'              | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount'  |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-400,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-400,00' |
			| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-68,49'  |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
			| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-111,30' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-400,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-800,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-800,00' |
			| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-136,99' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-800,00' |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$SalesReturn092005$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '3,000' |
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Quantity [1] does not match the quantity [3] by serial/lot numbers" substring will appear in "30" seconds
		* Delete 1 serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '1,000'    | '99098809009910'    |
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersContextMenuDelete"
			And I click "Ok" button
		And I click "Post" button
		Then I wait that in user messages the "Quantity [1] does not match the quantity [2] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '2,000'    | '99098809009911'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount'  | 'Net amount' |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   | '-400,00' | '-338,98'    |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   | '-400,00' | '-338,98'    |
		| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   | '-68,49'  | '-58,04'     |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' | '-550,85'    |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' | '-550,85'    |
		| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-111,30' | '-94,32'     |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' | '-593,22'    |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' | '-593,22'    |
		| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   | '-119,86' | '-101,58'    |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   | '-400,00' | '-338,98'    |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' | '-550,85'    |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' | '-593,22'    |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$SalesReturn092005$$" window
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that doesn't use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change item that doesn't use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	And I close all client application windows


Scenario: _092009 check choice form Serial Lot number
	* Create Serial lot number
		Given I open hyperlink "e1cib/list/Catalog.SerialLotNumbers"
		* For item key (Dree M/Brown)
			And I click the button named "FormCreate"
			And I input "099995" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item key' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item key (Dree M/White)
			And I click the button named "FormCreate"
			And I input "89999" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item key' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item (Dress)
			And I click the button named "FormCreate"
			And I input "05" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Dress' |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item (Boots)
			And I click the button named "FormCreate"
			And I input "06" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Boots' |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item type (Clothes)
			And I click the button named "FormCreate"
			And I input "07" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Clothes' |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item type (Shoes)
			And I click the button named "FormCreate"
			And I input "08" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Shoes' |
			And I select current line in "List" table
			And I click "Save and close" button
		* Without owner
			And I click the button named "FormCreate"
			And I input "10" text in "Serial number" field
			And I click "Save and close" button
		* Inactive
			And I click the button named "FormCreate"
			And I input "11" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Clothes' |
			And I select current line in "List" table
			And I set checkbox "Inactive"
			And I click "Save and close" button
	* Check box Use serial lot number for shoes
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Сheck choice form
		* Create Sales invoice
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
		* Add items (first item with serial lot number, second - without serial lot number)
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '38/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I select current line in "List" table
		* Сheck choice form Serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '1,000' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '05'             | 'Dress'     |
			| '8999'           | 'M/White'   |
			| '8999'           | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '07'             | 'Clothes'   |
			| '10'             | ''          |
			And I close "Item serial/lot numbers" window
			And I close "Edit list of serial lot numbers" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Boots'    | '38/18SD' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '8999'           | 'M/White'   |
			| '8999'           | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			And I close "Item serial/lot numbers" window
			And I close "Edit list of serial lot numbers" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Dress'    | 'M/White' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '8999'           | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '89999'          | 'M/White'   |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			And I close "Item serial/lot numbers" window
			And I close "Edit list of serial lot numbers" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Dress'    | 'M/Brown' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '099995'         | 'M/Brown'   |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '10'             | ''          |
			And I close "Item serial/lot numbers" window
			And I close "Edit list of serial lot numbers" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Dress'    | 'L/Green' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			| '099995'         | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '10'             | ''          |
			And I close "Item serial/lot numbers" window
			And I close "Edit list of serial lot numbers" window
		And I close all client application windows

Scenario: _092010 uncheck checkbox Use serial lot number in the Item type
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I remove checkbox "Use serial lot number"
		And I click "Save and close" button	
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'     |
		And I select current line in "List" table
		And I remove checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Check saving
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "No"
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "No"
	And I close all client application windows




		







	