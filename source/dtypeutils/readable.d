/**
	Functions for converting a D type into a human readable type.
*/
module dtypeutils.readable;

import std.traits;
import std.stdio;
import std.conv;

immutable BOOLEAN = "boolean";
immutable NUMBER = "number";
immutable DECIMAL = "decimal";
immutable STRING = "string";
// TODO: characters should be a chractar not a string.
immutable UNKNOWN = "unknown";

/**
	Turns a D type into a human readable type.

	Params:
		typeName = The D type.

	Returns:
		A human readable type.
*/
string getReadableType(alias typeName)()
{
	mixin("immutable bool typeString = isSomeString!" ~ typeName ~ ";");
	mixin("immutable bool typeNumeric = isNumeric!" ~ typeName ~ ";");

	if(typeString)
	{
		return "text";
	}
	else if(typeNumeric)
	{
		mixin("immutable bool typeFloat = isFloatingPoint!" ~ typeName ~ ";");

		if(typeFloat)
		{
			return "decimal";
		}
		else
		{
			return "number";
		}
	}
	else
	{
		return "unknown";
	}
}

///
@("getReadableType Tests(alias typeName Version)")
unittest
{
	assert(getReadableType!("long") == "number");
	assert(getReadableType!("string") == "text");
	assert(getReadableType!("float") =="decimal");
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
		"char" : STRING,
		"wchar" : STRING,
		"dchar" : STRING
	];

	return READABLE_TYPES.get(typeName, "unknown");
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
	assert(getReadableType("char") == STRING);
	assert(getReadableType("wchar") == STRING);
	assert(getReadableType("dchar") == STRING);
}
