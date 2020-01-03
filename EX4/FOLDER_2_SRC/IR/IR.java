/***********/
/* PACKAGE */
/***********/
package IR;

/*******************/
/* GENERAL IMPORTS */
/*******************/
import java.io.*;
import java.io.PrintWriter;
import java.util.*;
/*******************/
/* PROJECT IMPORTS */
/*******************/
import TEMP.*;

public class IR
{
	private IRcommand head=null;
	private IRcommandList tail=null;

	private ArrayList<String> globalFunctions = new ArrayList<String>();

	/******************/
	/* 	IT Scoping 		*/
	/******************/
	private Map<Integer, Map<String, TEMP>> varScopeMap = new HashMap<Integer,Map<String, TEMP>>();

	public TEMP fetchTempFromScope(String var_name, int scope, boolean autoCreate) {
		System.out.format("fetchTempFromScope - var_name=%s\nscope=%d\nautoCreate=%s\n",var_name, scope, autoCreate);
		// Fetch the scope map and allocate if non-exists
		Map<String, TEMP> scopeMap = varScopeMap.get(scope);
		if (scopeMap == null) {
			scopeMap = new HashMap();
			varScopeMap.put(scope, scopeMap);
		}
		// try fetch from current scope.
		// if fails try to fetch from global scope
		TEMP t = scopeMap.get(var_name);
		if (t == null && autoCreate) {
			t = TEMP_FACTORY.getInstance().getFreshTEMP();
			System.out.format("fetchTempFromScope - DIDNOT find var_name=%s\nin scope=%d\n created=%d\n",var_name, scope,t.getSerialNumber());
			scopeMap.put(var_name, t);
		} else {
			System.out.format("fetchTempFromScope - DID find var_name=%s\nin scope=%d\n created=%d\n",var_name, scope,t.getSerialNumber());
		}
		//update not sure if needed - not familiar with java reference / value
		varScopeMap.put(scope, scopeMap);
		return t;
	}

	public TEMP findVarRecursive(String var_name, int scope) {
			for (int i = scope; i >= 0; i--) {
				Map<String, TEMP> scopeMap = varScopeMap.get(scope);
				if (scopeMap != null) {
					TEMP t = scopeMap.get(var_name);
					if (t != null) {
						return t;
					}
				}
			}
			return null;
	}

	/******************/
	/* Add IR command */
	/******************/
	public void Add_IRcommand(IRcommand cmd)
	{
		if ((head == null) && (tail == null))
		{
			this.head = cmd;
		}
		else if ((head != null) && (tail == null))
		{
			this.tail = new IRcommandList(cmd,null);
		}
		else
		{
			IRcommandList it = tail;
			while ((it != null) && (it.tail != null))
			{
				it = it.tail;
			}
			it.tail = new IRcommandList(cmd,null);
		}
	}

	/*******************/
	/* LLVM bitcode me */
	/*******************/
	public void LLVM_bitcode_me()
	{
		if (head != null) head.LLVM_bitcode_me();
		if (tail != null) tail.LLVM_bitcode_me();
	}

	/***************/
	/* MIPS me !!! */
	/***************/
	public void MIPSme()
	{
		if (head != null) head.MIPSme();
		if (tail != null) tail.MIPSme();
	}

	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static IR instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	protected IR() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static IR getInstance()
	{
		if (instance == null)
		{
			/*******************************/
			/* [0] The instance itself ... */
			/*******************************/
			instance = new IR();
		}
		return instance;
	}
}
