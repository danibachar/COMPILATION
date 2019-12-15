
import java.io.*;
import java.io.PrintWriter;
import java_cup.runtime.Symbol;
import AST.*;
import AST_EXCEPTION.*;

public class Main
{
	static public void main(String argv[])
	{
		Lexer l = null;;
		Parser p = null;;;
		Symbol s = null;;;
		AST_DEC_LIST AST;
		FileReader file_reader = null;;
		PrintWriter file_writer = null;;
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

			/**************************/
			/* [7] Semant the AST ... */
			/**************************/
			AST.SemantMe();

			/*************************/
			/* [8] Close output file */
			/*************************/
			file_writer.print("OK\n");
			file_writer.close();

			/*************************************/
			/* [9] Finalize AST GRAPHIZ DOT file */
			/*************************************/
			AST_GRAPHVIZ.getInstance().finalizeFile();

    } catch (AST_EXCEPTION e) {
			// Semantic Exception handling, thrown from within th AST_Node
			int lineNumber = e.errorLineNumber;
			System.out.print("ERROR");
			System.out.print("(");
			System.out.print(lineNumber);
			System.out.print(")\n");

			file_writer.print("ERROR");
			file_writer.print("(");
			file_writer.print(lineNumber);
			file_writer.print(")\n");
			file_writer.close();
		} catch (Exception e) {
			// Lex Exception handling, thrown from Lexer
			try {
				int lineNumber = l.getLine();
				System.out.print("ERROR");
				System.out.print("(");
				System.out.print(lineNumber);
				System.out.print(")\n");

				file_writer.print("ERROR");
				file_writer.print("(");
				file_writer.print(lineNumber);
				file_writer.print(")\n");
				file_writer.close();
			}
			catch (Exception ex) {}
			e.printStackTrace();
		}
	}
}
