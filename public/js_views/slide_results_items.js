var slideResultItem = Backbone.View.extend({
  el: '.slide_to_add',
  initialize: function (){
    $('body').on('click', '.add_this_slide', function(event) {
        event.preventDefault();
        var id = $(this).attr('data-id');
        slideItem.addSlide(id);
      });

    $('body').on('keyup', '#slide_search_input', function(event) {
      event.preventDefault();
      var slideshow_id = $(this).attr('slideshow-id');
      slideItem.reloadSlideMODALresults(slideshow_id, $(this).val())
    });

    $('body').on('keyup', '#slide_search', function(event) {
      event.preventDefault();
      slideItem.reloadSlideIDXresults($(this).val());
    });

    $('body').on('click', '.cancel_this_slide', function(event) {
      event.preventDefault();
      var id = $(this).attr('data-id');
      slideItem.removeSlide(id);
    });

  },
  reloadSlideIDXresults: function(phrase){
      $.ajax({
        url: '/slides/search_reload_pag',
        data: {page: 1, search: phrase, from: 'index'},
      })
      .done(function(data) {
        $('.results_container').html(data);
      })

  },
  reloadSlideMODALresults: function(slideshow_id, phrase){
    var url = '/slides/search_reload_pag'
    $.ajax({
      url: url,
      data: {page: 1, search: phrase, from: 'modal', slideshow_id: slideshow_id},
    })
    .done(function(data) {
      $('.slide_results_panel').html(data);
    })

  },
  addSlide: function(id){
    var context_element = $('#slide_container_for_slide_'+id)
    $('.slide_add_info').fadeIn(500, function() {});
    var html_to_add = "<a href='#' class='cancel_this_slide' data-id='"+id+"'>" + context_element.html() + "</a>";
    context_element.fadeOut(500, function() {});
    $('.slide_to_add').append(html_to_add);
    $('.slide_to_add').append("<input type='hidden' name='slideshow[slides_to_add]["+id+"]' id='input_to_add_slide_"+id+"' value='"+id+"'>");
  },

  removeSlide: function(id){
    $(this).hide(200, function() {
      $('#slide_container_for_slide_'+id).fadeIn(500, function() {});
    });
    $('#input_to_add_slide_'+id).remove();
  }
})

var slideItem = new slideResultItem();