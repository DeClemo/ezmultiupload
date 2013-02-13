<?php
/**
 * File containing the ezjscoreEzMultiUploadCallFunctions class.
 *
 * @package ezmultiupload
 * @version //autogentag//
 * @copyright 
 * @license GNU GENERAL PUBLIC LICENSE
 * @author Daniel Clements
 */
 
class ezjscoreEzMultiUploadCallFunctions extends ezjscServerFunctions
{
    /*
     * JS Server call for uploaded files
     */
    public static function upload( $args )
    {
        $http = eZHTTPTool::instance();
        
        $parentNodeID = $args[0];
        
        $result = array( 'errors' => array() );
        
        // Exec multiupload handlers preUpload method
        eZMultiuploadHandler::exec( 'preUpload', $result );
        
        // Handle file upload only if there was no errors
        if( empty( $result['errors'] ) )
        {
            // Handle file upload. All checkes are performed by eZContentUpload::handleUpload()
            // and available in $result array
            $upload = new eZContentUpload();
            if ($upload->handleUpload( $result, 'Filedata', $parentNodeID, false ))
            {
                // Exec multiupload handlers postUpload method
                eZMultiuploadHandler::exec( 'postUpload', $result );
                
                // initialise Template object
                $tpl = eZTemplate::factory();

                // Pass result to template and process it
                $tpl->setVariable( 'result', $result );
                $templateOutput = $tpl->fetch( 'design:ezmultiupload/thumbnail.tpl' );
                
                // Strip all new lines from processed template and convert all applicable characters to
                // HTML entities output. Create upload ID
                $httpCharset = eZTextCodec::httpCharset();
                $data = htmlentities( str_replace( array( "\r\n", "\r", "\n" ), array(""), $templateOutput ) , ENT_QUOTES, $httpCharset );
                $id = md5( (string)mt_rand() . (string)microtime() );
                
                $response = array( 'data' => $data, 'id' => $id );
                
                // Stop execution
                eZExecution::cleanExit();        
                
                return $data;
            }
            else
            {
                return 'error';
            }
            
        }
        
    }
}
?>