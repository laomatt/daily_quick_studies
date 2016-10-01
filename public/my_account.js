var SlideshowObj = Backbone.View.extend({
  el: '.slideshow_list_sect_container',
  initialLocals: { page: 1, context_page: 'account' },
  initialize: function(){
    this.getShowPartial( '/slideshows/reload_pag_user', this.initialLocals);
  },
  changePage: function(url) {
    this.getShowPartial(url,{ context_page: 'account' })
  },
  getShowPartial: function(url, locals){
    $.ajax({
      url: url,
      data: locals,
    })
    .done(function(data) {
      $('.slideshow_list_sect_container').html(data);
    })
  }
});

var thisPage = new SlideshowObj();

var editSlideShowModal = Backbone.View.extend({
  el: '#editSlideShowModal',
  initialize: function(){
    this.$el.html("");
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
  destroy: function(id){
    $.ajax({
      url: '/slideshows/' + id,
      type: 'DELETE',
    })
    .done(function(data) {
      var id2 = data.id
      $('.container_for_slideshow_thumb_for_' + id2).hide(500, function() {

      });
    })
  }
});

var modal = new editSlideShowModal();

// edit and update slideshow
$('body').on('click', '.edit-this-show', function(event) {
  var id = $(this).attr('data-id');
  modal.populate(id);
});


$('body').on('click', '.delete-this-show', function(event) {
  event.preventDefault();
  var id = $(this).attr('data-id');
  modal.destroy(id);
});


