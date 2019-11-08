public interface TokenNames {
  /* terminals */
  public static final int MINUS = 3;
  public static final int DIVIDE = 5;
  public static final int TIMES = 4;
  public static final int PLUS = 2;
  public static final int SEMICOLON = 8;
  public static final int COMMA = 16;
  public static final int DOT = 17;
  public static final int ASSIGN = 18;
  public static final int EQ = 19;
  public static final int LT = 20;
  public static final int GT = 21;

  public static final int RPAREN = 7;
  public static final int LPAREN = 6;
  public static final int LBRACE = 11;
  public static final int RBRACE = 12;
  public static final int LBRACK = 13;
  public static final int RBRACK = 14;

  public static final int NUMBER = 9;
  public static final int ID = 10;
  public static final int STRING = 15;

  public static final int RETURN = 22;
  public static final int IF = 23;
  public static final int WHILE = 24;
  public static final int CLASS = 25;
  public static final int ARRAY = 26;
  public static final int NEW = 27;
  public static final int EXTENDS = 28;
  public static final int NIL = 29;

  public static final int EOF = 0;
  public static final int error = 1;
  public static final int COMMENT = -1;
}
