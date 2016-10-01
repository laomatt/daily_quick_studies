$(document).ready(function() {
  // GLOBAL VIEWS
  $.getScript("/js_views/create_slide_show_modal.js")
  $.getScript("/js_views/slide_results_items.js")
  $.getScript("/js_views/slideshow_search_results.js")
  $.getScript("/js_views/inspect_slide_modal.js")
  $.getScript("/js_views/upload_slides_modal2.js")

  // CLICK EVENTS


  // pagination event
  $('body').on('click', '.pagination_link_container a', function(event) {
    event.preventDefault();
    var url = $(this).attr('href')
    thisPage.changePage(url)
  });

});

