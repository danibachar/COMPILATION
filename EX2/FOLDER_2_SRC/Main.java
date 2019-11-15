
import java.io.*;
import java.io.PrintWriter;
import java_cup.runtime.Symbol;


import AST.*;

public class Main
{
	static public void main(String argv[])
	{
		Lexer l = null;
		Parser p;
		Symbol s;
		AST_DEC_LIST AST;
		FileReader file_reader;
		PrintWriter file_writer;
		String inputFilename = argv[0];
		String outputFilename = argv[1];

		try
		{
			/********************************/
			/* [1] Initialize a file reader */
			/********************************/
			file_reader = new FileReader(inputFilename);

			/********************************/
			/* [2] Initialize a file writer */
			/********************************/
			file_writer = new PrintWriter(outputFilename);

			/******************************/
			/* [3] Initialize a new lexer */
			/******************************/
			l = new Lexer(file_reader);

			/*******************************/
			/* [4] Initialize a new parser */
			/*******************************/
			p = new Parser(l, file_writer);

			/***********************************/
			/* [5] 3 ... 2 ... 1 ... Parse !!! */
			/***********************************/
			AST = (AST_DEC_LIST) p.parse().value;

			/*************************/
			/* [6] Print the AST ... */
			/*************************/
			AST.PrintMe();

			/*************************/
			/* [7] Close output file */
			/*************************/
			file_writer.print("OK");
			file_writer.close();

			/*************************************/
			/* [8] Finalize AST GRAPHIZ DOT file */
			/*************************************/
			AST_GRAPHVIZ.getInstance().finalizeFile();
    	}
		catch (Error error) {
      try {
        file_writer = new PrintWriter(outputFilename);
        file_writer.print("ERROR[");
        file_writer.print(l.getLine());
        file_writer.print(",");
        file_writer.print(l.getCharPos());
				file_writer.print("]");
        file_writer.print("\n");
        file_writer.close();
      }
      catch (Exception ex) {}
      error.printStackTrace();
    }
		catch (Exception e)
		{
      try {
        file_writer = new PrintWriter(outputFilename);
        file_writer.print("ERROR[");
        file_writer.print(l.getLine());
        file_writer.print(",");
        file_writer.print(l.getCharPos());
				file_writer.print("]");
        file_writer.print("\n");
        file_writer.close();
      }
      catch (Exception ex) {}
			e.printStackTrace();
		}
	}
}
