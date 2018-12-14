/**
	Functions for converting a D type into a human readable type.
*/
module dtypeutils.readable;

import std.traits;
import std.stdio;
import std.conv;

immutable private string BOOLEAN = "boolean";
immutable private string NUMBER = "number";
immutable private string DECIMAL = "decimal";
immutable private string STRING = "text";
immutable private string CHARACTER = "character";
immutable private string UNKNOWN = "unknown";

/**
	Turns a D type into a human readable type.

	Params:
		typeName = The D type.

	Returns:
		A human readable type.
*/
string getReadableType(T)()
{
	return getReadableType(T.stringof);
}

///
@("getReadableType Tests(Template T Version)")
unittest
{
	assert(getReadableType!long == NUMBER);
	assert(getReadableType!ulong == NUMBER);
	assert(getReadableType!short == NUMBER);
	assert(getReadableType!int == NUMBER);
	assert(getReadableType!uint == NUMBER);
	assert(getReadableType!byte == NUMBER);
	assert(getReadableType!ubyte == NUMBER);
	assert(getReadableType!short == NUMBER);
	assert(getReadableType!ushort == NUMBER);

	assert(getReadableType!string == STRING);
	assert(getReadableType!dstring == STRING);
	assert(getReadableType!wstring == STRING);

	assert(getReadableType!float == DECIMAL);
	assert(getReadableType!double == DECIMAL);
	assert(getReadableType!real == DECIMAL);

	assert(getReadableType!char == CHARACTER);
	assert(getReadableType!dchar == CHARACTER);
	assert(getReadableType!wchar == CHARACTER);

	assert(getReadableType!bool == BOOLEAN);
}

/**
	Turns a D type into a human readable type.

	Params:
		typeName = The D type.

	Returns:
		A human readable type.
*/
string getReadableType(const string typeName)
{
	immutable string[string] READABLE_TYPES = [
		"bool" : BOOLEAN,
		"void" : UNKNOWN,
		"byte" : NUMBER,
		"ubyte" : NUMBER,
		"short" : NUMBER,
		"ushort" : NUMBER,
		"int" : NUMBER,
		"uint" : NUMBER,
		"long" : NUMBER,
		"ulong" : NUMBER,
		"cent" : NUMBER,
		"ucent" : NUMBER,
		"float" : DECIMAL,
		"double" : DECIMAL,
		"real" : DECIMAL,
		"ifloat" : DECIMAL,
		"idouble" : DECIMAL,
		"ireal" : DECIMAL,
		"cfloat" : DECIMAL,
		"cdouble" : DECIMAL,
		"creal" : DECIMAL,
		"char" : CHARACTER,
		"wchar" : CHARACTER,
		"dchar" : CHARACTER,
		"string" : STRING,
		"dstring" : STRING,
		"wstring" : STRING
	];

	return READABLE_TYPES.get(typeName, UNKNOWN);
}

///
@("getReadableType Tests(string Version)")
unittest
{
	assert(getReadableType("bool") == BOOLEAN);
	assert(getReadableType("void") == UNKNOWN);

	assert(getReadableType("byte") == NUMBER);
	assert(getReadableType("ubyte") == NUMBER);
	assert(getReadableType("short") == NUMBER);
	assert(getReadableType("ushort") == NUMBER);
	assert(getReadableType("int") == NUMBER);
	assert(getReadableType("uint") == NUMBER);
	assert(getReadableType("long") == NUMBER);
	assert(getReadableType("ulong") == NUMBER);
	assert(getReadableType("cent") == NUMBER);
	assert(getReadableType("ucent") == NUMBER);

	assert(getReadableType("float") == DECIMAL);
	assert(getReadableType("double") == DECIMAL);
	assert(getReadableType("real") == DECIMAL);
	assert(getReadableType("ifloat") == DECIMAL);
	assert(getReadableType("idouble") == DECIMAL);
	assert(getReadableType("ireal") == DECIMAL);
	assert(getReadableType("cfloat") == DECIMAL);
	assert(getReadableType("cdouble") == DECIMAL);
	assert(getReadableType("creal") == DECIMAL);

	assert(getReadableType("string") == STRING);
	assert(getReadableType("dstring") == STRING);
	assert(getReadableType("wstring") == STRING);

	assert(getReadableType("char") == CHARACTER);
	assert(getReadableType("wchar") == CHARACTER);
	assert(getReadableType("dchar") == CHARACTER);
}
