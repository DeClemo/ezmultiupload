{ezcss_require( array( 'jquery.plupload.queue/jquery.plupload.queue.css', 
                       'ezmultiupload.css' ) )}

{ezscript_require( array( 'ezjsc::jquery', 
                          'plupload/browserplus-min.js', 
                          'plupload/plupload.full.js', 
                          'plupload/jquery.plupload.queue/jquery.plupload.queue.js' ) )}

<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-view-ezmultiupload">
    <div class="class-frontpage">
    
        <div class="attribute-header">
            <h1 class="long">{'Multiupload'|i18n('extension/ezmultiupload')}</h1>
        </div>
        
        <div class="attribute-description">
            <p>{'The files are uploaded to'|i18n('extension/ezmultiupload')} <a href={$parent_node.url_alias|ezurl}>{$parent_node.name|wash}</a></p>
        </div>
        
        <form action={concat('ezjscore/call/ezmultiupload::upload::', $parent_node.node_id)|ezurl()} method="post">
            <div id="uploader">
                <p>You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
            </div>
        </form>
        
        <div id="thumbnails"></div>
        
    </div>
</div>



</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

{def $maxFileSize=ezini( 'PLUploadSettings', 'maxFileSize', 'ezmultiupload.ini' )
     $fileChunkSize=ezini( 'PLUploadSettings', 'uploadChunkSize', 'ezmultiupload.ini' )
     $resizeSettings=ezini( 'PLUploadSettings', 'clientSideResize', 'ezmultiupload.ini' )
     $fileTypes=ezini( concat('FileTypeSettings_', $parent_node.class_identifier), 'FileType', 'ezmultiupload.ini' )}

{* Test to see if *.* is type *}
{if $fileTypes|contains('*.*')}
    {set $fileTypes = false()}
{/if}

<script type="text/javascript">
// Convert divs to queue widgets when the DOM is ready
jQuery(document).ready(function($) {ldelim}
    $("#uploader").pluploadQueue( {ldelim}
        // General settings
        runtimes : 'html5,gears,flash,silverlight,browserplus,',
        url : {concat( 'ezmultiupload/plupload/', $parent_node.node_id )|ezurl( 'single', 'full' )},
        max_file_size : '{$maxFileSize}mb',
        chunk_size : '{$fileChunkSize}mb',
        file_data_name : 'Filedata',
        unique_names : true,
        // Resize images on clientside if we can
        resize : {ldelim}
            width : {$resizeSettings['width']}, 
            height : {$resizeSettings['height']}, 
            quality : {$resizeSettings['quality']}
        {rdelim},
        // Specify what files to browse for
        {if $fileTypes}
        filters : [
            {ldelim} 
                title : "Allowed files", 
                extensions : "{foreach $fileTypes as $fileType}{$fileType|replace( 0, 2, '' )}{delimiter},{/delimiter}{/foreach}"
            {rdelim}
        ],
        {/if}
        flash_swf_url : {'javascript/plupload/plupload.flash.swf'|ezdesign('single')},
        // Silverlight settings
        silverlight_xap_url : {'javascript/plupload/plupload.silverlight.xap'|ezdesign('single')},
        multipart_params : {ldelim}
            'ezxform_token' : '{ezmulti()}'
        {rdelim}
    {rdelim});
    
    var uploader = $('#uploader').pluploadQueue();
    
    uploader.bind('FileUploaded', function(uploader, file, response) {ldelim}        
        var obj = jQuery.parseJSON(response['response']);
        $('#thumbnails').append(obj['data']);
    {rdelim});
{rdelim});
</script>


