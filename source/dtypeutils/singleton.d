/**
	A template mixin to make a class a singleton.
*/
module dtypeutils.singleton;

/**
	Used for mixing into a class to create a singlton.

	Params:
		T = The type that is mixing with the singleton.
*/
template MixinSingleton(T)
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
					instance_ = new T;
				}

				alreadyInstantiated_ = true;
			}
		}

		return instance_;
	}
}

/**
	Used for a creating a single instance of an object.

	Params:
		T = The type that will be the singleton.
*/
class Singleton(T)
{
	static T getInstance()
	{
		if(!alreadyInstantiated_)
		{
			synchronized(T.classinfo)
			{
				if (!instance_)
				{
					instance_ = new T;
				}

				alreadyInstantiated_ = true;
			}
		}

		return instance_;
	}
private:
	__gshared T instance_;
	static bool alreadyInstantiated_;
}

private class Incrementor
{
	mixin MixinSingleton!Incrementor;
	int value;
}

private class NumberChanger : Singleton!NumberChanger
{
	int value;
}

///
@("Singleton Tests")
unittest
{
	auto increment = Incrementor.getInstance();
	assert(increment.value == 0);

	auto anotherIncrement = Incrementor.getInstance();
	anotherIncrement.value = 111;

	assert(increment.value == 111);

	auto numChanger = NumberChanger.getInstance();
	assert(numChanger.value == 0);

	auto anotherNumChanger = NumberChanger.getInstance();
	anotherNumChanger.value = 111;

	assert(numChanger.value == 111);
}
