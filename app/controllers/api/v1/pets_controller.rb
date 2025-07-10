module Api
  module V1
    class PetsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
      before_action :set_pet, only: [:show, :mark_expired]

      # GET /api/v1/pets
      def index
        pets = current_user.pets
        render json: pets
      end

      # GET /api/v1/pets/:id
      def show
        render json: @pet
      end

      # POST /api/v1/pets
      def create
        pet = current_user.pets.build(pet_params)
        if pet.save
          Rails.logger.info "[API] Pet created: #{pet.inspect} by user #{current_user.id}"
          render json: pet, status: :created
        else
          render json: { errors: pet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/pets/:id/mark_expired
      def mark_expired
        if @pet.vaccination_expired?
          render json: { message: 'Vaccination already marked as expired.', pet: @pet }, status: :ok
        elsif @pet.update(vaccination_expired: true)
          Rails.logger.info "[API] Vaccination marked as expired for pet #{ @pet.id } by user #{ current_user.id }"
          NotifyVaccinationExpiredJob.perform_later(@pet.id)
          render json: @pet, status: :ok
        else
          render json: { errors: @pet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_pet
        @pet = current_user.pets.find_by(id: params[:id])
        unless @pet
          render json: { errors: ['Pet not found'] }, status: :not_found
        end
      end

      def pet_params
        params.require(:pet).permit(:name, :breed, :age)
      end
    end
  end
end 