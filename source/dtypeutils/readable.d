module dtypeutils.readable;

import std.traits;
import std.stdio;
import std.conv;

string getReadableType(alias dtype)()
{
	mixin("immutable bool typeString = isSomeString!" ~ dtype ~ ";");
	mixin("immutable bool typeNumeric = isNumeric!" ~ dtype ~ ";");

	if(typeString)
	{
		return "text";
	}
	else if(typeNumeric)
	{
		mixin("immutable bool typeFloat = isFloatingPoint!" ~ dtype ~ ";");

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

unittest
{
	assert(getReadableType!"long" == "number");
	assert(getReadableType!"string" == "text");
	assert(getReadableType!"float" == "decimal");
}
