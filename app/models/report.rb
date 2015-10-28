require 'csv'

class Report < ActiveRecord::Base
  has_attached_file :generated_report
  validates_attachment :generated_report, content_type: { content_type: ["text/html", "text/plain", "text/csv"] }

  def self.import_file(path)
    # Completes in roughly 8.5 minutes
    CSV.foreach(path, headers: true) do |row|
      Hit.create!(match_gene_name: row[7], match_gene_dna: row[8], percent_similarity: row[9],
          subject: Gene.create!(dna: row[4], starting_position: row[5], direction: row[6],
          sequence: Sequence.create!(dna: row[2], quality: row[3],
          assembly: Assembly.create!(name: row[0] ))))
    end
  end
end
