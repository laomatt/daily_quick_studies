jQuery(document).ready(function($) {
  $('body').on('click', '.start_study', function(event) {
    $('#drawModal').html('');
    var id = $(this).attr('data-id');
    var type = $(this).attr('data-type');
    $.ajax({
      url: '/slideshows/' + id + '/draw_modal',
      data: {type: type}
    })
    .done(function(data) {
      $('#drawModal').html(data);
    })
  });

  $('body').on('click', '.start_study_random', function(event) {
    $('#drawModal').html('');
    var type = $(this).attr('data-type');
    $.ajax({
      url: '/slideshows/draw_random',
      data: {type: type}
    })
    .done(function(data) {
      $('#drawModal').html(data);
    })
  });

  $('body').on('submit', '.start-this-study', function(event) {
    event.preventDefault();
    $.ajax({
      url: '/slideshows/draw_pose',
      data: $(this).serialize()
    })
    .done(function(data) {
      $('button.close').trigger('click');
      $('#pose_window_container').html(data);
      $('#pose_window_container').fadeIn(500, function() {});
    })
  });

});