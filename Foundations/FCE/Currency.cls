/// Currency exchange rates and images, and other utilities
Class FCE.Currency Extends %Persistent [ DependsOn = FCE.CurrencyName ]
{

/// currency abbreviations, computed at COMPILE time (therefore requires DependsOn above)
Parameter ABBREVIATIONS = {##class(FCE.CurrencyName).#VALUELIST};

/// access key for apilayer.net, for InterSystems training use ONLY!
Parameter ACCESSKEY = "";

/// default rates in case call to apilayer.net fails
Parameter DEFAULTRATES = "{""USDEUR"":1,""USDINR"":65,""USDVEF"":10,""USDJPY"":110,""USDMXN"":20,""USDZAR"":15,""USDBRL"":3,""USDCAD"":1,""USDRUB"":60}";

/// Currency is an alternate key
Property Currency As FCE.CurrencyName [ Required ];

Index CurrencyIndex On Currency [ Unique ];

/// 1 USD in each currency
Property USDExchangeRate As %Decimal(MINVAL = .001, SCALE = 3);

Property Image As %Stream.GlobalBinary;

ClassMethod ConvertCurrenciestoListString(valuelist as %String) as %List
{
	set delim = $extract(valuelist, 1)
	set currencies = $extract(valuelist, 2, *)
	set currencies = $listfromstring(currencies, delim)
	return currencies
}

/// compute exchange rate between two currencies based on the USD rate
ClassMethod ComputeRate(currencyIn As FCE.CurrencyName, currencyOut As FCE.CurrencyName) As %Decimal(SCALE=3) [ SqlProc ]
{
	// get the exchange rate between USD and currencyIn
	&sql(select USDExchangeRate into :inRate
	     from FCE.Currency
	     where Currency = :currencyIn)
	set sqlcode1 = SQLCODE

	// get the exchange rate between USD and currencyOut
	&sql(select USDExchangeRate into :outRate
	     from FCE.Currency
	     where Currency = :currencyOut)
	set sqlcode2 = SQLCODE

	if (sqlcode1 = 0) && (sqlcode2 = 0) {
		// compute the exchange rate between currencyIn and currencyOut
		return (1 / inRate) * outRate
	}
	else {
		write !, "Error code(s): ", sqlcode1, " ", sqlcode2
		return 0
	}
}

/// Load images from a directory; should only need to run once
/// Note: filenames MUST correspond to VALUELIST from FCE.CurrencyName class</Description>
ClassMethod ImportImages(directory As %String)
{
	set currencies = ..ConvertCurrenciestoListString(..#ABBREVIATIONS)
	
	for image = 1: 1 : $listlength(currencies)
	{
		set currencyName = $list(currencies, image)
		set currency = ##class(FCE.Currency).CurrencyIndexOpen(currencyName)
	
		set file = ##class(%Stream.FileBinary).%New()
		set file.Filename = directory _ currencyName _ ".jpg"
		
		// does file exist?
		if (file.Size = 0) {
			write !, "Couldn't import ", file.Filename, !
			do $system.Status.DisplayError(%objlasterror)
			continue
		}
		
		do currency.Image.CopyFrom(file)
		set status = currency.%Save()
		do $system.Status.DisplayError(status)
		write !, currencyName, " imported"
		
		set file = ""
		set currency = ""
	}
}


/// Generate currency name for use as collection key
ClassMethod Currency() As FCE.CurrencyName {
	return ##class(%PopulateUtils).ValueList(..#ABBREVIATIONS)
}




Storage Default
{
<Data name="CurrencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Currency</Value>
</Value>
<Value name="3">
<Value>USDExchangeRate</Value>
</Value>
<Value name="4">
<Value>Image</Value>
</Value>
</Data>
<DataLocation>^FCE.CurrencyD</DataLocation>
<DefaultData>CurrencyDefaultData</DefaultData>
<IdLocation>^FCE.CurrencyD</IdLocation>
<IndexLocation>^FCE.CurrencyI</IndexLocation>
<StreamLocation>^FCE.CurrencyS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
