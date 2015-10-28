class GenerateCsvJob < ActiveJob::Base
  queue_as :default

  def perform(assembly_name)
    
  end
end
