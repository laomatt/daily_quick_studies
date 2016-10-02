var createSlideshow = Backbone.View.extend({
  el: '.create-new-slideshow-form',
  initialize: function(){
    this.$el.trigger('reset');
    $('body').on('click', '.create-slideshow-button', function(event) {
      event.preventDefault();
      create.submitForm();
    });

  },
  submitForm: function(){
    $('.current_slideshows').css('opacity', '.5');
    $.ajax({
      url: '/slideshows/create_show',
      type: 'POST',
      data: this.$el.serialize(),
    })
    .done(function(data) {
      $('.create-new-slideshow-form').trigger('reset');
      $('.current_slideshows').html(data);
      $('button.close').trigger('click');
      $('.current_slideshows').css('opacity', '1');
      $('.slide_to_add').html('');
      idx = 0;
    })
    this.$el.trigger('reset');
  }
});

var create = new createSlideshow();