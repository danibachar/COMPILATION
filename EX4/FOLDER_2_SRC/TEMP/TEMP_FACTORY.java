/***********/
/* PACKAGE */
/***********/
package TEMP;

/*******************/
/* GENERAL IMPORTS */
/*******************/
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;


/*******************/
/* PROJECT IMPORTS */
/*******************/

public class TEMP_FACTORY
{
	public int scope=0;
	public int counter=0;
	private Map<Integer, Map<String, TEMP>> varScopeMap = new HashMap<Integer,Map<String, TEMP>>();
	public TEMP shared_return_temp = null;
	public String shared_return_label = null;
	public TEMP getFreshTEMP() {
		TEMP t = new TEMP(counter++);
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
		System.out.format("beginScope - prev scope = %s\n", this.scope);
		this.scope++;
		Map<String, TEMP> scopeMap = varScopeMap.get(this.scope);
		System.out.format("beginScope - new scope = %s\n", this.scope);

		if (scopeMap == null) {
			varScopeMap.put(this.scope, new HashMap());
		} else {
			System.out.format("######### ERROR beginScope ############\n");
		}
	}

	public void endScope(int scope) {
		varScopeMap.remove(this.scope);
		System.out.format("endScope - prev scope = %s\n", this.scope);
		this.scope--;
		System.out.format("endScope - new scope = %s\n", this.scope);


	}

	public String create_shared_return_label() {
		int randomNum = ThreadLocalRandom.current().nextInt(10000, 100000 + 1);

		shared_return_label = String.format("RETURN_%s", randomNum);
		System.out.format("create shared_return_label = %s\n", shared_return_label);
		return shared_return_label;
	}

	public String fetch_shared_return_label() {
		System.out.format("fetch shared_return_label = %s\n", shared_return_label);
		return shared_return_label;
	}

	public TEMP create_shared_return_temp() {
		shared_return_temp = getFreshTEMP();
		return shared_return_temp;
	}

	public TEMP fetch_shared_return_temp() {
		return shared_return_temp;
	}

	public TEMP fetchTempFromScope(String var_name, int scope, boolean autoCreate) {
		System.out.format("fetchTempFromScope - var_name=%s\nscope=%d\nautoCreate=%s\n",var_name, scope, autoCreate);
		// Fetch the scope map and allocate if non-exists
		Map<String, TEMP> scopeMap = varScopeMap.get(this.scope);
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
			System.out.format("fetchTempFromScope - DID find var_name=%s, in scope=%d, created=%d\n",var_name, scope,t.getSerialNumber());
		}
		//update not sure if needed - not familiar with java reference / value
		varScopeMap.put(this.scope, scopeMap);
		return t;
	}

	public TEMP findVarRecursive(String var_name, int scope) {

			for (int i = this.scope; i >= 0; i--) {
				// System.out.format("findVarRecursive - i(%s) name = %s, main scope = %s\n",i, var_name, scope);
				Map<String, TEMP> scopeMap = varScopeMap.get(i);
				// System.out.format("findVarRecursive scopeMap %s in scope %s\n", scopeMap, scope);
				if (scopeMap != null) {
					TEMP t = scopeMap.get(var_name);
					// System.out.format("findVarRecursive t %s in scope %s\n", t, scope);
					if (t != null) {
						return t;
					}
				}
			}
			System.out.format("findVarRecursive DINT Find %s in scope %s\n", var_name, scope);
			return null;
	}
}
