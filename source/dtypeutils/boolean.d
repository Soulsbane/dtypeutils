/**
	Contains a boolean type which can convert boolean like values(numeric, string, etc) to a bool.

	Authors:
		Paul Crane
*/

module dtypeutils.boolean;

/**
	Converts a string value of Yes, 1 to true. Converts No or any other numeric value to false.

	Params:
		value = The stirng value to convert.

	Returns:
		Either a true for a "Yes" or false for No or any other numeric value.
*/
bool toBool(const string value)
{
	return (value == "Yes") || (value == "yes") || (value == "1") || (value == "true") ? true : false;}

///
unittest
{
	assert("Yes".toBool == true);
	assert("yes".toBool == true);
	assert("No".toBool == false);
	assert("1".toBool == true);
	assert("0".toBool == false);
	assert("true".toBool == true);
	assert("false".toBool == false);
}


/**
	Converts a boolean value to a Yes or No string.

	Params:
		value = The boolean value to convert.

	Returns:
		Either a Yes for a true value or No for a false value.
*/
string toYesNo(T)(const T value)
{
	import std.traits : isIntegral, isBoolean;

	static if(isIntegral!T)
	{
		return (value == 1) ? "Yes" : "No";
	}
	else static if(isBoolean!T)
	{
		return value ? "Yes" : "No";
	}
	else
	{
		return "No";
	}
}

/**
	Creates a boolean type which can convert boolean like values(numeric, string, etc) to a bool.

	A note on what true and false values are:

	True values include 1, "Yes", true and "true".
	False values are anything other than 1, "No", false and "false".
*/
struct Boolean
{
public:
	this(const string value)
	{
		boolean_ = value.toBool;
	}

	this(const size_t value)
	{
		boolean_ = value == 1 ? true : false;
	}

	this(const bool value)
	{
		boolean_ = value;
	}

	bool opEquals(const string value) const
	{
		return (boolean_ == value.toBool);
	}

	bool opEquals(const bool value) const
	{
		return (boolean_ == value);
	}

	Boolean opAssign(string value)
	{
		boolean_ = value.toBool;
		return this;
	}

	Boolean opAssign(bool value)
	{
		boolean_ = value;
		return this;
	}

	string asYesNo()
	{
		return boolean_.toYesNo;
	}

	size_t asInteger()
	{
		return boolean_ == true ? 1 : 0;
	}

	bool asBoolean() @property const
	{
		return boolean_;
	}

	string toString()
	{
		import std.conv : to;
		return to!string(boolean_);
	}

	size_t toHash() const nothrow @trusted
	{
		return typeid(boolean_).getHash(&boolean_);
	}

	alias boolean_ this;

private:
	bool boolean_;
}

///
unittest
{
	Boolean value = 1;
	assert(value == true);
	assert(value.asInteger == 1);

	Boolean strValue = "Yes";
	assert(strValue == true);
	assert(strValue.asYesNo == "Yes");
	assert(strValue == "Yes");

	Boolean boolValue = true;
	boolValue = "No";
	assert(boolValue == false);
	boolValue = 1;
	assert(boolValue == true);

	Boolean compare1 = true;
	Boolean compare2 = true;
	Boolean compare3 = false;
	assert(compare1 == compare2);
	compare2 = compare3;
	assert(compare2 == compare2);

	size_t tValue = 1;
	Boolean tBoolValue = tValue; // calls this(size_t)
	Boolean tBoolValue2 = tBoolValue;
	assert(tBoolValue == true);
	assert(tBoolValue2 == true);

	Boolean testToString;
	assert(testToString == "false");
	assert(testToString.toString == "false");

	Boolean intEquals = 1;
	assert(intEquals == 1);
	assert(intEquals.asBoolean() == true);

	Boolean constructBoolean = Boolean(true);
	assert(constructBoolean == true);

	string[Boolean] hash;
	hash[intEquals] = "a true";
	assert(hash[intEquals] == "a true");
}
