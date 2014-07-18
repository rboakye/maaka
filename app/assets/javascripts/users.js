/**
 * Created with JetBrains RubyMine.
 * User: rboakye
 * Date: 1/10/14
 * Time: 9:06 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function () {
    // instantiate the bloodhound suggestion engine
    var users = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    dupDetector: function(remoteMatch,localMatch){

    },
    limit: 5,
    prefetch: {
        url: 'all_users.json',
        ttl: 10000
    },
    remote: 'alt_users/find/%QUERY.json'
    });

    // initialize the bloodhound suggestion engine
    users.initialize();

    // instantiate the typeahead UI
    $('#search-people .typeahead').typeahead(null, {
    displayKey: 'name',
    source: users.ttAdapter(),
    templates: {
            empty: [
                '<div class="empty-message text-info">',
                'no user matches your current entry',
                '</div>'
            ].join('\n'),
            suggestion: Handlebars.compile('<a class="list-group-item search_link" href="{{url}}">' +
                    '<img src="{{image_link}}" class="search_img img-rounded" >' +
                    '<span class="search_text text-info">{{name}}</span>' +
             '</a>')

    }
   });
});