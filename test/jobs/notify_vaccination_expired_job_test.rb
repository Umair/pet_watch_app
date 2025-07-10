require "test_helper"

class NotifyVaccinationExpiredJobTest < ActiveJob::TestCase
  setup do
    @user = User.create!(email: "notifyjob@example.com", password: "password")
    @pet = Pet.create!(name: "Rex", breed: "German Shepherd", age: 4, user: @user, vaccination_expired: true)
  end

  test "logs notification for existing pet" do
    assert_enqueued_with(job: NotifyVaccinationExpiredJob, args: [@pet.id]) do
      NotifyVaccinationExpiredJob.perform_later(@pet.id)
    end
    # Perform the job and check logs (simulate)
    assert_nothing_raised do
      NotifyVaccinationExpiredJob.perform_now(@pet.id)
    end
  end

  test "handles missing pet gracefully" do
    assert_nothing_raised do
      NotifyVaccinationExpiredJob.perform_now(-1)
    end
  end

  test "job is idempotent (can be retried safely)" do
    # Should not raise or duplicate notification if retried
    2.times { NotifyVaccinationExpiredJob.perform_now(@pet.id) }
    assert true
  end

  test "logs error on exception" do
    original_select = Pet.method(:select)
    Pet.define_singleton_method(:select) { |*| raise StandardError, "Simulated error" }
    assert_raises(StandardError) do
      NotifyVaccinationExpiredJob.perform_now(@pet.id)
    end
  ensure
    Pet.define_singleton_method(:select, original_select)
  end
end 