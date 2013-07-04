{ezcss_require( array( 'jquery.plupload.queue/jquery.plupload.queue.css', 
                       'ezmultiupload.css' ) )}

{ezscript_require( array( 'ezjsc::jquery', 
                          'plupload/browserplus-min.js', 
                          'plupload/plupload.full.js', 
                          'plupload/jquery.plupload.queue/jquery.plupload.queue.js' ) )}

<div class="content-navigation">
<div class="context-block">
<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h2 class="context-title">{'Multiupload'|i18n('extension/ezmultiupload')}</h2>

<div class="header-subline"></div>

</div></div></div></div></div></div>
    <div class="box-ml"><div class="box-mr"><div class="box-content"><div class="context-attributes">


<div class="content-view-ezmultiupload">
    <div class="class-frontpage">

        <div class="attribute-description">
            <p>{'The files are uploaded to'|i18n('extension/ezmultiupload')} <a href={$parent_node.url_alias|ezurl}>{$parent_node.name|wash}</a></p>
        </div>

        <form enctype="multipart/form-data" id="ezmultiupload-form" action={concat( 'ezmultiupload/plupload/', $parent_node.node_id )|ezurl( 'double', 'full' )} method="post">
            <div id="uploader">
                <p>You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
            </div>
        </form>

        <div id="thumbnails"></div>    
        
    </div>
</div>

     <div class="break"></div>

    </div></div></div></div>
    <div class="controlbar">
        <div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">
        <div class="break"></div>
        </div></div></div></div></div></div>
    </div>

</div>
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
        file_data_name : 'Filedata',
        unique_names : true,
        // Specify what files to browse for
        {if $fileTypes}
        filters : [
            {ldelim} 
                title : "Allowed files", 
                extensions : "{foreach $fileTypes as $fileType}{$fileType|replace( 0, 2, '' )}{delimiter},{/delimiter}{/foreach}"
            {rdelim}
        ],
        {/if}
        flash_swf_url : {'javascript/plupload/plupload.flash.swf'|ezdesign('no')|ezroot('single', 'full')},
        // Silverlight settings
        silverlight_xap_url : {'javascript/plupload/plupload.silverlight.xap'|ezdesign('no')|ezroot('single', 'full')},
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
