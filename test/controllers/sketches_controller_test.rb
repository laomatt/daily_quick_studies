require 'test_helper'

class SketchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sketch = sketches(:one)
  end

  test "should get index" do
    get sketches_url
    assert_response :success
  end

  test "should get new" do
    get new_sketch_url
    assert_response :success
  end

  test "should create sketch" do
    assert_difference('Sketch.count') do
      post sketches_url, params: { sketch: {  } }
    end

    assert_redirected_to sketch_url(Sketch.last)
  end

  test "should show sketch" do
    get sketch_url(@sketch)
    assert_response :success
  end

  test "should get edit" do
    get edit_sketch_url(@sketch)
    assert_response :success
  end

  test "should update sketch" do
    patch sketch_url(@sketch), params: { sketch: {  } }
    assert_redirected_to sketch_url(@sketch)
  end

  test "should destroy sketch" do
    assert_difference('Sketch.count', -1) do
      delete sketch_url(@sketch)
    end

    assert_redirected_to sketches_url
  end
end
