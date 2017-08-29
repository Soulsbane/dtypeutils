module dtypeutils.readable;

private immutable string[string] READABLE_TYPES;

static this() pure
{
    READABLE_TYPES = ["long" : "number", "string" : "text"];
}
