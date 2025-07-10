class NotifyVaccinationExpiredJob < ApplicationJob
  queue_as :default

  # If you add a notification log or flag, check here for idempotency
  def perform(pet_id)
    pet = Pet.select(:id, :name, :user_id, :vaccination_expired).find_by(id: pet_id)
    unless pet
      Rails.logger.warn "[EMAIL][NotifyVaccinationExpiredJob] Pet not found for ID: #{pet_id}"
      return
    end

    # Idempotency: Only notify if not already notified (add a flag or notification log if needed)
    # For now, just log
    Rails.logger.info "[EMAIL][NotifyVaccinationExpiredJob] Notifying for pet: #{pet.name} (ID: #{pet.id})"

    # If using ActionMailer in the future:
    # PetMailer.vaccination_expired(pet).deliver_later

  rescue => e
    Rails.logger.error "[EMAIL][NotifyVaccinationExpiredJob] Error for pet_id #{pet_id}: #{e.class} - #{e.message}"
    raise # Let Sidekiq retry
  end
end 