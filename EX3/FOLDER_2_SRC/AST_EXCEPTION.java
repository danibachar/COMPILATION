package AST_EXCEPTION;

import AST.*;

public class AST_EXCEPTION extends Exception {
    public Integer errorLineNumber;

    public AST_EXCEPTION(Integer errorLineNumber) {
        this.errorLineNumber = errorLineNumber;
    }
}
