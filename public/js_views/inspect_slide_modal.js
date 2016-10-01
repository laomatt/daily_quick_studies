var inspectSlideModal = Backbone.View.extend({
  el: '#inspectSlide',
  initialize: function(){
    $('body').on('click', '.inspect_this_slide', function(event) {
        var id = $(this).attr('data-id');
        var from = $(this).attr('data-from');
        inspect.populate(id, from);
      });

    $('body').on('keyup', 'input#tag-search-bar', function(event) {
      event.preventDefault();
      var phrase = $(this).val();
      inspect.searchTags(phrase);
    });

    $('body').on('click', '.add-this-tag-to-slide', function(event) {
      event.preventDefault();
      $(this).hide('500', function() {
        var tag_id = $(this).attr('tag-id');
        var slide_id = $(this).parent().attr('slide-id');
        inspect.addTag(tag_id, slide_id);
      });
    });

    $('body').on('change', '#add-to-user-slide-show', function(event) {
      event.preventDefault();
      var slideshow_id = $(this).val();
      var slide_id = $(this).attr('slide-id');
      inspect.addToSlideshow(slide_id, slideshow_id);
    });
  },
  addTag: function(tag_id, slide_id){
    $.ajax({
      url: '/taggings',
      type: 'POST',
      data: {tag_id: tag_id, slide_id: slide_id},
    })
    .done(function(data) {
      $('.tag-current').append(data);
      $('#tag-search-bar').val('')
    })

  },
  searchTags: function(phrase){
    $.ajax({
      url: '/taggings/tag_results',
      data: {phrase: phrase},
    })
    .done(function(data) {
      $('.tag-results').html(data);
    })

  },
  addToSlideshow: function(slide_id, slideshow_id){
      if (slideshow_id == '0') {
        return;
      };
    $.ajax({
      url: '/slideshows/'+slideshow_id+'/add_slide_to_slideshow',
      data: {slide_id: slide_id},
    })
    .done(function(data) {
      if(data.status == 'error'){
        $('.messag`e-center-error').text(data.message);
        $('.message-center-error').fadeIn(500, function() {});
      } else {
        $('button.close').trigger('click');
        $('.message-center-success').text(data.message);
        $('.message-center-success').fadeIn(500, function() {});
      }

      $('.message-center').animate({
        backgroundColor: 'transparent'},
        1000, function() {
          $('.message-center').fadeOut(500, function() {});
      });
    })
  },
  populate: function(id, from){
    $.ajax({
      url: '/slides/'+id+'/inspect_modal',
      data: {from: from}
    })
    .done(function(data) {
      $('#inspectSlide').html(data)
    })
  }
})

var inspect = new inspectSlideModal()