/***********/
/* PACKAGE */
/***********/
package TEMP;
import TYPES.*;

/*******************/
/* GENERAL IMPORTS */
/*******************/

/*******************/
/* PROJECT IMPORTS */
/*******************/

public class TEMP
{
	private int serial=0;
	public TYPE type;
	public boolean isaddr;
	public boolean checkInit=false;

	public  TEMP(){}

	public TEMP(int serial)
	{
		this.serial = serial;
		this.type = null;
	}

	public int getSerialNumber()
	{
		return serial;
	}

	public void setType(TYPE type)
	{
		this.type = type;
	}

	public TYPE getType()
	{
		return this.type;
	}

}
