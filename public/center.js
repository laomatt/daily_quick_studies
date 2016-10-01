$(document).ready(function() {


  $('body').on('click', '.regen-slide', function(event) {
    event.preventDefault();
    $('.random_slides').fadeOut(500, function() {
      $.ajax({
        url: '/slides/slides_modal',
      })
      .done(function(data) {
        $('.random_slides').html(data);
        $('.random_slides').fadeIn(500, function() {});
      })

    });
  });

  var idx2 = 0;

  var idx = 0;
  $('body').on('click', '.add-this-slide', function(event) {
    event.preventDefault();
    // adding something to add
    var id = $(this).attr('data-id');
    var image = $(this).html();
    // var image = '' + id +'  ' + $(this).attr('class');
    idx += 1;
    var input_html = image + "<input type='hidden' name='slideshow[slides_to_add]["+idx+"]' value='"+id+"'>"
    $('.slides_to_add').append(input_html)

    // remove something to add
  });


  // my account

  $('body').on('click', '.create-slideshow-button', function(event) {
    event.preventDefault();
    $('.create-new-slideshow-form').trigger('submit');
  });

  $('body').on('keyup', '#slide_search_input', function(event) {
    event.preventDefault();
    var url = '/slides/search_reload_pag_row'
    $.ajax({
      url: url,
      data: {page: 1, search: $(this).val()},
    })
    .done(function(data) {
      $('#slide_results_panel').html(data);
    })
  });


  $('body').on('submit', '.create-new-slideshow-form', function(event) {
    event.preventDefault();
    $('.current_slideshows').css('opacity', '.5');
    $.ajax({
      url: '/slideshows/create_show',
      type: 'POST',
      data: $(this).serialize(),
    })
    .done(function(data) {
      $('.create-new-slideshow-form').trigger('reset');
      $('.current_slideshows').html(data);
      $('button.close').trigger('click');
      $('.current_slideshows').css('opacity', '1');
      $('.slide_to_add').html('');
      idx = 0;
    })

  });

  // $('body').on('click', '.add-this-tag-to-slide', function(event) {
  //   event.preventDefault();
  //   $(this).hide('500', function() {
  //     var tag_id = $(this).attr('tag-id');
  //     var slide_id = $(this).parent().attr('slide-id');


  //     $.ajax({
  //       url: '/taggings',
  //       type: 'POST',
  //       data: {tag_id: tag_id, slide_id: slide_id},
  //     })
  //     .done(function(data) {
  //       $('.tag-current').append(data);
  //       $('#tag-search-bar').val('')
  //     })
  //   });
  // });

  $('body').on('click', '.delete-this-slide', function(event) {
    event.preventDefault();
    var slide_id = $(this).attr('slide-id');
    $.ajax({
      url: '/slides/'+slide_id,
      type: 'DELETE',
    })
    .done(function() {
      $('button.close').trigger('click');
    })

  });

  $('body').on('click', '.create-this-tag-to-slide', function(event) {
    event.preventDefault();
    var phrase = $(this).attr('phrase');
    var slide_id = $(this).parent().attr('slide-id');
    $.ajax({
      url: '/taggings/create_tag',
      type: 'POST',
      data: {phrase: phrase, slide_id: slide_id},
    })
    .done(function(data) {
      $('.tag-current').append(data)
      $('#tag-search-bar').val('')
    })

  });

  $('body').on('click', '.remove-tag-from-slideshow', function(event) {
    event.preventDefault();
    var tag_id = $(this).attr('tag-id');
    var slide_id = $(this).parent().attr('slide-id');
    $(this).hide(500, function() {});

    $.ajax({
      url: '/taggings/'+tag_id+'/delete_tag_from_slide',
      type: 'DELETE',
      data: {slide_id: slide_id}
    })
    .done(function(data) {
      if (data.status == 'success') {};
    })
  });


  // $('body').on('keyup', 'input#tag-search-bar', function(event) {
  //   event.preventDefault();
  //   var phrase = $(this).val();
  //   $.ajax({
  //     url: '/taggings/tag_results',
  //     data: {phrase: phrase},
  //   })
  //   .done(function(data) {
  //     $('.tag-results').html(data);
  //   })

  // });

  $('body').on('keyup', '#search-bar-for-slideshows', function(event) {
    event.preventDefault();
    var phrase = $(this).val();

    $.ajax({
      url: '/slideshows/search_slideshows',
      data: {phrase: phrase},
    })
    .done(function(data) {
      $('.slideshow_list_sect_container').html(data);
    })

  });


});






