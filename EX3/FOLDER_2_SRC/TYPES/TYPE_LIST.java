package TYPES;

public class TYPE_LIST extends TYPE
{
	/****************/
	/* DATA MEMBERS */
	/****************/
	public TYPE head;
	public TYPE_LIST tail;

	/******************/
	/* CONSTRUCTOR(S) */
	/******************/
	public TYPE_LIST(TYPE head,TYPE_LIST tail)
	{
		this.head = head;
		this.tail = tail;
	}

	public void PrintMyType() {
		if (head == null && tail == null) {
			System.out.format("### TYPE_LIST head and tail are null, empty list early return\n");
			return;
		}

		if (head == null) {
			System.out.format("### TYPE_LIST Init with null head! aborting!!!\n");
			return;
		}

		System.out.format("### TYPE_LIST Init new TYPE_LIST - head = %s\n",head.name);

		if (tail == null) {
			System.out.format("### TYPE_LIST Init with null tail - null tail is acceptable\n");
		}

		for (TYPE_LIST it=tail;it != null;it=it.tail)
		{
			if (it.head != null) {
					System.out.format("### TYPE_LIST Iterations = %s\n",it.head.name);
			} else {
				System.out.format("### TYPE_LIST Iterations it.head is null\n");
			}

		}
	}
}
