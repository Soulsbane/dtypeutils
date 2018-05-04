/**
	A template mixin to make a class a singleton.
*/
module dtypeutils.singleton;

/**
	Used for mixing into a class to create a singlton.

	Params:
		T = The type that is mixing with the singleton.
*/
template Singleton(T)
{
private:
	__gshared T instance_;
	static bool alreadyInstantiated_;

public:
	static T getInstance()
	{
		if(!alreadyInstantiated_)
		{
			synchronized(T.classinfo)
			{
				if(!instance_)
				{
					instance_ = new T();
				}

				alreadyInstantiated_ = true;
			}
		}

		return instance_;
	}
}

private class Incrementor
{
	mixin Singleton!Incrementor;
	int value;
}

///
unittest
{
	auto increment = Incrementor.getInstance();
	assert(increment.value == 0);

	auto anotherIncrement = Incrementor.getInstance();
	anotherIncrement.value = 111;

	assert(increment.value == 111);
}
