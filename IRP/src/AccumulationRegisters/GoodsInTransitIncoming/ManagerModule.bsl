Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.GoodsInTransitIncoming");
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ReceiptBasis", "ReceiptBasis");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction