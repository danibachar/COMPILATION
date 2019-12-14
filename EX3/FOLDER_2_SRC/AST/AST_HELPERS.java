package AST;

import TYPES.*;
import SYMBOL_TABLE.*;
import AST_EXCEPTION.*;

// AST_HELPERS.isValidTypeAssignableFromExpression

public class AST_HELPERS
{
  static public void isValidTypeAssignableFromExpression(TYPE t, AST_EXP exp) throws Exception
  {
    if (t == null && exp == null) {
      System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",exp.lineNumber);
      throw new AST_EXCEPTION(exp);
    }
    if (exp == null) {
      System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",exp.lineNumber);
      throw new AST_EXCEPTION(exp);
    }
    TYPE tValue = exp.SemantMe();
    if (tValue == null) {
      System.out.format(">> ERROR [%d] initialValue that assigned to the var is not exists\n",exp.lineNumber);
      throw new AST_EXCEPTION(exp);
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
      throw new AST_EXCEPTION(exp);
    }

    if (t.isClass()) {
      TYPE_CLASS tc = (TYPE_CLASS)t;
      if (tValue.isClassVar()) {
        TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
        if (!tc.isAssignableFrom(testInitVlueType.t)) {
          System.out.format(">> ERROR [%d] 1-trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp);
        }
      } else if (!tc.isAssignableFrom(tValue)) {
        System.out.format(">> ERROR [%d] 2-trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
        throw new AST_EXCEPTION(exp);
      }
    }

    if (t.isArray()) {
      TYPE_ARRAY tc = (TYPE_ARRAY)t;
      if (tValue.isClassVar()) {
        TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
        if (!tc.isAssignableFrom(testInitVlueType.t)) {
          System.out.format(">> 1 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, testInitVlueType.t);
          throw new AST_EXCEPTION(exp);
        }
      } else if (exp.isNewArray()) {
        if (tValue != tc.type) {
          System.out.format(">> 2 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp);
        }
      } else if (!tc.isAssignableFrom(tValue)) {
        System.out.format(">> 3 ERROR [%d] trying assign array(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
        throw new AST_EXCEPTION(exp);
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
            System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, testInitVlueType.t);
            throw new AST_EXCEPTION(exp);
          }
        } else if (!tc.isAssignableFrom(tValue)) {
          System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp);
        }
      }
      // Allow Assignment for array - nil or same array?
      if (tcv.t.isArray()) {
        TYPE_ARRAY tc = (TYPE_ARRAY)tValue;
        if (tValue.isClassVar()) {
          TYPE_CLASS_VAR_DEC testInitVlueType = (TYPE_CLASS_VAR_DEC)tValue;
          if (!tc.isAssignableFrom(testInitVlueType.t)) {
            System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, testInitVlueType.t);
            throw new AST_EXCEPTION(exp);
          }
        } else if (!tc.isAssignableFrom(tValue)) {
          System.out.format(">> ERROR [%d] trying assign class(%s) with the value(%s) \n",exp.lineNumber,t, tValue);
          throw new AST_EXCEPTION(exp);
        }
      }
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
      throw new AST_EXCEPTION(exp);
    }

    if (t.isArray() && tValue.isArray()) {
      TYPE_ARRAY t1_cast = (TYPE_ARRAY)t;
      TYPE_ARRAY t2_cast = (TYPE_ARRAY)tValue;
      if (t1_cast.isAssignableFrom(t2_cast)) {
        return;
      }
      System.out.format(">> ERROR [%d] Assinging array(%s) to array(%s) is forbidden \n",exp.lineNumber,t1_cast,t2_cast);
      throw new AST_EXCEPTION(exp);
    }


    System.out.format(">> ERROR [%d] type mismatch for var(%s) := exp(%s)\n",exp.lineNumber,t,tValue);
    throw new AST_EXCEPTION(exp);
  }
}
