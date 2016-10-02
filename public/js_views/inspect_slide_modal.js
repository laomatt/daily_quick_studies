var inspectSlideModal = Backbone.View.extend({
  el: '#inspectSlide',
  initialize: function(){
    $('body').on('click', '.inspect_this_slide', function(event) {
        var id = $(this).attr('data-id');
        var from = $(this).attr('data-from');
        inspect.populate(id, from);
      });

    $('body').on('click', '.create-this-tag-to-slide', function(event) {
      event.preventDefault();
      var phrase = $(this).attr('phrase');
      var slide_id = $(this).parent().attr('slide-id');
      inspect.createTag(phrase, slide_id);
    });


    $('body').on('keyup', 'input#tag-search-bar', function(event) {
      event.preventDefault();
      var phrase = $(this).val();
      inspect.searchTags(phrase);
    });

   $('body').on('click', '.edit-slide-form', function(event) {
     event.preventDefault();
     var data = $(this).serialize();
     inspect.updateName(data);
   });

   $('body').on('click', '.remove-tag-from-slideshow', function(event) {
      event.preventDefault();
      var tag_id = $(this).attr('tag-id');
      var slide_id = $(this).parent().attr('slide-id');
      $(this).hide(500, function() {
        inspect.removeTag(tag_id, slide_id);
      });
    });

    $('body').on('click', '.add-this-tag-to-slide', function(event) {
      event.preventDefault();
      $(this).hide('500', function() {
        var tag_id = $(this).attr('tag-id');
        var slide_id = $(this).parent().attr('slide-id');
        inspect.addTag(tag_id, slide_id);
      });
    });

    $('body').on('click', '.delete-this-slide', function(event) {
      event.preventDefault();
      var slide_id = $(this).attr('slide-id');
      inspect.deleteSlide(slide_id);
    });

    $('body').on('change', '#add-to-user-slide-show', function(event) {
      event.preventDefault();
      var slideshow_id = $(this).val();
      var slide_id = $(this).attr('slide-id');
      inspect.addToSlideshow(slide_id, slideshow_id);
    });
  },
  createTag: function(phrase, slide_id){
    $.ajax({
      url: '/taggings/create_tag',
      type: 'POST',
      data: {phrase: phrase, slide_id: slide_id},
    })
    .done(function(data) {
      $('.tag-current').append(data)
      $('#tag-search-bar').val('')
    })
  },
  deleteSlide: function(slide_id){
    $('#slide_container_for_slide_' + slide_id).hide(200, function() {});
    $.ajax({
      url: '/slides/'+slide_id,
      type: 'DELETE',
    })
    .done(function() {
      $('button.close').trigger('click');
    })
  },
  updateName: function(data){
    $.ajax({
      url: '/slides/'+id+'/update_name',
      type: 'PATCH',
      data: data,
    })
  },
  removeTag: function(tag_id, slide_id){
    $.ajax({
      url: '/taggings/'+tag_id+'/delete_tag_from_slide',
      type: 'DELETE',
      data: {slide_id: slide_id}
    })
    .done(function(data) {
      if (data.status == 'success') {};
    })
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