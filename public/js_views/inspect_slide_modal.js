var inspectSlideModal = Backbone.View.extend({
  el: '#inspectSlide',
  initialize: function(){
    $('body').on('click', '.inspect_this_slide', function(event) {
        var id = $(this).attr('data-id');
        var from = $(this).attr('data-from');
        inspect.populate(id, from);
      });

    $('body').on('change', '#add-to-user-slide-show', function(event) {
      event.preventDefault();
      var slideshow_id = $(this).val();
      var slide_id = $(this).attr('slide-id');
      inspect.addToSlideshow(slide_id, slideshow_id);
    });
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