package var_c;

import AST.*;
import Pair.*;
import LLVM.*;
import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Set;

import TYPES.TYPE;

public class var_c
{


		private static var_c instance = null;
		protected var_c() {}

		public static var_c getInstance()
		{
			if (instance == null)
			{
				instance = new var_c();

			}
			return instance;
		}
	private int localCount=0;
	public Hashtable<String, Pair<TYPE,Integer>> localIndexes = new Hashtable<String, Pair<TYPE,Integer>>();

	public void initiateCount()
	{
		localIndexes.clear();
		localCount = 0;
		localIndexes = new Hashtable<String, Pair<TYPE,Integer>>();


	}

	public int getCount()
	{
		return localCount;
	}

	public int declareLocal(String varName, TYPE type)
	{
		String key = varName + "_" + AST_HELPERS.type_to_str(type);
		if (localIndexes.containsKey(key)){
			return localIndexes.get(key).getValue();
		}
		localIndexes.put(key, new Pair<TYPE,Integer>(type,localCount));
		return localCount++;
	}


	public int getIndex(String varName, TYPE type)
	{
		String key = varName + "_" + AST_HELPERS.type_to_str(type);;
		if (localIndexes.containsKey(key)){
			return localIndexes.get(key).getValue();
		}
		return -1;
	}

	public ArrayList<Pair<TYPE, Integer>> getLocalMap()
	{
		ArrayList<Pair<TYPE, Integer>> localMap = new  ArrayList<Pair<TYPE, Integer>>();
		Set<String> keys = localIndexes.keySet();
    for(String key: keys){
			localMap.add(localIndexes.get(key));
		}
		return localMap;
	}

}
