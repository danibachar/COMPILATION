package TYPES;

import AST.*;

public class TYPE_ARRAY extends TYPE {

    public TYPE type;

    public TYPE_ARRAY(String name, TYPE type) {
        this.name = name;
        this.type = type;
    }

    public boolean isArray() { return true; }

    public boolean equals(Object otherType)
    {
      if (otherType instanceof TYPE_NIL)
      {
        return true;
      }
      return super.equals(otherType);
    }

    public boolean isAssignableFrom(TYPE t)
    {
      // System.out.format("TYPE_ARRAY isAssignableFrom - t = %s\n", t);
      // System.out.format("TYPE_ARRAY isAssignableFrom - myType = %s\n", type);

      if (t.isClassVar()) {
  			TYPE_CLASS_VAR_DEC tv = (TYPE_CLASS_VAR_DEC)t;
  			TYPE_CLASS tc = (TYPE_CLASS)tv.t;
        return equals(t) || t == TYPE_NIL.getInstance();
  		}
      return equals(t) || t == TYPE_NIL.getInstance();
    }
}
