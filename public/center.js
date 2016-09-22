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
    $(this).find('img').addClass('active-slide');
    $('.slides_to_remove').append("<input type='hidden' name='slideshow[slides_to_remove]["+idx2+"]' value='"+id+"'>");

    // remove something from remove
  });

  var idx = 0;
  $('body').on('click', '.add-this-slide', function(event) {
    event.preventDefault();
    // adding something to add
    var id = $(this).attr('data-id');
    var image = $(this).html();
    idx += 1;
    var input_html = image + "<input type='hidden' name='slideshow[slides_to_add]["+idx+"]' value='"+id+"'>"
    $('.slides_to_add').append(input_html)

    // remove something to add
  });

// edit modal

$('body').on('click', '.edit-slideshow-button', function(event) {
    event.preventDefault();
    $('.edit-slideshow-form').trigger('submit');
  });

  $('body').on('keyup', '#slide_search_input', function(event) {
    event.preventDefault();
    var url = '/slides/search_reload_pag'
    $.ajax({
      url: url,
      data: {page: 1, search: $(this).val()},
    })
    .done(function(data) {
      $('.slide_results_panel').html(data);
    })
  });

  $('body').on('click', '.add_this_slide', function(event) {
    event.preventDefault();
    var html_to_add = $(this).parent().parent().html();
    var id = $(this).attr('data-id');
    $(this).parent().parent().hide(500, function() {});
    $('.slide_to_add').append(html_to_add);
    $('.slide_to_add').append("<input type='hidden' name='slideshow[slides_to_add]["+id+"]' value='"+id+"'>");
  });

});




// index slides

  // my account
