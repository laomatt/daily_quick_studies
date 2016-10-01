$(document).ready(function() {
  // GLOBAL VIEWS
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

  var slideResults = Backbone.View.extend({
    el: '#slide_search_input',
    initialize: function(){
      $('body').on('keyup', '#search-bar', function(event) {
        event.preventDefault();
        var phrase = $(this).val();
        thisPage.getShowPartial('/slideshows/search_slideshows', {phrase: phrase});
      });

      $('body').on('keyup', '#slide_search_input', function(event) {
        event.preventDefault();
        var slideshow_id = $(this).attr('slideshow-id');
        slideSearchResults.search(slideshow_id);
      });
    },
    search: function(slideshow_id){
      $.ajax({
        url: '/slides/search_reload_pag',
        data: {page: 1, search: this.$el.val(), from: 'modal', slideshow_id: slideshow_id},
      })
      .done(function(data) {
        $('.slide_results_panel').html(data);
      })
    }
  })

  var slideResultItem = Backbone.View.extend({
    el: '.slide_to_add',
    initialize: function (){

    },
    addSlide: function(){

    },
    removeSlide: function(){

    }
  })

  // CLICK EVENTS

  var create = new createSlideshow();
  var slideSearchResults = new slideResults();

  // pagination event
  $('body').on('click', '.pagination_link_container a', function(event) {
    event.preventDefault();
    var url = $(this).attr('href')
    thisPage.changePage(url)
  });


  // $('body').on('keyup', '#search-bar', function(event) {
  //   event.preventDefault();
  //   var phrase = $(this).val();
  //   thisPage.getShowPartial('/slideshows/search_slideshows', {phrase: phrase});
  // });

  // $('body').on('click', '.create-slideshow-button', function(event) {
  //   event.preventDefault();
  //   create.submitForm();
  // });

  // $('body').on('keyup', '#slide_search_input', function(event) {
  //   event.preventDefault();
  //   var slideshow_id = $(this).attr('slideshow-id');
  //   slideSearchResults.search(slideshow_id);
  // });


});

