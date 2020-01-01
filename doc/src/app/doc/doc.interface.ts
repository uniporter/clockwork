/**
 * All expressions, including classes, mixins, variables, functions, etc, should extend this interface.
 */
interface IExpression {
    /**
     * The version where the expression is formally introduced.
     */
    from: string;

    /**
     * The version where the expression is removed.
     */
    to?: string;

    /**
     * The version where the expression is added as an experimental feature.
     */
    experimentalFrom?: string;

    /**
     * The version from which the expression is deprecated.
     */
    deprecatedFrom?: string;

    /**
     * The name of the token.
     */
    name: string;

    /**
     * The file where the expression is declared.
     */
    declaredIn: string;
}

/**
 * The native variable types in Dart.
 */
enum VariableType {
    int = 'int',
    double = 'double',
    num = 'num',
    string = 'String',
}



/**
 * A variable.
 */
interface IVariable extends IExpression {
    /**
     * Type of the variable.
     */
    type: VariableType | IClass | IEnum | ITypeDef;

    /**
     * If the variable is final.
     */
    isFinal?: boolean;

    /**
     * If the variable is constant.
     */
    isConst?: boolean;
}

interface IClass extends IExpression {

}

interface IEnum extends IExpression {

}

interface ITypeDef extends IExpression {

}