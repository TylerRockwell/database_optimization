class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.report_data.subject
  #
  def report_data(email)
    mail to: email, subject: "Data Report"
  end
end
