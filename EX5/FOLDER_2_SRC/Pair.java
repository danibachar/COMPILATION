package Pair;

import AST.*;
import LLVM.*;
import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Set;

import TYPES.TYPE;

// Based on - https://www.techiedelight.com/implement-pair-class-java/
public class Pair<U, V>
{
	public final U first;   	// first field of a Pair
	public final V second;  	// second field of a Pair

	// Constructs a new Pair with specified values
	public Pair(U first, V second)
	{
		this.first = first;
		this.second = second;
	}

	@Override
	// Checks specified object is "equal to" current object or not
	public boolean equals(Object o)
	{
		if (this == o)
			return true;

		if (o == null || getClass() != o.getClass())
			return false;

		Pair<?, ?> pair = (Pair<?, ?>) o;

		// call equals() method of the underlying objects
		if (!first.equals(pair.first))
			return false;
		return second.equals(pair.second);
	}

	@Override
	// Computes hash code for an object to support hash tables
	public int hashCode()
	{
		// use hash codes of the underlying objects
		return 31 * first.hashCode() + second.hashCode();
	}

	@Override
	public String toString()
	{
		return "(" + first + ", " + second + ")";
	}

	public V getValue() {
		return this.second;
	}

	public U getKey() {
		return this.first;
	}
}
