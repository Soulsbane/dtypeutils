/**
	Functions for converting a D type into a human readable type.
*/
module dtypeutils.readable;

import std.traits;
import std.stdio;
import std.conv;

version(unittest)
{
	import fluent.asserts;
}

immutable BOOLEAN = "boolean";
immutable NUMBER = "number";
immutable DECIMAL = "decimal";
immutable STRING = "string";
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
unittest
{
	getReadableType!("long").should.equal("number");
	getReadableType!("string").should.equal("text");
	getReadableType!("float").should.equal("decimal");
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
unittest
{
	getReadableType("bool").should.equal(BOOLEAN);
	getReadableType("void").should.equal(UNKNOWN);
	getReadableType("byte").should.equal(NUMBER);
	getReadableType("ubyte").should.equal(NUMBER);
	getReadableType("short").should.equal(NUMBER);
	getReadableType("ushort").should.equal(NUMBER);
	getReadableType("int").should.equal(NUMBER);
	getReadableType("uint").should.equal(NUMBER);
	getReadableType("long").should.equal(NUMBER);
	getReadableType("ulong").should.equal(NUMBER);
	getReadableType("cent").should.equal(NUMBER);
	getReadableType("ucent").should.equal(NUMBER);
	getReadableType("float").should.equal(DECIMAL);
	getReadableType("double").should.equal(DECIMAL);
	getReadableType("real").should.equal(DECIMAL);
	getReadableType("ifloat").should.equal(DECIMAL);
	getReadableType("idouble").should.equal(DECIMAL);
	getReadableType("ireal").should.equal(DECIMAL);
	getReadableType("cfloat").should.equal(DECIMAL);
	getReadableType("cdouble").should.equal(DECIMAL);
	getReadableType("creal").should.equal(DECIMAL);
	getReadableType("char").should.equal(STRING);
	getReadableType("wchar").should.equal(STRING);
	getReadableType("dchar").should.equal(STRING);
}
