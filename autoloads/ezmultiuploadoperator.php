<?php
/** 
 * Operator: ezmulti()
 */ 
class EZMultiUploadOperator
{ 
    public $Operators;
 
    public function __construct( $name = 'ezmulti' )
    { 
        $this->Operators = array( $name ); 
    }
 
    /** 
     * Returns the template operators.
     * @return array
     */ 
    function operatorList()
    { 
        return $this->Operators; 
    }
 
    /**
     * Returns true to tell the template engine that the parameter list 
     * exists per operator type. 
     */ 
    public function namedParameterPerOperator() 
    { 
        return true; 
    }
 
    /**
     * @see eZTemplateOperator::namedParameterList 
     **/ 
    public function namedParameterList() 
    { 
        return array( 'ezmulti' => array( ) ); 
    }
 
    public function modify( $tpl, $operatorName, $operatorParameters, $rootNamespace, $currentNamespace, &$operatorValue, $namedParameters )
    {
        $token = ezxFormToken::getToken();
        $operatorValue = $token;
    } 
} 
?>