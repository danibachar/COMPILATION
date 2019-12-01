package TYPES;

public class TYPE_ARRAY extends TYPE {

    public TYPE type;

    public TYPE_ARRAY(String name, TYPE type) {
        this.name = name;
        this.type = type;
    }

    @Override
    public boolean isArray() { return true; }
}
