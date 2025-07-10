class PetsController < ApplicationController
  before_action :require_login

  def index
    @pets = current_user.pets
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = current_user.pets.build(pet_params)
    if @pet.save
      redirect_to pets_path, notice: 'Pet created successfully!'
    else
      flash.now[:alert] = @pet.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_login
    unless user_signed_in?
      redirect_to login_path, alert: 'You must be logged in to access this page.'
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :breed, :age)
  end
end
