var SlideshowObj = Backbone.View.extend({
  el: '.slideshow_list_sect_container',
  initialLocals: { page: 1 },
  initialize: function(){
    this.getShowPartial( '/slideshows/reload_pag', this.initialLocals);
  },
  changePage: function(url) {
    this.getShowPartial(url,{})
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

