package TYPES;

public class TYPE_ARRAY extends TYPE {

    public TYPE type;

    public TYPE_ARRAY(String name, TYPE type) {
        this.name = name;
        this.type = type;
    }

    @Override
    public boolean isArray() { return true; }

    public boolean equals(Object obj)
    {
      return obj instanceof TYPE_ARRAY && ((TYPE_ARRAY) obj).name.equals(name) && ((TYPE_ARRAY) obj).type.equals(type);
    }

    public boolean isAssignableFrom(TYPE t)
    {
      if (t.isClassVar()) {
  			TYPE_CLASS_VAR_DEC tv = (TYPE_CLASS_VAR_DEC)t;
  			TYPE_CLASS tc = (TYPE_CLASS)tv.t;
        return equals(t) || tc == type || t == TYPE_NIL.getInstance();
  		}
      return equals(t) || t == type || t == TYPE_NIL.getInstance();
    }
}
