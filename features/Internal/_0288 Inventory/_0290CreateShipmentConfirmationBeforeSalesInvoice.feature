﻿#language: en
@tree
@Positive
@Group7
Feature: posting shipment confirmation before Sales invoice

As a sales manager
I want to create Shipment confirmation before Sales invoice
To sell a product when customer first receives items and then the documents arrive at him.


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029001 partner setup Shipment confirmation before Sales invoice
	* Check partner setup Shipment confirmation before Sales invoice
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| Description |
			| Kalipso   |
		And I select current line in "List" table
		Then the form attribute named "ShipmentConfirmationsBeforeSalesInvoice" became equal to "No"
		And I set checkbox "Shipment confirmations before sales invoice"
		Then the form attribute named "ShipmentConfirmationsBeforeSalesInvoice" became equal to "Yes"
		And I click "Save and close" button

Scenario: _029002 create document Sales order and Shipment confirmation (partner Kalipso, Store use Shipment confirmation)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Kalipso' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post" button
	* Change of document number 
		And I move to "Other" tab
		And I expand "More" group
		And I input "180" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "180" text in "Number" field
		And I click "Post" button
	* Create Shipment confirmation
		And I click "Shipment confirmation" button
		Then the form attribute named "Company" became equal to "Main Company"
		And I input "180" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "180" text in "Number" field
	* Check that the tabular part is filled in
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    | 'Unit' | 'Shipment basis'   |
			| 'Trousers' | '12,000'   | '36/Yellow' | 'Store 02' | 'pcs' | 'Sales order 180*' |
			| 'Shirt'    | '10,000'   | '36/Red'    | 'Store 02' | 'pcs' | 'Sales order 180*' |
	And I click "Post and close" button
	And I close all client application windows

Scenario: _029003 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register OrderBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Order'            | 'Item key'  |
		| '12,000'   | 'Sales order 180*' | 'Store 02' | 'Sales order 180*' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*' | 'Store 02' | 'Sales order 180*' | '36/Red'    |
	And I close all client application windows

Scenario: _029004 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockReservation
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '12,000'   | 'Sales order 180*' | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*' | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029005 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register InventoryBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'          | 'Company'      | 'Item key'  |
		| '12,000'   | 'Sales order 180*'  | 'Main Company' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*'  | 'Main Company' | '36/Red'    |
	And I close all client application windows

Scenario: _029006 check Sales order posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key'  |
		| '12,000'   | 'Sales order 180*' | 'Sales order 180*' | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Sales order 180*' | 'Sales order 180*' | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029007 check the absence posting of Sales order (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Recorder'         |
		| 'Sales order 180*' |
	And I close all client application windows

Scenario: _029008 check the absence posting of Sales order (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register ShipmentOrders
	Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
	And "List" table does not contain lines
		| 'Recorder'         |
		| 'Sales order 180*' |
	And I close all client application windows

Scenario: _029009 check Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'   | 'Shipment confirmation 180*' | '1'           | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Shipment confirmation 180*' | '2'           | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029010 check Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                   | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | '1'           | 'Store 02' | '36/Yellow' |
		| '10,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | '2'           | 'Store 02' | '36/Red'    |
	And I close all client application windows

Scenario: _029011 check Shipment confirmation posting (store use Shipment confirmation, Shipment confirmation before Sales invoice) by register ShipmentOrders
	Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                   | 'Order'            | 'Shipment confirmation'      | 'Item key'  |
		| '12,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Yellow' |
		| '10,000'   | 'Shipment confirmation 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Red'    |
	And I close all client application windows

Scenario: _029012 create document Sales order and Shipment confirmation (partner Kalipso, one Store use Shipment confirmation and Second not)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Kalipso' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Change of quantity and store on the second line
		And I select current line in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| Item     | Item key  |
			| Trousers | 36/Yellow |
		And I select current line in "ItemList" table
		And I input "7,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of "Store" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Store 01  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Change number
		And I move to "Other" tab
		And I expand "More" group
		And I input "181" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "181" text in "Number" field
		And in the table "ItemList" I click "% Offers" button
		And in the table "Offers" I click the button named "FormOK"
		And I click "Post" button
	* Create Shipment confirmation
		And I click "Shipment confirmation" button
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' | 'Shipment basis'   |
			| 'Shirt' | '10,000'   | '36/Red'   | 'Store 02' | 'pcs' | 'Sales order 181*' |
		And I click "Post and close" button
	And I close all client application windows
	* Check movements by register OrderBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Order'            | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Store 01' | 'Sales order 181*' | '36/Yellow' |
			| '10,000'   | 'Sales order 181*' | '2'           | 'Store 02' | 'Sales order 181*' | '36/Red'    |
		And I close all client application windows
	* Check movements by register StockReservation
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Store 01' | '36/Yellow' |
			|'10,000'    | 'Sales order 181*' | '2'           | 'Store 02' | '36/Red'    |
		And I close all client application windows
	* Check movements by register InventoryBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         |'Company'      | 'Item key'  |
			| '7,000'    | 'Sales order 181*' |'Main Company' | '36/Yellow' |
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'         |'Company'      | 'Item key'  |
			| '10,000'   | 'Sales order 181*' |'Main Company' | '36/Red'    |
		And I close all client application windows
	* Check movements by register GoodsInTransitOutgoing
		Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | 'Sales order 181*' | 'Sales order 181*' | '1'           | 'Store 02' | '36/Red'   |
		And I close all client application windows
	* Check movements by register StockBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Store'    | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Store 01' | '36/Yellow' |
		And I close all client application windows
	* Check movements by register ShipmentOrders
		Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Line number' | 'Order'            | 'Shipment confirmation'  | 'Item key'  |
			| '7,000'    | 'Sales order 181*' | '1'           | 'Sales order 181*' | 'Sales order 181*'       | '36/Yellow' |
		And I close all client application windows
	* Check movements by register StockBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | 'Shipment confirmation 181*' | '1'           | 'Store 02' | '36/Red'   |
		And I close all client application windows
	* Check movements by register GoodsInTransitOutgoing
		Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
			| '10,000'   | 'Shipment confirmation 181*' | 'Sales order 181*' | '1'           | 'Store 02' | '36/Red'   |
		And I close all client application windows
	* Check movements by register ShipmentOrders
		Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Line number' | 'Order'            | 'Shipment confirmation'      | 'Item key' |
			| '10,000'   | 'Shipment confirmation 181*' | '1'           | 'Sales order 181*' | 'Shipment confirmation 181*' | '36/Red'   |
		And I close all client application windows
	
Scenario: _029013 create Sales invoice for several shipments
# one shipment can apply to only one Sales invoice
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '180'    | 'Kalipso' |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	And I click the button named "FormSelectAll"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Kalipso"
	Then the form attribute named "LegalName" became equal to "Company Kalipso"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
	Then the form attribute named "Company" became equal to "Main Company"
	And I go to line in "ItemList" table
    	| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      |
		| 'Trousers' | '36/Yellow' | 'Store 01' | 'pcs'  | '7,000'  |
	And I delete a line in "ItemList" table
	* Check the filling of the tabular part
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Shipment confirmation'      | 'Sales order'      | 'Unit' | 'Q'      | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | 'Shipment confirmation 180*' | 'Sales order 180*' | 'pcs' | '12,000' | ''            | '732,20'     | '4 067,76'   | '4 799,96'     |
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | 'Shipment confirmation 180*' | 'Sales order 180*' | 'pcs' | '10,000' | ''            | '533,90'     | '2 966,10'   | '3 500,00'     |
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | 'Shipment confirmation 180*' | 'Sales order 180*' | 'pcs' | '10,000' | ''            | '533,90'     | '2 966,10'   | '3 500,00'     |
	* Change number
		And I move to "Other" tab
		And I expand "More" group
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "180" text in "Number" field
		And I click "Post and close" button
	And Delay 5
	* Check movements
		* Check the absence posting by register Stock Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			And I close all client application windows
		* Check the absence posting by register Inventory Balance 
			Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			And I close all client application windows
		* Check the absence posting by register Stock StockReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			And I close all client application windows
		* Check the absence posting by register GoodsInTransitOutgoing
			Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 180*' |
			And I close all client application windows
		* Check posting by register Order Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'           | 'Store'    | 'Order'            | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Store 02' | 'Sales order 180*' | '36/Yellow' |
				| '10,000'   | 'Sales invoice 180*' | 'Store 02' | 'Sales order 180*' | '36/Red'    |
				| '10,000'   | 'Sales invoice 180*' | 'Store 02' | 'Sales order 181*' | '36/Red'    |
			And I close all client application windows
		* Check posting by register OrderReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Store 02' | '36/Yellow' |
				| '20,000'   | 'Sales invoice 180*' | 'Store 02' | '36/Red'    |
			And I close all client application windows
		* Check posting by register OrderReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'           | 'Sales invoice'      | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Sales invoice 180*' | '36/Yellow' |
				| '10,000'   | 'Sales invoice 180*' | 'Sales invoice 180*' | '36/Red'    |
				| '10,000'   | 'Sales invoice 180*' | 'Sales invoice 180*' | '36/Red'    |
			And I close all client application windows
		* Check posting by register ShipmentOrders
			Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
			And "List" table contains lines
				| 'Quantity' | 'Recorder'           | 'Order'            | 'Shipment confirmation'      | 'Item key'  |
				| '12,000'   | 'Sales invoice 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Yellow' |
				| '10,000'   | 'Sales invoice 180*' | 'Sales order 180*' | 'Shipment confirmation 180*' | '36/Red'    |
				| '10,000'   | 'Sales invoice 180*' | 'Sales order 181*' | 'Shipment confirmation 181*' | '36/Red'    |
			And I close all client application windows

Scenario: _029014 availability check for selection shipment confirmation for which sales invoice has already been issued
# should not be displayed
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '180'    | 'Kalipso' |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	And I click the button named "FormSelectAll"
	And I click "Ok" button
	* Filling check
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filling of the tabular part
		And I save number of "ItemList" table lines as "Q"
		And I display "Q" variable value
		Then "Q" variable is equal to 1
		And "ItemList" table contains lines
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Shipment confirmation'    | 'Sales order'      | 'Unit' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| 'Trousers' | '338,98' | '36/Yellow' | 'Store 01' | 'Sales order 181*'         | 'Sales order 181*' | 'pcs' | '7,000' | ''              | '427,11'     | '2 372,86'   | '2 799,97'     |
	* Change number
		And I move to "Other" tab
		And I expand "More" group
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "181" text in "Number" field
		And I click "Post and close" button
	And I close all client application windows
	* Check movements
		* Check the absence posting by register Stock Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check the absence posting by register Inventory Balance 
			Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check the absence posting by register Stock StockReservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check the absence posting by register GoodsInTransitOutgoing
			Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check posting by register Order Balance
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
			And "List" table contains lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check posting by register Order reservation
			Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
			And "List" table contains lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check posting by register Sales turnovers
			Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
		* Check posting by register ShipmentOrders
			Given I open hyperlink "e1cib/list/AccumulationRegister.ShipmentOrders"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Sales invoice 181*' |
			And I close all client application windows
