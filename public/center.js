$(document).ready(function() {
  $('body').on('submit', 'form.create-new-slide-form', function(event) {
    event.preventDefault();
    $('#uploaded_so_far .tiny-thumb').fadeOut(200, function() {
      $('#prog_report').text('');
      $('#uploaded_so_far').html('');
    });

    $('form.create-new-slide-form').fadeOut(500, function() {
      $('#progress_message').fadeIn(500, function() {});
    });

    var fileInput = document.getElementById("picture");
    var files = fileInput.files;
    var length = files.length;
    var formData = new FormData( this );
      $.each(files, function(index, val) {
      formData.set('image_this', val)
      $.ajax({
          url: "/slides",
          type: 'POST',
          data: formData,
          processData: false,
          contentType: false,
        })
        .done(function(data) {
          if($('#uploaded_so_far .tiny-thumb').length == 0) {
            $('#uploaded_so_far').append('<img src="'+data.url+'" alt="" class="img-responsive img-thumbnail tiny-thumb" style="display:none">')
          } else {
            $('#uploaded_so_far').append('<img src="'+data.url+'" alt="" class="img-responsive img-thumbnail tiny-thumb" style="display:none;margin-left: -100px;">')
          }
          $('#uploaded_so_far .tiny-thumb').fadeIn(1000);
          $('#uploaded_so_far .tiny-thumb').animate({'margin-left': 0}, 1000);
          var new_idx = $('#uploaded_so_far .tiny-thumb').length;
          $('form.create-new-slide-form').trigger('reset');
          var prog = " - (Uploaded " + new_idx + " of " + length + " slides)";
          $('#prog_report').text(prog);
          if(new_idx >= length){
            $('#progress_message').fadeOut(500, function() {
              $('form.create-new-slide-form').fadeIn(500, function() {});
            });
          }
        })
    });
  });

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

  $('body').on('click', '.remove-this-slide', function(event) {
    event.preventDefault();

    // adding something to remove
    var id = $(this).attr('data-id');
    idx2 += 1;
    // $(this).find('img').addClass('active-slide');
    $(this).hide(500, function() {});
    $('.slides_to_remove').append("<input type='hidden' name='slideshow[slides_to_remove]["+idx2+"]' value='"+id+"'>");

    // remove something from remove
  });

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

// edit modal

// $('body').on('click', '.edit-slideshow-button', function(event) {
//     event.preventDefault();
//     $('.edit-slideshow-form').trigger('submit');
//   });

  // $('body').on('keyup', '#slide_search_input', function(event) {
  //   event.preventDefault();
  //   var url = '/slides/search_reload_pag'
  //   var slideshow_id = $(this).attr('slideshow-id');
  //   $.ajax({
  //     url: url,
  //     data: {page: 1, search: $(this).val(), from: 'modal', slideshow_id: slideshow_id},
  //   })
  //   .done(function(data) {
  //     $('.slide_results_panel').html(data);
  //   })
  // });

//   $('body').on('click', '.add_this_slide', function(event) {
//     event.preventDefault();
//     var id = $(this).attr('data-id');
//     $('.slide_add_info').fadeIn(500, function() {});
//     var html_to_add = "<a href='#' class='cancel_this_slide' data-id='"+id+"'>" + $(this).html() + "</a>";
//     $(this).parent().parent().fadeOut(500, function() {});
//     $('.slide_to_add').append(html_to_add);
//     $('.slide_to_add').append("<input type='hidden' name='slideshow[slides_to_add]["+id+"]' id='input_to_add_slide_"+id+"' value='"+id+"'>");
//   });


// $('body').on('click', '.cancel_this_slide', function(event) {
//   event.preventDefault();
//   var id = $(this).attr('data-id');
//   $('#input_to_add_slide_'+id).remove();
//   $(this).hide(200, function() {
//     $('#slide_container_for_slide_'+id).fadeIn(500, function() {});
//   });
// });

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

  // $('body').on('click', '.add_this_slide', function(event) {
  //   event.preventDefault();
  //   var html_to_add = $(this).parent().parent().html();
  //   var id = $(this).attr('data-id');
  //   $(this).parent().parent().hide(500, function() {});
  //   $('#slide_to_add').append(html_to_add);
  //   $('#slide_to_add').append("<input type='hidden' name='slides_to_add["+id+"]' value='"+id+"'>");
  // });

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


  //   $('body').on('submit', '.edit-slideshow-form', function(event) {
  //   event.preventDefault();
  //   var action = $(this).attr('action');
  //   $('.current_slideshows').css('opacity', '.5');
  //   $.ajax({
  //     url: action,
  //     type: 'PUT',
  //     data: $(this).serialize(),
  //   })
  //   .done(function(data) {
  //     $('.current_slideshows').html(data);
  //     $('button.close').trigger('click');
  //     $('.current_slideshows').css('opacity', '1');
  //     $('#editSlideShowModal').html("");
  //     idx = 0;
  //   })
  // });


  // $('body').on('click', '.inspect_this_slide', function(event) {
  //     var id = $(this).attr('data-id');
  //     var from = $(this).attr('data-from');
  //     $.ajax({
  //       url: '/slides/'+id+'/inspect_modal',
  //       data: {from: from}
  //     })
  //     .done(function(data) {
  //       $('#inspectSlide').html(data)
  //     })
  //   });

  // $('body').on('change', '#add-to-user-slide-show', function(event) {
  //   event.preventDefault();
  //   if ($(this).val() == '0') {
  //     return;
  //   };

  //   var slideshow_id = $(this).val();
  //   var slide_id = $(this).attr('slide-id');
  //   $.ajax({
  //     url: '/slideshows/'+slideshow_id+'/add_slide_to_slideshow',
  //     data: {slide_id: slide_id},
  //   })
  //   .done(function(data) {
  //     if(data.status == 'error'){
  //       $('.message-center-error').text(data.message);
  //       $('.message-center-error').fadeIn(500, function() {});
  //     } else {
  //       $('button.close').trigger('click');
  //       $('.message-center-success').text(data.message);
  //       $('.message-center-success').fadeIn(500, function() {});
  //     }
  //     fadeMessageOut();
  //   })

  // });

  function fadeMessageOut(){
      $('.message-center').animate({
        backgroundColor: 'transparent'},
        1000, function() {
          $('.message-center').fadeOut(500, function() {});
      });
  }


  $('body').on('click', '.pagination_link_container a', function(event) {
    event.preventDefault();
    var page = $(this).attr('href').split('=')[1];
    var url = '/slideshows/reload_pag_user'

    $.ajax({
      url: url,
      data: {page: page},
    })
    .done(function(data) {
      $('.slideshow_list_sect_container').html(data);
    })
  });


  $('body').on('click', '.delete-this-show', function(event) {
    event.preventDefault();
    var id = $(this).attr('data-id');
    $.ajax({
      url: '/slideshows/' + id,
      type: 'DELETE',
    })
    .done(function(data) {
      var id2 = data.id
      $('.container_for_slideshow_thumb_for_' + id2).hide(500, function() {

      });
    })
  });

  $('body').on('click', '.add-this-tag-to-slide', function(event) {
    event.preventDefault();
    $(this).hide('500', function() {
      var tag_id = $(this).attr('tag-id');
      var slide_id = $(this).parent().attr('slide-id');


      $.ajax({
        url: '/taggings',
        type: 'POST',
        data: {tag_id: tag_id, slide_id: slide_id},
      })
      .done(function(data) {
        $('.tag-current').append(data);
        $('#tag-search-bar').val('')
      })
    });
  });

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


  $('body').on('keyup', 'input#tag-search-bar', function(event) {
    event.preventDefault();
    var phrase = $(this).val();
    $.ajax({
      url: '/taggings/tag_results',
      data: {phrase: phrase},
    })
    .done(function(data) {
      $('.tag-results').html(data);
    })

  });

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






