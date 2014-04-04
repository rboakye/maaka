/**
 * Created with JetBrains RubyMine.
 * User: rboakye
 * Date: 1/10/14
 * Time: 9:06 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function () {
    var currentId = '';

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

    $('.kasa-heading').mouseover(function (e) {
        $(this).find('.post-delete').css("display", "block");
    }).mouseleave(function () {
        $('.post-delete').css("display", "none");
    });

    $('.friend-pop').popover({
        html:true,
        trigger:'manual',
        template:'<div class="popover" onmouseover="clearTimeout(timeoutObj);$(this).mouseleave(function() {' +
            '$(this).hide();});"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
    }).mouseenter(function (e) {
            $(this).popover('show');
        }).mouseleave(function (e) {
            var ref = $(this);
            timeoutObj = setTimeout(function () {
                ref.popover('hide');
            }, 50);
        });

    $('.user-pop').popover({
        html:true,
        trigger:'manual',
        template:'<div class="popover" onmouseover="clearTimeout(timeoutObj);$(this).mouseleave(function() {' +
            '$(this).hide();});"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
    }).mouseenter(function (e) {
            $(this).popover('show');
        }).mouseleave(function (e) {
            var ref = $(this);
            timeoutObj = setTimeout(function () {
                ref.popover('hide');
            }, 50);
        });

    $('.kasa-panel').mouseover(function(event) {
        myflag = doAjax(this.id);
        if(myflag){
            var post_id = this.id.replace(/[^0-9]/g,'');
            var comment = $(this).find('.comments').children().last();
            if(comment.length > 0){
                var comment_id = comment.attr('id').replace(/[^0-9]/g,'');
            }else{
                var comment_id = '-1'
            }
            var url = "/comments/update_post_comments/" + post_id + "/" + comment_id;
            $.ajax({
                url: url,
                context: document.body,
                success: function(content,msg){
                    flag = false;
                }
            });
        }
    });

    $('.image-panel').mouseover(function(event) {
        myflag = doAjax(this.id);
        if(myflag){
            var image_id = this.id.replace(/[^0-9]/g,'');
            var comment = $(this).find('.comments').children().last();
            if(comment.length > 0){
                var comment_id = comment.attr('id').replace(/[^0-9]/g,'');
            }else{
                var comment_id = '-1'
            }
            var url = "/comments/update_image_comments/" + image_id + "/" + comment_id;
            $.ajax({
                url: url,
                context: document.body,
                success: function(content,msg){
                    flag = false;
                }
            });
        }
    });

    function doAjax(id){
        if(currentId == id){
           flag = false;
        }else{
           flag = true;
           currentId = id;
        }
        return flag;
    }

});
    $(document).on('mouseover', '.img-comment', function(event) {
        myflag = doAjax(this.id);
        if(myflag){
            var image_id = this.id.replace(/[^0-9]/g,'');
            var comment = $(this).find('.comments').children().last();
            if(comment.length > 0){
                var comment_id = comment.attr('id').replace(/[^0-9]/g,'');
            }else{
                var comment_id = '-1'
            }
            var url = "/comments/update_image_comments/" + image_id + "/" + comment_id;
            $.ajax({
                url: url,
                context: document.body,
                success: function(content,msg){
                    flag = false;
                }
            });
        }


        function doAjax(id){
            if(currentId == id){
                flag = false;
            }else{
                flag = true;
                currentId = id;
            }
            return flag;
        }
    });

    var currentId = '';

    $(document).on('keypress', '#comment_kasa_comment', function(event) {
        if(event.which == 13){
            event.preventDefault();
            $(this).closest('form').submit();
            $(this).val('');
        }
    });


     $(document).on('mouseover', '.image-view', function() {
         $(this).find('.next').css("visibility", "visible");
         $(this).find('.prev').css("visibility", "visible");
     });

    $(document).on('mouseleave', '.image-view', function() {
        $('.next').css("visibility", "hidden");
        $('.prev').css("visibility", "hidden");
    });

    $(document).on('mouseover', '.comment-modal-block', function() {
        $(this).find('.delete-comment').css("visibility", "visible");
        $('.delete-comment').tooltip();
    });

    $(document).on('mouseleave', '.comment-modal-block', function() {
        $('.delete-comment').css("visibility", "hidden");
    });

/*
     Good: events are bound outside a $() wrapper.
     $(document).on('click', 'button', function() { ... })
 */