require 'test_helper'

class WordnetDefinitionsControllerTest < ActionController::TestCase
  setup do
    @wordnet_definition = wordnet_definitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wordnet_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wordnet_definition" do
    assert_difference('WordnetDefinition.count') do
      post :create, :wordnet_definition => @wordnet_definition.attributes
    end

    assert_redirected_to wordnet_definition_path(assigns(:wordnet_definition))
  end

  test "should show wordnet_definition" do
    get :show, :id => @wordnet_definition.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @wordnet_definition.to_param
    assert_response :success
  end

  test "should update wordnet_definition" do
    put :update, :id => @wordnet_definition.to_param, :wordnet_definition => @wordnet_definition.attributes
    assert_redirected_to wordnet_definition_path(assigns(:wordnet_definition))
  end

  test "should destroy wordnet_definition" do
    assert_difference('WordnetDefinition.count', -1) do
      delete :destroy, :id => @wordnet_definition.to_param
    end

    assert_redirected_to wordnet_definitions_path
  end
end
