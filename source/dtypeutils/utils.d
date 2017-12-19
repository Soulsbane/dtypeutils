/**
	Various functions to determine types at runtime.

	Authors: Paul Crane
*/

module dtypeutils.utils;

import std.typecons;
import std.traits;
import std.conv;
import std.algorithm;
import std.math : isNaN;

version(unittest)
{
	import fluent.asserts;
}

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
		if(allowInteger)
		{
			return(value == 1);
		}

		return false;
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
	"true".isTrue.should.equal(true);
	"false".isTrue.should.equal(false);
	"1".isTrue.should.equal(true);
	"0".isTrue.should.equal(false);
	"12345".isTrue.should.equal(false);
	"trues".isTrue.should.equal(false);
	1.isTrue.should.equal(true);

	1.isTrue(AllowNumeric.no).should.equal(false);
	"1".isTrue(AllowNumeric.no).should.equal(false);
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
		if(allowInteger)
		{
			return(value == 0);
		}

		return false;
	}

	static if(isFloatingPoint!T && !is(T == enum))
	{
		if(allowInteger)
		{
			if(value.isNaN || value == 0.0)
			{
				return true;
			}
		}

		return false;
	}

	static if(isSomeString!T)
	{
		if(allowInteger)
		{
			return(value == "0" || value == "false");
		}

		return (value == "false");
	}

	assert(0); // Other types not supported
}

///
unittest
{
	"false".isFalse.should.equal(true);
	"true".isFalse.should.equal(false);
	"1".isFalse.should.equal(false);
	"0".isFalse.should.equal(true);
	"12345".isFalse.should.equal(false);
	"trues".isFalse.should.equal(false);
	0.0.isFalse(AllowNumeric.yes).should.equal(true);
	0.0.isFalse(AllowNumeric.no).should.equal(false);

	"0".isFalse(AllowNumeric.no).should.equal(false);
	0.isFalse(AllowNumeric.no).should.equal(false);
	13.isFalse(AllowNumeric.no).should.equal(false);
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
	"0".isBoolean.should.equal(true);
	"1".isBoolean.should.equal(true);
	"2".isBoolean.should.equal(false);

	"true".isBoolean.should.equal(true);
	"false".isBoolean.should.equal(true);
	"trues".isBoolean.should.equal(false);

	"0".isBoolean(AllowNumeric.no).should.equal(false);
	"1".isBoolean(AllowNumeric.no).should.equal(false);

	0.isBoolean.should.equal(true);
	1.isBoolean.should.equal(true);
	2.isBoolean.should.equal(false);
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
	"13".isDecimal.should.equal(false);
	"13.333333".isDecimal.should.equal(true);
	"zzzz".isDecimal.should.equal(false);
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
	"13".isInteger.should.equal(true);
	"13.333333".isInteger.should.equal(false);
	"zzzz".isInteger.should.equal(false);
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
	"10".convertTo!int(10).should.equal(10);
	"true".convertTo!int(12).should.equal(12);
	"true".convertTo!bool(false).should.equal(true);
	"falsy".convertTo!bool(false).should.equal(false);
}
