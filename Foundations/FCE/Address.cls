Class FCE.Address extends (%Library.Populate,%XML.Adaptor) [Abstract]{
///Address properties for <class>FCE.RealEstate</class> and <class>FCE.MailingAddress</class>

Property Street As %String  [Required] ;

Property City As %String  [Required] ;

Property State As %String (VALUELIST = "-NY-NJ-MA-TX") [Required] ;

///Property Zip As %String (PATTERN = "5n.1(1""-""4n)") [Required] ;


// Property Zip As %String(PATTERN = "5n.1(1""-""4n)") [ Required ];
Property Zip as FCE.Regex(REGEX="\d{5}(-\d{4})?") [ Required ];


/// Print
ClassMethod Print(br) 
{
	write br.Address.Street
	write !
	write br.Address.City
	write ", "
	write br.Address.State
	write "  "
	write br.Address.Zip
}


}