class UploadCsvJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    Report.import_file(file)
  end
end
