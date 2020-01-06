package AST;

import TEMP.*;
import IR.*;
import MIPS.*;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

import java.util.*;
import javafx.util.Pair;

public class AST_HELPERS
{
  static public void isValidTypeAssignableFromExpression(TYPE t, AST_EXP exp) throws Exception
  {
    if (t == null && exp == null) {
      System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",exp.lineNumber);
      throw new AST_EXCEPTION(exp.lineNumber);
    }
    if (exp == null) {
      System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",exp.lineNumber);
      throw new AST_EXCEPTION(exp.lineNumber);
    }
    TYPE tValue = exp.SemantMe();
    if (tValue == null) {
      System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",exp.lineNumber);
      throw new AST_EXCEPTION(exp.lineNumber);
    }

    // Test NIL
    if(tValue == TYPE_NIL.getInstance()) {
      if (t.isClass()) {
        return;
      }
      if (t.isArray()) {
        return;
      }
      System.out.format(">> ERROR [%d] trying to assign NIL into not Array or Class Var(%s)\n",exp.lineNumber, t);
      throw new AST_EXCEPTION(exp.lineNumber);
    }

    if (t.isClass()) {
      TYPE_CLASS tc = (TYPE_CLASS)t;
      if (tValue.isClassVar()) {
        TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
        if (!tc.isAssignableFrom(testInitVlueType.t)) {
          System.out.format(">> ERROR [%d] 1-trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp.lineNumber);
        }
      } else if (!tc.isAssignableFrom(tValue)) {
        System.out.format(">> ERROR [%d] 2-trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
        throw new AST_EXCEPTION(exp.lineNumber);
      }
    }

    if (t.isArray()) {
      TYPE_ARRAY tc = (TYPE_ARRAY)t;
      if (tValue.isClassVar()) {
        TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
        if (!tc.isAssignableFrom(testInitVlueType.t)) {
          System.out.format(">> 1 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, testInitVlueType.t);
          throw new AST_EXCEPTION(exp.lineNumber);
        }
      } else if (exp.isNewArray()) {
        if (tValue != tc.type) {
          System.out.format(">> 2 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp.lineNumber);
        }
      } else if (!tc.isAssignableFrom(tValue)) {
        System.out.format(">> 3 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
        throw new AST_EXCEPTION(exp.lineNumber);
      }
      return;
    }

    if (t.isClassVar()) {
      TYPE_CLASS_VAR_DEC tcv = (TYPE_CLASS_VAR_DEC)t;
      // Allow Assignment for class nil or inheritance support
      if (tcv.t.isClass()) {
        TYPE_CLASS tc = (TYPE_CLASS)tcv.t;
        if (tValue.isClassVar()) {
          TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
          if (!tc.isAssignableFrom(testInitVlueType.t)) {
            System.out.format(">> (1) ERROR [%d] trying assign class(%s) with the value(%s) \n",exp.lineNumber,tc, testInitVlueType.t);
            throw new AST_EXCEPTION(exp.lineNumber);
          }
        } else if (!tc.isAssignableFrom(tValue)) {
          System.out.format(">> (2) ERROR [%d] trying assign class(%s) with the value(%s) \n",exp.lineNumber,tc, tValue);
          throw new AST_EXCEPTION(exp.lineNumber);
        }

      }
      // Allow Assignment for array - nil or same array?
      if (tcv.t.isArray()) {
        TYPE_ARRAY tc = (TYPE_ARRAY)tcv.t;
        if (tValue.isClassVar()) {
          TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
          if (!tc.isAssignableFrom(testInitVlueType.t)) {
            System.out.format(">> 1 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, testInitVlueType.t);
            throw new AST_EXCEPTION(exp.lineNumber);
          }
        } else if (exp.isNewArray()) {
          if (tValue != tc.type) {
            System.out.format(">> 2 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
            throw new AST_EXCEPTION(exp.lineNumber);
          }
        } else if (!tc.isAssignableFrom(tValue)) {
          System.out.format(">> 3 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp.lineNumber);
        }
        return;
        // if (tValue.isClassVar()) {
        //   TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
        //   if (!tc.isAssignableFrom(testInitVlueType.t)) {
        //     System.out.format(">> (3) ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,tc.name, testInitVlueType.t);
        //     throw new AST_EXCEPTION(exp.lineNumber);
        //   }
        // } else if (!tc.isAssignableFrom(tValue)) {
        //   System.out.format(">> (4) ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,tc.name, tValue);
        //   throw new AST_EXCEPTION(exp.lineNumber);
        // }
      }
      // ALLOW SIMPLE Assignment
      if (tcv.t.getClass() == tValue.getClass()) {
        return;
      }
      /// NOTE W are done with handling class var dic we are ok, fuck i need to rewrite this...
      // return;
    }


    if (t.getClass() == tValue.getClass()) {
      return;
    }

    // Test Class To Class Assignment
    if (t.isClass() && tValue.isClass()) {
      TYPE_CLASS t1_cast = (TYPE_CLASS)t;
      TYPE_CLASS t2_cast = (TYPE_CLASS)tValue;
      if (t1_cast.isAssignableFrom(t2_cast)) {
        return;
      }
      System.out.format(">> ERROR [%d] Assinging class(%s) to class(%s) is forbidden \n",exp.lineNumber,t1_cast,t2_cast);
      throw new AST_EXCEPTION(exp.lineNumber);
    }

    if (t.isArray() && tValue.isArray()) {
      TYPE_ARRAY t1_cast = (TYPE_ARRAY)t;
      TYPE_ARRAY t2_cast = (TYPE_ARRAY)tValue;
      if (t1_cast.isAssignableFrom(t2_cast)) {
        return;
      }
      System.out.format(">> ERROR [%d] Assinging array(%s) to array(%s) is forbidden \n",exp.lineNumber,t1_cast,t2_cast);
      throw new AST_EXCEPTION(exp.lineNumber);
    }


    System.out.format(">> ERROR [%d] type mismatch for var(%s) := exp(%s)\n",exp.lineNumber,t,tValue);
    throw new AST_EXCEPTION(exp.lineNumber);
  }


  static public void update_constants_if_needed(String name, AST_EXP e) throws Exception {
    System.out.format("update_constants_if_needed - name(%s), exp(%s)\n", name, e);
    if (e instanceof AST_EXP_STRING) {
      AST_EXP_STRING es = (AST_EXP_STRING)e;
      // // Adding to context - will be needed later
      // Pair<String, AST_EXP> p = new Pair<String, AST_EXP>(name, es);
      // IR.getInstance().constants.add(p);
      // actual comamand
      IR.getInstance()
        .Add_IRcommand(new IRcommandConstString(name, es.value));
    } else if (e instanceof AST_EXP_INT) {
      throw new AST_EXCEPTION(e.lineNumber);
    // } else if (t.isClass()) {
    //   throw new AST_EXCEPTION(this.lineNumber);
    // } else if (t.isArray()) {
    //   throw new AST_EXCEPTION(this.lineNumber);
    // } else if (t == TYPE_NIL.getInstance()) {
    //   throw new AST_EXCEPTION(this.lineNumber);
    // } else if (t == TYPE_VOID.getInstance()) {
    } else {
      throw new AST_EXCEPTION(e.lineNumber);
    }


  }

  static public int type_to_align(TYPE t) {
    int align = 4;
    if (t == null) {
      return align;
    }
    if (t.isClassVar()) {
      TYPE_CLASS_VAR_DEC tc = (TYPE_CLASS_VAR_DEC)t;
      t = tc.t;
    }
    if (t == null || t == TYPE_VOID.getInstance()) {
      return align;
    }

    if (t.isClass() || t.isArray()) {
      align = 8;
    }
    if (t == TYPE_STRING.getInstance()) {
      align = 8;
    }
    return align;
  }

  static public String type_to_def_ret_val(TYPE t) {
    if (t.isClassVar()) {
      TYPE_CLASS_VAR_DEC tc = (TYPE_CLASS_VAR_DEC)t;
      t = tc.t;
    }
    String def_ret_val = "0";
    if (t == null) {
      return def_ret_val;
    }
    if (t.isClass() || t.isArray()) {
      def_ret_val = "null";
    }
    if (t == TYPE_STRING.getInstance()) {
      def_ret_val = "null";
    }
    return def_ret_val;
  }
  static public String type_to_string(TYPE t) {
    String type = "void";
    if (t == null) {
      System.out.format("ERROR type to string\n");
      return type;
    }
    if (t.isClassVar()) {
      TYPE_CLASS_VAR_DEC tc = (TYPE_CLASS_VAR_DEC)t;
      t = tc.t;
    }
    if (t == null || t == TYPE_VOID.getInstance()) {
      return type;
    }
    if (t == TYPE_INT.getInstance()) {
      type = "i32";
    }
    // String type_val = "0";
    // int align = 4;
    if (t.isArray()) {
      type = "i32*";
      // type_val = "null";
      // align = 8;
    }
    if (t.isClass() || t == TYPE_STRING.getInstance()) {
      type = "i8*";
      // type_val = "null";
      // align = 8;
    }
    return type;
  }
}
