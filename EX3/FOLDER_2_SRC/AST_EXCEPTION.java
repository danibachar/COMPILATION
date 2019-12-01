package AST_EXCEPTION;

import AST.*;

public class AST_EXCEPTION extends Exception {
    public AST_Node node;

    public AST_EXCEPTION(AST_Node node) {
        this.node = node;
    }
}
