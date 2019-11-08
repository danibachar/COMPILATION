
import java.io.*;
import java.io.PrintWriter;
import java.lang.Math;

import java_cup.runtime.Symbol;

public class Main
{
	static public void main(String argv[])
	{
		Lexer l;
		Symbol s;
		FileReader file_reader;
		PrintWriter file_writer;
		String inputFilename = argv[0];
		String outputFilename = argv[1];
    int MAX_INT = ( (int) Math.pow(2,15) )-1;
    int MIN_INT = - (int) Math.pow(2,15);

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

			/***********************/
			/* [4] Read next token */
			/***********************/
			s = l.next_token();

			/********************************/
			/* [5] Main reading tokens loop */
			/********************************/
			while (s.sym != TokenNames.EOF)
			{
				/************************/
				/* [6] Print to console */
				/************************/
				System.out.print("[");
				System.out.print(l.getLine());
				System.out.print(",");
				System.out.print(l.getTokenStartPosition());
				System.out.print("]:");
				System.out.print(s.value);
				System.out.print("\n");

				/*********************/
				/* [7] Print to file */
				/*********************/
        switch (s.sym) {
          case TokenNames.MINUS:
            file_writer.print("MINUS");
            break;
          case TokenNames.DIVIDE:
            file_writer.print("DIVIDE");
            break;
          case TokenNames.PLUS:
            file_writer.print("PLUS");
            break;
          case TokenNames.TIMES:
            file_writer.print("TIMES");
            break;
          case TokenNames.GT:
            file_writer.print("GT");
            break;
          case TokenNames.LT:
            file_writer.print("LT");
            break;
          case TokenNames.EQ:
            file_writer.print("EQ");
            break;
          case TokenNames.ASSIGN:
            file_writer.print("ASSIGN");
            break;
          case TokenNames.SEMICOLON:
            file_writer.print("SEMICOLON");
            break;
          case TokenNames.DOT:
            file_writer.print("DOT");
            break;
          case TokenNames.COMMA:
            file_writer.print("COMMA");
            break;
          case TokenNames.RPAREN:
            file_writer.print("RPAREN");
            break;
          case TokenNames.LPAREN:
            file_writer.print("LPAREN");
            break;
          case TokenNames.LBRACE:
            file_writer.print("LBRACE");
            break;
          case TokenNames.RBRACE:
            file_writer.print("RBRACE");
            break;
          case TokenNames.LBRACK:
            file_writer.print("LBRACK");
            break;
          case TokenNames.RBRACK:
            file_writer.print("RBRACK");
            break;
          case TokenNames.NUMBER:
            int firstVal = Character.getNumericValue( String.valueOf(s.value).charAt(0) );
            int value = (int) s.value;
            // Handling negative zero
            System.out.print(String.valueOf(s.value));
            System.out.print(" | ");
            System.out.print(firstVal);
            System.out.print("-");
            System.out.print(value);
            // Validating leading zeros
            if (firstVal == 0 && value != 0) { throw new Exception("Leading Zeros"); }
            // Validating min/max possible ints
            if (value > MAX_INT) { throw new Exception("MAX_INT"); }
            if (value < MIN_INT) { throw new Exception("MIN_INT"); }
            file_writer.print("INT");
            file_writer.print("(");
            file_writer.print(value);
            file_writer.print(")");
            break;
          case TokenNames.ID:
            char first = String.valueOf(s.value).charAt(0);
            // Handling ID first char is not acceptible
            if ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_".indexOf(first) == -1) {
              throw new Exception("ID_ERROR");
            }
            file_writer.print("ID");
            file_writer.print("(");
            file_writer.print(s.value);
            file_writer.print(")");
            break;
          case TokenNames.STRING:
            file_writer.print("STRING");
            file_writer.print("(");
            file_writer.print(s.value);
            file_writer.print(")");
            break;
          case TokenNames.RETURN:
            file_writer.print("RETURN");
            break;
          case TokenNames.IF:
            file_writer.print("IF");
            break;
          case TokenNames.WHILE:
            file_writer.print("WHILE");
            break;
          case TokenNames.CLASS:
            file_writer.print("CLASS");
            break;
          case TokenNames.ARRAY:
            file_writer.print("ARRAY");
            break;
          case TokenNames.NEW:
            file_writer.print("NEW");
            break;
          case TokenNames.EXTENDS:
            file_writer.print("EXTENDS");
            break;
          case TokenNames.NIL:
            file_writer.print("NIL");
            break;
          case TokenNames.error:
            throw new Exception("Regex Error");
          default:
            throw new Exception("Un handled Token");
            break;
        }
        file_writer.print("[");
        file_writer.print(l.getLine());
        file_writer.print(",");
        file_writer.print(l.getTokenStartPosition());
        file_writer.print("]");
				file_writer.print("\n");

				/***********************/
				/* [8] Read next token */
				/***********************/
				s = l.next_token();
			}

			/******************************/
			/* [9] Close lexer input file */
			/******************************/
			l.yyclose();

			/**************************/
			/* [10] Close output file */
			/**************************/
			file_writer.close();
    	}

		catch (Exception e)
		{

      try {
  			file_writer = new PrintWriter(outputFilename);
        file_writer.print("ERROR");
        file_writer.close();
      }
      catch (Exception e1) {}
			e.printStackTrace();
		}
	}
}
