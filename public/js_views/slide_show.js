var SlideshowObj = Backbone.View.extend({
  el: '.slideshow_list_sect_container',
  initialLocals: { page: 1, context_page: 'account' },
  initialize: function(){
    this.$el.text('loading...')
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
