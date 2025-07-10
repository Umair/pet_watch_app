require "test_helper"

class Api::V1::PetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "apiuser@example.com", password: "password")
    @pet = Pet.create!(name: "Rex", breed: "German Shepherd", age: 4, user: @user)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @headers = { 'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json' }
  end

  test "should get index" do
    get "/api/v1/pets", headers: @headers
    assert_response :success
    assert_includes @response.body, @pet.name
  end

  test "should show pet" do
    get "/api/v1/pets/#{@pet.id}", headers: @headers
    assert_response :success
    assert_includes @response.body, @pet.breed
  end

  test "should create pet" do
    assert_difference('Pet.count') do
      post "/api/v1/pets", params: { pet: { name: "Milo", breed: "Beagle", age: 2 } }.to_json, headers: @headers
    end
    assert_response :created
    assert_includes @response.body, "Milo"
  end

  test "should not create pet with missing name" do
    post "/api/v1/pets", params: { pet: { breed: "Beagle", age: 2 } }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_includes @response.body, "Name"
  end

  test "should not create pet with missing breed" do
    post "/api/v1/pets", params: { pet: { name: "Milo", age: 2 } }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_includes @response.body, "Breed"
  end

  test "should not create pet with missing age" do
    post "/api/v1/pets", params: { pet: { name: "Milo", breed: "Beagle" } }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_includes @response.body, "Age"
  end

  test "should not create pet with negative age" do
    post "/api/v1/pets", params: { pet: { name: "Milo", breed: "Beagle", age: -1 } }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_includes @response.body, "greater than or equal to 0"
  end

  test "should not create pet with age above max" do
    post "/api/v1/pets", params: { pet: { name: "Milo", breed: "Beagle", age: 31 } }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_includes @response.body, "less than or equal to 30"
  end

  test "should mark vaccination as expired" do
    patch "/api/v1/pets/#{@pet.id}/mark_expired", headers: @headers
    assert_response :success
    @pet.reload
    assert @pet.vaccination_expired
  end

  test "should not allow unauthenticated access" do
    get "/api/v1/pets"
    assert_response :unauthorized
  end
end 