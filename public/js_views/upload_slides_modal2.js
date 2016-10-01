var uploadSlideModal = Backbone.View.extend({
  el: 'form.create-new-slide-form',
  initialize: function(){
    $('body').on('click', 'button.close', function(event) {
      event.preventDefault();
      upload.resetForm();
    });

    $('body').on('submit', this.$el, function(event) {
      // debugger
      event.preventDefault();
      upload.resetForm();
      var fileInput = document.getElementById("picture");
      var files = fileInput.files;
      var length = files.length;
      var formData = new FormData( this );
        $.each(files, function(index, val) {
          upload.startUpload(val, length, formData);
        })
    });
  },
  startUpload: function(val, length, formData){
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
            $('#uploaded_so_far').append('<img src="'+data.url+'" alt="" class="img-responsive img-thumbnail tiny-thumb" style="display:none;">')
          }
          var new_idx = $('#uploaded_so_far .tiny-thumb').length;
          $('#uploaded_so_far .tiny-thumb').fadeIn(1000);
          $('#uploaded_so_far .tiny-thumb').animate({'margin-left': 0}, 1000);
          $('form.create-new-slide-form').trigger('reset');
          var prog = " - (Uploaded " + new_idx + " of " + length + " slides)";
          $('#prog_report').text(prog);
          if(new_idx >= length){
            $('#progress_message').fadeOut(500, function() {
              $('form.create-new-slide-form').fadeIn(500, function() {});
            });
          }
        })
  },
  resetForm: function(){
    $('#uploaded_so_far .tiny-thumb').fadeOut(200, function() {
      $('#prog_report').text('');
      $('#uploaded_so_far').html('');
    });

    $('form.create-new-slide-form').fadeOut(500, function() {
      $('#progress_message').fadeIn(500, function() {});
    });
  }

})

var upload = new uploadSlideModal();