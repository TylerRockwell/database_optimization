class ReportsController < ApplicationController
  # helper_method :memory_in_mb

  def all_data
    ReportMailer.report_data(params[:name]).deliver_later
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

  def send_mail
    ReportMailer.report_data.deliver_now
  end

  # private def memory_in_mb
  #   `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  # end
end
