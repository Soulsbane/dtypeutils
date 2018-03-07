/**
	Various functions to determine types at runtime.

	Authors: Paul Crane
*/

module dtypeutils.utils;

import std.typecons;
import std.traits;
import std.conv;
import std.algorithm;
import std.math;

/**
	Determines if value is a true value

	Params:
		value = The value to check for a true value
		allowNumeric = Set to allowNumeric.yes if a true value can be a numeric 1

	Returns:
		true if the value is true false otherwise.
*/
bool isTrue(T)(const T value, const Flag!"allowNumeric" allowNumeric = Yes.allowNumeric) @trusted
{
	static if(isIntegral!T)
	{
		if(allowNumeric)
		{
			return(value == 1);
		}

		return false;
	}

	static if(isFloatingPoint!T && !is(T == enum))
	{
		if(allowNumeric && approxEqual(value, 1.0))
		{
			return true;
		}

		return false;
	}

	static if(isSomeString!T)
	{
		if(allowNumeric)
		{
			return(value == "1" || value == "true" || value == "1.0");
		}

		return (value == "true");
	}

	assert(0); // Other types not supported
}

///
unittest
{
	assert("true".isTrue == true);
	assert("false".isTrue == false);
	assert("1".isTrue == true);
	assert("0".isTrue == false);
	assert("12345".isTrue == false);
	assert("trues".isTrue == false);
	assert("1".isTrue(No.allowNumeric) == false);
	assert("0.0".isTrue == false);
	assert("2.0".isTrue == false);
	assert("1.0".isTrue == true);

	assert(0.0.isTrue == false);
	assert(0.0.isTrue(No.allowNumeric) == false);
	assert(1.0.isTrue == true);

	assert(1.isTrue(No.allowNumeric) == false);
	assert(1.isTrue == true);
}

/**
	Determines if value is a false value

	Params:
		value = The value to check for a false value
		allowNumeric = Set to Yes.allowNumeric if a false value can be a numeric 0

	Returns:
		true if the value is false false otherwise.
*/
bool isFalse(T)(const T value, const Flag!"allowNumeric" allowNumeric = Yes.allowNumeric) @trusted
{
	static if(isIntegral!T)
	{
		if(allowNumeric)
		{
			return(value == 0);
		}

		return false;
	}

	static if(isFloatingPoint!T && !is(T == enum))
	{
		if(allowNumeric && (value.isNaN || value == 0.0))
		{
			return true;
		}

		return false;
	}

	static if(isSomeString!T)
	{
		if(allowNumeric)
		{
			return(value == "0" || value == "false" || value == "0.0");
		}

		return (value == "false");
	}

	assert(0); // Other types not supported
}

///
unittest
{
	assert("false".isFalse == true);
	assert("true".isFalse == false);
	assert("1".isFalse == false);
	assert("0".isFalse == true);
	assert("12345".isFalse == false);
	assert("trues".isFalse == false);
	assert("0".isFalse(No.allowNumeric) == false);
	assert("0.0".isFalse == true);
	assert("2.0".isFalse == false);
	assert("0".isFalse(No.allowNumeric) == false);

	assert(0.0.isFalse == true);
	assert(0.0.isFalse(No.allowNumeric) == false);
	assert(1.0.isFalse == false);

	assert(0.isFalse == true);
	assert(0.isFalse(No.allowNumeric) == false);
	assert(13.isFalse(No.allowNumeric) == false);
}

/**
	Determines if a value is of type boolean using 0, 1, true and false as qualifiers.

	Params:
		value = number or boolean string to use. Valid values of 0, 1, "0", "1", "true", "false"
		allowNumeric = Set to Yes.allowNumeric if a true/false value can be a numeric 0 or 1

	Returns:
		true if the value is a boolean false otherwise.
*/
bool isBoolean(T)(const T value, const Flag!"allowNumeric" allowNumeric = Yes.allowNumeric) @trusted
{
	return(isTrue(value, allowNumeric) || isFalse(value, allowNumeric));
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

	assert("0".isBoolean(No.allowNumeric) == false);
	assert("1".isBoolean(No.allowNumeric) == false);

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
