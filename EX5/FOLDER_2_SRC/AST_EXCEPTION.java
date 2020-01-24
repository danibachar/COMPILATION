package AST_EXCEPTION;

import AST.*;
import LLVM.*;

public class AST_EXCEPTION extends Exception {
    public Integer errorLineNumber;

    public AST_EXCEPTION(Integer errorLineNumber) {
        this.errorLineNumber = errorLineNumber;
    }
}
