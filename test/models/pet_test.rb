require "test_helper"

class PetTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password")
  end

  test "should be valid with valid attributes" do
    pet = Pet.new(name: "Buddy", breed: "Golden Retriever", age: 5, user: @user)
    assert pet.valid?
  end

  test "should require name" do
    pet = Pet.new(breed: "Golden Retriever", age: 5, user: @user)
    assert_not pet.valid?
    assert_includes pet.errors[:name], "can't be blank"
  end

  test "should require breed" do
    pet = Pet.new(name: "Buddy", age: 5, user: @user)
    assert_not pet.valid?
    assert_includes pet.errors[:breed], "can't be blank"
  end

  test "should require age" do
    pet = Pet.new(name: "Buddy", breed: "Golden Retriever", user: @user)
    assert_not pet.valid?
    assert_includes pet.errors[:age], "can't be blank"
  end

  test "should require age >= 0" do
    pet = Pet.new(name: "Buddy", breed: "Golden Retriever", age: -1, user: @user)
    assert_not pet.valid?
    assert_includes pet.errors[:age], "must be greater than or equal to 0"
  end

  test "should require age <= 30" do
    pet = Pet.new(name: "Buddy", breed: "Golden Retriever", age: 31, user: @user)
    assert_not pet.valid?
    assert_includes pet.errors[:age], "must be less than or equal to 30"
  end

  test "should belong to user" do
    pet = Pet.reflect_on_association(:user)
    assert_equal :belongs_to, pet.macro
  end
end 