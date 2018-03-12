Class FCE.ATM extends (%Persistent,%Library.Populate,%XML.Adaptor) {

/// SerialNumber
Property SerialNumber As %String [ Required ] ;

Parameter POPSPEC = "##class(%PopulateUtils).String(5)_##class(%PopulateUtils).String(5)" ;

/// Branch address

Property Address As FCE.RealEstate ;

ForeignKey RealEstateFK(Address) References FCE.RealEstate() [OnDelete = setnull] ;


Property CurrencyBalances as array of %Numeric (MINVAL = 0, MAXVAL = 10000) [SqlFieldName = Balance];

Index CBIndex on CurrencyBalances(KEYS);

Parameter POPSPEC=":5:##class(FCE.Currency).Currency()"  ;


Storage Default
{
<Data name="ATMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SerialNumber</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
</Data>
<Data name="CurrencyBalances">
<Attribute>CurrencyBalances</Attribute>
<Structure>subnode</Structure>
<Subscript>"CurrencyBalances"</Subscript>
</Data>
<DataLocation>^FCE.ATMD</DataLocation>
<DefaultData>ATMDefaultData</DefaultData>
<IdLocation>^FCE.ATMD</IdLocation>
<IndexLocation>^FCE.ATMI</IndexLocation>
<StreamLocation>^FCE.ATMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}