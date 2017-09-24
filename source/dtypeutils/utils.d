/**
	Various functions to determine types at runtime.

	Authors: Paul Crane
*/

module dtypeutils.utils;

import std.typecons;
import std.traits;
import std.conv;
import std.algorithm;

alias AllowNumeric = Flag!"allowNumeric";

/**
	Determines if value is a true value

	Params:
		value = The value to check for a true value
		allowInteger = Set to allowNumeric.yes if a true value can be a numeric 1

	Returns:
		true if the value is true false otherwise.
*/
bool isTrue(T)(const T value, const AllowNumeric allowInteger = AllowNumeric.yes) @trusted
{
	static if(isIntegral!T)
	{
		return(value == 1);
	}
	else
	{
		if(allowInteger)
		{
			return(value == "1" || value == "true");
		}

		return (value == "true");
	}
}

///
unittest
{
	assert(isTrue("true") == true);
	assert(isTrue("false") == false);
	assert(isTrue("1") == true);
	assert(isTrue("0") == false);
	assert(isTrue("12345") == false);
	assert(isTrue("trues") == false);

	assert("1".isTrue(AllowNumeric.no) == false);
}

/**
	Determines if value is a false value

	Params:
		value = The value to check for a false value
		allowInteger = Set to allowNumeric.yes if a false value can be a numeric 0

	Returns:
		true if the value is false false otherwise.
*/
bool isFalse(T)(const T value, const AllowNumeric allowInteger = AllowNumeric.yes) @trusted
{
	static if(isIntegral!T)
	{
		return(value == 0);
	}
	else
	{
		if(allowInteger)
		{
			return(value == "0" || value == "false");
		}

		return (value == "false");
	}
}

///
unittest
{
	assert(isFalse("false") == true);
	assert(isFalse("true") == false);
	assert(isFalse("1") == false);
	assert(isFalse("0") == true);
	assert(isFalse("12345") == false);
	assert(isFalse("trues") == false);

	assert("0".isFalse(AllowNumeric.no) == false);
}

/**
	Determines if a value is of type boolean using 0, 1, true and false as qualifiers.

	Params:
		value = number or boolean string to use. Valid values of 0, 1, "0", "1", "true", "false"
		allowInteger = Set to allowNumeric.yes if a true/false value can be a numeric 0 or 1

	Returns:
		true if the value is a boolean false otherwise.
*/
bool isBoolean(T)(const T value, const AllowNumeric allowInteger = AllowNumeric.yes) @trusted
{
	return(isTrue(value, allowInteger) || isFalse(value, allowInteger));
}

///
unittest
{
	assert("0".isBoolean == true);
	assert("1".isBoolean == true);
	assert("2".isBoolean == false);

	assert("true".isBoolean == true);
	assert("false".isBoolean == true);
	assert("trues".isBoolean == false);

	assert("0".isBoolean(AllowNumeric.no) == false);
	assert("1".isBoolean(AllowNumeric.no) == false);

	assert(0.isBoolean == true);
	assert(1.isBoolean == true);
	assert(2.isBoolean == false);
}

/**
	Determines if a string is a decimal value

	Params:
		value = string to use.

	Returns:
		true if the value is a decimal false otherwise.
*/
bool isDecimal(const string value) pure @safe
{
	import std.string : isNumeric, countchars;
	return (isNumeric(value) && value.count(".") == 1) ? true : false;
}

///
unittest
{
	assert("13".isDecimal == false);
	assert("13.333333".isDecimal == true);
	assert("zzzz".isDecimal == false);
}
/**
	Determines if a string is an integer value.

	Params:
		value = string to use.

	Returns:
		true if the value is a integer false otherwise.
*/
bool isInteger(const string value) pure @safe
{
	import std.string : isNumeric, countchars;
	return (isNumeric(value) && value.count(".") == 0) ? true : false;
}

///
unittest
{
	assert("13".isInteger == true);
	assert("13.333333".isInteger == false);
	assert("zzzz".isInteger == false);
}

/**
	Uses std.conv.to but catches the exception and returns the defaultValue.

	Params:
		value = The value to convert
		defaultValue = The value to return if conversion attempt fails.

	Returns:
		The converted value if conversion succeeded or the defaultValue if it fails.
*/
T convertTo(T, S)(S value,  T defaultValue)
{
	try
	{
		return value.to!T;
	}
	catch(ConvException ex)
	{
		return defaultValue;
	}
}

///
unittest
{
	assert("10".convertTo!int(10) == 10);
	assert("true".convertTo!int(12) == 12);
	assert("true".convertTo!bool(false) == true);
	assert("falsy".convertTo!bool(false) == false);
}
