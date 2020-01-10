package LocalVarCounter;

import AST.*;
import LLVM.*;
import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Set;
import javafx.util.Pair;

import TYPES.TYPE;



public class LocalVarCounter
{

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
		String key = varName + "_" + LLVM.getInstance().typeToString(type);
		if (localIndexes.containsKey(key)){
			return localIndexes.get(key).getValue();
		}
		localIndexes.put(key, new Pair<TYPE,Integer>(type,localCount));
		return localCount++;
	}


	public int getIndex(String varName, TYPE type)
	{
		String key = varName + "_" + LLVM.getInstance().typeToString(type);;
		// System.out.format("key = %s\n", key);
		if (localIndexes.containsKey(key)){
			// System.out.format("key = %s, found = %s\n", key, localIndexes.get(key).getValue());
			return localIndexes.get(key).getValue();
		}
		// System.out.format("key = %s, NOT found \n", key);
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



		/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static LocalVarCounter instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	protected LocalVarCounter() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static LocalVarCounter getInstance()
	{
		if (instance == null)
		{
			/*******************************/
			/* [0] The instance itself ... */
			/*******************************/
			instance = new LocalVarCounter();

		}
		return instance;
	}

}
