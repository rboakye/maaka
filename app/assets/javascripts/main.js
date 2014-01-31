/**
 * Created with JetBrains RubyMine.
 * User: rboakye
 * Date: 1/10/14
 * Time: 9:06 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).on('ready page:load', (function () {

    window.setTimeout(function() {
        $(".alert-success").fadeTo(500, 0).slideUp(500, function(){
            $(this).remove();
        });
    },5000);

    window.setTimeout(function() {
        $(".alert-danger").fadeTo(500, 0).slideUp(500, function(){
            $(this).remove();
        });
    },5000);

    $('.comment-block').mouseover(function (e) {
        $(this).find('.delete-comment').css("visibility", "visible");
    }).mouseleave(function () {
            $('.delete-comment').css("visibility", "hidden");
    });

/*    $('.comment-block').mouseover(function (e) {
        $(this).find('.delete-comment').css("visibility", "visible");
    }).mouseleave(function () {
            $('.delete-comment').css("visibility", "hidden");
        });

    $('.note-element-wrapper').mouseover(function (e) {
        $(this).find('.note-controls').css("visibility", "visible");
    }).mouseleave(function () {
            $('.note-controls').css("visibility", "hidden");
        });

    $(document).on('click', '.content-element-wrapper', function(){
        $('.content-element').removeClass('panel-default');
        if($(this).children(0).hasClass('cke_focus') && !$(this).children(0).hasClass('kc_error')){
            $(this).children(0).addClass('panel-default');
        }
    })

    $(document).on('click', '.note-element-wrapper', function(){
        $('.note-element').removeClass('panel-default');
        $('.note-title-element').removeClass('panel-default');
        if($(this).children(0).hasClass('cke_focus') && !$(this).children(0).hasClass('kc_error')){
            $(this).children(0).addClass('panel-default');
        }
    })*/
}));