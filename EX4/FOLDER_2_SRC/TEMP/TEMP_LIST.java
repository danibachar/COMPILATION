package TEMP;

public class TEMP_LIST extends TEMP
{
    /****************/
    /* DATA MEMBERS */
    /****************/
    public TEMP head;
    public TEMP_LIST tail;

    /******************/
    /* CONSTRUCTOR(S) */
    /******************/
    public TEMP_LIST(){

    }
    public TEMP_LIST(TEMP head,TEMP_LIST tail)
    {
        this.head = head;
        this.tail = tail;
    }
}