class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.report_data.subject
  #
  def report_data(assembly_name)
    @start_time = Time.now

    @sequences = []
    @genes = []
    @hits = []
    @assembly = Assembly.find_by_name(assembly_name)

    @hits = Hit.where(subject: Gene.where(sequence: Sequence.where(assembly: @assembly)))

    mail to: "data_report@mailinator.com", subject: "Data Report"
  end
end
