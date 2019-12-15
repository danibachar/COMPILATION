/***********/
/* PACKAGE */
/***********/
package SYMBOL_TABLE;

/*******************/
/* GENERAL IMPORTS */
/*******************/
import java.io.PrintWriter;
import java.util.List;

/*******************/
/* PROJECT IMPORTS */
/*******************/
import TYPES.*;

/****************/
/* SYMBOL TABLE */
/****************/
public class SYMBOL_TABLE
{
	private int hashArraySize = 13;
	public int scopeCount = 0;
	/**********************************************/
	/* The actual symbol table data structure ... */
	/**********************************************/
	private SYMBOL_TABLE_ENTRY[] table = new SYMBOL_TABLE_ENTRY[hashArraySize];
	private SYMBOL_TABLE_ENTRY top;
	private int top_index = 0;

	public TYPE_CLASS current_class;
	public TYPE_FUNCTION current_function;

	/**************************************************************/
	/* A very primitive hash function for exposition purposes ... */
	/**************************************************************/
	private int hash(String s)
	{
		if (s.charAt(0) == 'l') {return 1;}
		if (s.charAt(0) == 'm') {return 1;}
		if (s.charAt(0) == 'r') {return 3;}
		if (s.charAt(0) == 'i') {return 6;}
		if (s.charAt(0) == 'd') {return 6;}
		if (s.charAt(0) == 'k') {return 6;}
		if (s.charAt(0) == 'f') {return 6;}
		if (s.charAt(0) == 'S') {return 6;}
		return 12;
	}

	private String currScopeName()
	{
		return String.format("SCOPE-BOUNDARY#%d", scopeCount);
	}

	/****************************************************************************/
	/* Enter a variable, function, class type or array type to the symbol table */
	/****************************************************************************/
	public void enter(String name, TYPE t)
	{
		/*************************************************/
		/* [1] Compute the hash value for this new entry */
		/*************************************************/
		if (t.isFunc()) {
			TYPE_FUNCTION f = (TYPE_FUNCTION)t;
			// System.out.format("######### - Entering FUNC name - %s to table symbole with returnType = %s\n",name, f.returnType);
		} else if (t.isClass()) {
			TYPE_CLASS c = (TYPE_CLASS)t;
			// System.out.format("######### - Entering CLASS name - %s to table symbole\n",name);
			if (c.data_members != null){
				// System.out.format("######### - Data Members \n");
				// c.data_members.PrintMyType();
			}
			if (c.methods != null){
				// System.out.format("######### - Methods \n");
				// c.methods.PrintMyType();
			}
		} else if (t.isArray()) {
			TYPE_ARRAY a = (TYPE_ARRAY)t;
			// System.out.format("######### - Entering ARRAY name - %s to table symbole with type = %s\n",name, a.type.name);
		} else {
			// System.out.format("######### - Entering Primitive - %s to table symbole with type = `%s`\n",name, t.name);
		}

		int hashValue = hash(name);

		/******************************************************************************/
		/* [2] Extract what will eventually be the next entry in the hashed position  */
		/*     NOTE: this entry can very well be null, but the behaviour is identical */
		/******************************************************************************/
		SYMBOL_TABLE_ENTRY next = table[hashValue];

		/**************************************************************************/
		/* [3] Prepare a new symbol table entry with name, type, next and prevtop */
		/**************************************************************************/
		SYMBOL_TABLE_ENTRY e = new SYMBOL_TABLE_ENTRY(name,t,hashValue,next,top,top_index++, scopeCount);

		/**********************************************/
		/* [4] Update the top of the symbol table ... */
		/**********************************************/
		top = e;

		/****************************************/
		/* [5] Enter the new entry to the table */
		/****************************************/
		table[hashValue] = e;

		/**************************/
		/* [6] Print Symbol Table */
		/**************************/
		PrintMe();
	}

	/***********************************************/
	/* Find the inner-most scope element with name */
	/***********************************************/
	public TYPE find(String name)
	{

		SYMBOL_TABLE_ENTRY e;
		for (e = table[hash(name)]; e != null; e = e.next)
		{
			if (name.equals(e.name))
			{
				return e.type;
			}
		}

		return null;
	}

	public TYPE findInCurrentScope(String name)
	{
		// System.out.format("######### - Search in Scope = %d\n", scopeCount);
		SYMBOL_TABLE_ENTRY e = top;
		while (e != null && e.name != "SCOPE-BOUNDARY")
		{
			// System.out.format("findInCurrentScope `%s`\n checking - `%s`\n",name ,e.name);
			if (name.equals(e.name)) {
				return e.type;
			}
			e = e.next;
		}
		// System.out.format("findInCurrentScope Didn't find\n");
		return null;
	}

	public TYPE findFunc(String name, boolean searchOutsideOfScope) {
		// System.out.format("findFunc `%s`\n",name );
		// System.out.format("findFunc `%s`\n",current_class );
		// Search in current function first
		if (current_function != null) {
				// System.out.format("findFunc in curr function scope first `%s`\n",current_function.name );
				TYPE t = findInCurrentScope(name);
				if (t != null) { return t; }
		}
		// Search in current class recursively up the inheritance tree second
		if (!searchOutsideOfScope && current_class != null) {
				// System.out.format("findFunc in class `%s`\n",current_function.name );
				TYPE t = current_class.queryMethodsReqursivly(name);
				if (t != null) { return t; }
		}

		// Last just look for enything, please!!!
		return find(name);
	}

	public TYPE findField(String name, boolean searchOutsideOfScope) {
		// System.out.format("findField `%s`\n",name );
		// Search in current function first
		if (current_function != null) {
			// System.out.format("findField in curr function scope first `%s`\n",current_function.name );
				TYPE t = findInCurrentScope(name);
				if (t != null) { return t; }
		}
		// Search in current class recursively up the inheritance tree second
		if (!searchOutsideOfScope && current_class != null) {
				TYPE t = current_class.queryDataMembersReqursivly(name);
				if (t != null) { return t; }
		}

		// Last just look for enything, please!!!
		return find(name);
	}

	/***************************************************************************/
	/* begine scope = Enter the <SCOPE-BOUNDARY> element to the data structure */
	/***************************************************************************/
	public void beginScope()
	{
		/************************************************************************/
		/* Though <SCOPE-BOUNDARY> entries are present inside the symbol table, */
		/* they are not really types. In order to be ablt to debug print them,  */
		/* a special TYPE_FOR_SCOPE_BOUNDARIES was developed for them. This     */
		/* class only contain their type name which is the bottom sign: _|_     */
		/************************************************************************/
		// String currScope = currScopeName();
		// System.out.format("######### - BEGIN - %s\n", "SCOPE-BOUNDARY");

		enter( "SCOPE-BOUNDARY",new TYPE_FOR_SCOPE_BOUNDARIES("NONE") );
		scopeCount+=1;
		/*********************************************/
		/* Print the symbol table after every change */
		/*********************************************/
		PrintMe();
	}

	/********************************************************************************/
	/* end scope = Keep popping elements out of the data structure,                 */
	/* from most recent element entered, until a <NEW-SCOPE> element is encountered */
	/********************************************************************************/
	public void endScope()
	{
		/**************************************************************************/
		/* Pop elements from the symbol table stack until a SCOPE-BOUNDARY is hit */
		/**************************************************************************/
		// String currScope = currScopeName();
		// System.out.format("######### - ENDING - Start Poping - %s\n", "SCOPE-BOUNDARY");
		while (top.name != "SCOPE-BOUNDARY")
		{
			// System.out.format("poping elemets %s in scope-%s\n",top.name, scopeCount);
			table[top.index] = top.next;
			top_index = top_index-1;
			top = top.prevtop;
		}
		/**************************************/
		/* Pop the SCOPE-BOUNDARY sign itself */
		/**************************************/
		table[top.index] = top.next;
		top_index = top_index-1;
		top = top.prevtop;
		// System.out.format("######### - ENDED - %s\n", "SCOPE-BOUNDARY");
		scopeCount-=1;
		/*********************************************/
		/* Print the symbol table after every change */
		/*********************************************/
		PrintMe();
	}

	public static int n=0;

	public void PrintMe()
	{
		int i=0;
		int j=0;
		String dirname="./FOLDER_5_OUTPUT/";
		String filename=String.format("SYMBOL_TABLE_%d_IN_GRAPHVIZ_DOT_FORMAT.txt",n++);

		try
		{
			/*******************************************/
			/* [1] Open Graphviz text file for writing */
			/*******************************************/
			PrintWriter fileWriter = new PrintWriter(dirname+filename);

			/*********************************/
			/* [2] Write Graphviz dot prolog */
			/*********************************/
			fileWriter.print("digraph structs {\n");
			fileWriter.print("rankdir = LR\n");
			fileWriter.print("node [shape=record];\n");

			/*******************************/
			/* [3] Write Hash Table Itself */
			/*******************************/
			fileWriter.print("hashTable [label=\"");
			for (i=0;i<hashArraySize-1;i++) { fileWriter.format("<f%d>\n%d\n|",i,i); }
			fileWriter.format("<f%d>\n%d\n\"];\n",hashArraySize-1,hashArraySize-1);

			/****************************************************************************/
			/* [4] Loop over hash table array and print all linked lists per array cell */
			/****************************************************************************/
			for (i=0;i<hashArraySize;i++)
			{
				if (table[i] != null)
				{
					/*****************************************************/
					/* [4a] Print hash table array[i] -> entry(i,0) edge */
					/*****************************************************/
					fileWriter.format("hashTable:f%d -> node_%d_0:f0;\n",i,i);
				}
				j=0;
				for (SYMBOL_TABLE_ENTRY it=table[i];it!=null;it=it.next)
				{
					/*******************************/
					/* [4b] Print entry(i,it) node */
					/*******************************/
					fileWriter.format("node_%d_%d ",i,j);
					fileWriter.format("[label=\"<f0>%s|<f1>%s|<f2>prevtop=%d|<f3>next|<f4>scope=%d\"];\n",
						it.name,
						it.type.name,
						it.prevtop_index,
						it.scope_number);

					if (it.next != null)
					{
						/***************************************************/
						/* [4c] Print entry(i,it) -> entry(i,it.next) edge */
						/***************************************************/
						fileWriter.format(
							"node_%d_%d -> node_%d_%d [style=invis,weight=10];\n",
							i,j,i,j+1);
						fileWriter.format(
							"node_%d_%d:f3 -> node_%d_%d:f0;\n",
							i,j,i,j+1);
					}
					j++;
				}
			}
			fileWriter.print("}\n");
			fileWriter.close();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	/**************************************/
	/* USUAL SINGLETON IMPLEMENTATION ... */
	/**************************************/
	private static SYMBOL_TABLE instance = null;

	/*****************************/
	/* PREVENT INSTANTIATION ... */
	/*****************************/
	protected SYMBOL_TABLE() {}

	/******************************/
	/* GET SINGLETON INSTANCE ... */
	/******************************/
	public static SYMBOL_TABLE getInstance()
	{
		if (instance == null)
		{
			/*******************************/
			/* [0] The instance itself ... */
			/*******************************/
			instance = new SYMBOL_TABLE();

			/*****************************************/
			/* [1] Enter primitive types int, string */
			/*****************************************/
			instance.enter("int",    TYPE_INT.getInstance());
			instance.enter("string", TYPE_STRING.getInstance());
			instance.enter("void",   TYPE_VOID.getInstance());

			/*************************************/
			/* [2] How should we handle void ??? */
			/*************************************/

			/***************************************/
			/* [3] Enter library function PrintInt */
			/***************************************/
			instance.enter(
				"PrintInt",
				new TYPE_FUNCTION(
					TYPE_VOID.getInstance(),
					"PrintInt",
					new TYPE_LIST(TYPE_INT.getInstance(), null)
				)
			);

			instance.enter(
				"PrintString",
				new TYPE_FUNCTION(
					TYPE_VOID.getInstance(),
					"PrintString",
					new TYPE_LIST(TYPE_STRING.getInstance(),null)
				)
			);

			instance.enter(
				"PrintTrace",
				new TYPE_FUNCTION(
					TYPE_VOID.getInstance(),
					"PrintTrace",
					new TYPE_LIST(TYPE_VOID.getInstance(),null)
				)
			);
		}
		return instance;
	}
}
