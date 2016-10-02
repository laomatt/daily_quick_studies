var editSlideShowModal = Backbone.View.extend({
  el: '#editSlideShowModal',
  initialize: function(){
    this.$el.html("");

    $('body').on('click', '.edit-this-show', function(event) {
      var id = $(this).attr('data-id');
      modal.populate(id);
    });

    $('body').on('click', '.delete-this-show', function(event) {
      event.preventDefault();
      var id = $(this).attr('data-id');
      modal.destroy(id);
    });

    $('body').on('click', '.edit-slideshow-button', function(event) {
        event.preventDefault();
        $('.edit-slideshow-form').trigger('submit');
      });

    $('body').on('submit', '.edit-slideshow-form', function(event) {
      event.preventDefault();
      modal.submitForm($(this));
    });

    $('body').on('click', '.remove-this-slide', function(event) {
      event.preventDefault();
      var id = $(this).attr('data-id');
      $(this).find('img').addClass('active-slide');
      modal.removeSlide(id);
    });

  },
  removeSlide: function(id){
    $(this).hide(500, function() {});
    $('.slides_to_remove').append("<input type='hidden' name='slideshow[slides_to_remove]["+id+"]' value='"+id+"'>");
  },
  populate: function(id){
    this.$el.html("");
    $.ajax({
      url: '/users/edit_slideshow_modal',
      data: {id: id},
    })
    .done(function(data) {
      $('#editSlideShowModal').html(data);
    })
  },
  submitForm: function(form){
    var action = form.attr('action');
    $('.current_slideshows').css('opacity', '.5');
    $.ajax({
      url: action,
      type: 'PUT',
      data: form.serialize(),
    })
    .done(function(data) {
      $('.current_slideshows').html(data);
      $('button.close').trigger('click');
      $('.current_slideshows').css('opacity', '1');
      $('#editSlideShowModal').html("");
      idx = 0;
    })
  },
  destroy: function(id){
    $.ajax({
      url: '/slideshows/' + id,
      type: 'DELETE',
    })
    .done(function(data) {
      var id2 = data.id
      $('.container_for_slideshow_thumb_for_' + id2).hide(500);
    })
  }
});

var modal = new editSlideShowModal();