&AtClient
Procedure CommandSelect(Command)
	If Items.List.CurrentData <> Undefined Then
		Close(Items.List.CurrentData.Ref);
	EndIf;
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	Close(Items.List.CurrentData.Ref);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	JorDocumentsForOutgoingPaymentServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
EndProcedure

