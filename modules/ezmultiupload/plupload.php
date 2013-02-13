<?php
/**
 * File containing the eZ Publish plupload view implementation.
 *
 * This is called by plupload for each file upload.
 *
 * @copyright Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPL v2
 * @version 1.0.0
 * @package ezmultiupload
 */

$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();
$module = $Params['Module'];
$parentNodeID = $Params['ParentNodeID'];

$result = array( 'errors' => array() );

// Exec multiupload handlers preUpload method
eZMultiuploadHandler::exec( 'preUpload', $result );

// Handle file upload only if there was no errors
if( empty( $result['errors'] ) )
{
    // Handle file upload. All checkes are performed by eZContentUpload::handleUpload()
    // and available in $result array
    $upload = new eZContentUpload();
    $upload->handleUpload( $result, 'Filedata', $parentNodeID, false );
}

// Exec multiupload handlers postUpload method
eZMultiuploadHandler::exec( 'postUpload', $result );

// Pass result to template and process it
$tpl->setVariable( 'result', $result );
$templateOutput = $tpl->fetch( 'design:ezmultiupload/thumbnail.tpl' );

// Strip all new lines from processed template and convert all applicable characters to
// HTML entities output. Create upload ID
$httpCharset = eZTextCodec::httpCharset();
$data = htmlentities( str_replace( array( "\r\n", "\r", "\n" ), array(""), $templateOutput ) , ENT_QUOTES, $httpCharset );
$id = md5( (string)mt_rand() . (string)microtime() );

$response = array( 'data' => $templateOutput, 'id' => $id );

// Return server response in JSON format
echo json_encode( $response );

// Stop execution
eZExecution::cleanExit();

?>
