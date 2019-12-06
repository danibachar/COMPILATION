package TYPES;

public class TYPE_CLASS_VAR_DEC_LIST extends TYPE
{
	public TYPE_CLASS_VAR_DEC head;
	public TYPE_CLASS_VAR_DEC_LIST tail;

	public TYPE_CLASS_VAR_DEC_LIST(TYPE_CLASS_VAR_DEC head,TYPE_CLASS_VAR_DEC_LIST tail)
	{
		this.head = head;
		this.tail = tail;
	}

	public void PrintMyType() {
		if (head == null && tail == null) {
			System.out.format("### TYPE_CLASS_VAR_DEC_LIST head and tail are null, empty list early return\n");
			return;
		}

		if (head == null) {
			System.out.format("### TYPE_CLASS_VAR_DEC_LIST Init with null head! aborting!!!\n");
			return;
		}

		System.out.format("### TYPE_CLASS_VAR_DEC_LIST Init new TYPE_LIST - head = %s\n",head.name);

		if (tail == null) {
			System.out.format("### TYPE_CLASS_VAR_DEC_LIST Init with null tail - null tail is acceptable\n");
		}

		for (TYPE_CLASS_VAR_DEC_LIST it=tail;it != null;it=it.tail)
		{
			if (it.head != null) {
					System.out.format("### TYPE_CLASS_VAR_DEC_LIST Iterations = %s\n",it.head.name);
			} else {
				System.out.format("### TYPE_CLASS_VAR_DEC_LIST Iterations it.head is null\n");
			}

		}
	}
}
