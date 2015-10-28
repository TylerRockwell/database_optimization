class ReportsController < ApplicationController
  # helper_method :memory_in_mb

  def all_data
  end

  def index
    if params[:email]
      # GenerateCsvJob.perform_later(params[:name])
      @start_time = Time.now
      @assembly = Assembly.find_by_name(params[:name])
      @hits = Hit.where(subject: Gene.where(sequence: Sequence.where(assembly: @assembly)))
      @data = render_to_string(action: :all_data, template:"reports/report.html.erb")
      path = Rails.root.join("tmp","report.html")
      file = File.open(path, "w+") do |f|
        f.write(@data)
      end
      Report.create(generated_report: File.open(Rails.root.join("tmp","report.html")))
      ReportMailer.report_data(params[:email]).deliver_later
    end
  end

  def import
  end

  def upload
    UploadCsvJob.perform_later(params[:file].path)
  end

  def search
    if params[:search]
      q = "%#{params[:search]}%"
      @assemblies = Assembly.joins(sequences: {genes: :hits}).
          where("name LIKE ? OR genes.dna LIKE ? OR hits.match_gene_name LIKE ?", q, q, q)
    end
  end

  # private def memory_in_mb
  #   `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  # end
end
