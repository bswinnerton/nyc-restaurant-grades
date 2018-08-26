class UpdateDatasetWorker
  include Sidekiq::Worker

  def perform(*args)
    Rails.application.load_seed
  end
end
