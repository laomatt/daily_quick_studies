var slideResults = Backbone.View.extend({
  el: '#slide_search_input',
  initialize: function(){
    $('body').on('keyup', '#search-bar', function(event) {
      event.preventDefault();
      var phrase = $(this).val();
      thisPage.getShowPartial('/slideshows/search_slideshows', {phrase: phrase});
    });

    $('body').on('keyup', '#slide_search_input', function(event) {
      event.preventDefault();
      var slideshow_id = $(this).attr('slideshow-id');
      slideSearchResults.search(slideshow_id);
    });
  },
  search: function(slideshow_id){
    $.ajax({
      url: '/slides/search_reload_pag',
      data: {page: 1, search: this.$el.val(), from: 'modal', slideshow_id: slideshow_id},
    })
    .done(function(data) {
      $('.slide_results_panel').html(data);
    })
  }
})

var slideSearchResults = new slideResults();
