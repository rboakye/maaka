/**
 * Created with JetBrains RubyMine.
 * User: rboakye
 * Date: 1/10/14
 * Time: 9:06 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function () {

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

    $('.img-add').mouseover(function (e) {
        $(this).find('.img-remove').css("visibility", "visible");
    }).mouseleave(function () {
            $('.img-remove').css("visibility", "hidden");
    });

    $('.delete-comment').tooltip();

    $('.img-remove').tooltip();

});

     $(document).on('mouseover', '.image-view', function() {
         $(this).find('.next').css("visibility", "visible");
         $(this).find('.prev').css("visibility", "visible");
     });

    $(document).on('mouseleave', '.image-view', function() {
        $('.next').css("visibility", "hidden");
        $('.prev').css("visibility", "hidden");
    });

/*
     Good: events are bound outside a $() wrapper.
     $(document).on('click', 'button', function() { ... })
 */