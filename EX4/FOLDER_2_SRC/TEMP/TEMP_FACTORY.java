/***********/
/* PACKAGE */
/***********/
package TEMP;

/*******************/
/* GENERAL IMPORTS */
/*******************/
import java.util.*;

/*******************/
/* PROJECT IMPORTS */
/*******************/

public class TEMP_FACTORY
{
	public int scope=0;
	public int counter=0;
	private Map<Integer, Integer> counterScope = new HashMap<Integer, Integer>();
	private Map<Integer, Map<String, TEMP>> varScopeMap = new HashMap<Integer,Map<String, TEMP>>();

	public TEMP getFreshTEMP() {
		// Integer c = counterScope.get(scope);
		// if (c == null) {
		// 	c = 0;
		// }
		TEMP t = new TEMP(counter++);
		// counterScope.put(scope, c);
		return t;
	}

	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static TEMP_FACTORY instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	protected TEMP_FACTORY() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static TEMP_FACTORY getInstance() {
		if (instance == null) {
			/*******************************/
			/* [0] The instance itself ... */
			/*******************************/
			instance = new TEMP_FACTORY();
		}
		return instance;
	}

	public void beginScope(int scope) {
		Map<String, TEMP> scopeMap = varScopeMap.get(scope);
		System.out.format("beginScope - prev scope = %s\n", this.scope);
		this.scope = scope;
		System.out.format("beginScope - new scope = %s\n", this.scope);

		if (scopeMap == null) {
			varScopeMap.put(scope, new HashMap());
		} else {
			System.out.format("**********************ERROR");
		}
	}

	public void endScope(int scope) {
		System.out.format("endScope - prev scope = %s\n", this.scope);
		this.scope = this.scope-1;
		System.out.format("endScope - new scope = %s\n", this.scope);
		varScopeMap.remove(scope);

	}

	public TEMP fetchTempFromScope(String var_name, int scope, boolean autoCreate) {
		System.out.format("fetchTempFromScope - var_name=%s\nscope=%d\nautoCreate=%s\n",var_name, scope, autoCreate);
		// Fetch the scope map and allocate if non-exists
		Map<String, TEMP> scopeMap = varScopeMap.get(scope);
		if (scopeMap == null) {
			System.out.format("Error scope should be open\n");
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
				System.out.format("findVarRecursive - i(%s) name = %s, main scope = %s\n",i, var_name, scope);
				Map<String, TEMP> scopeMap = varScopeMap.get(scope);
				System.out.format("findVarRecursive scopeMap %s in scope %s\n", scopeMap, scope);
				if (scopeMap != null) {
					TEMP t = scopeMap.get(var_name);
					System.out.format("findVarRecursive t %s in scope %s\n", t, scope);
					if (t != null) {
						return t;
					}
				}
			}
			System.out.format("$$$$$$$$$$$findVarRecursive DINT Find %s in scope %s\n", var_name, scope);
			return null;
	}
}
