<?php
 
// Which operators will load automatically? 
$eZTemplateOperatorArray = array();
 
// Operator: jacdata 
$eZTemplateOperatorArray[] = array( 'class' => 'EZMultiUploadOperator',
                                    'operator_names' => array( 'ezmulti' ) ); 
?>
