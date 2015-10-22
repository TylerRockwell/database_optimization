class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now

    @sequences = []
    @genes = []
    @hits = []
    @assembly = Assembly.find_by_name(params[:name])
    # @assemblies = Assembly.joins(sequences: {genes: :hits}).
    #     where("id = ?", params[:name])

    # @assembly.sequences.each do |s|
    #   @sequences << s
    #   s.genes.each do |g|
    #     @genes << g
    #     g.hits.each do |h|
    #       @hits << h
    #     end
    #   end
    # end
    # @everything = Sequence.all.includes(genes: :hits)
    # @sequences = @everything.select{|sequence| sequence[:assebly_id] == @assembly.id}
    # @hits.sort! {|a, b| b.percent_similarity <=> a.percent_similarity}
    # sequences = Sequence.where(assembly: @assembly)
    # genes = Gene.where(sequence: sequences)
    @hits = Hit.where(subject: Gene.where(sequence: Sequence.where(assembly: @assembly)))

    @memory_used = memory_in_mb
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

  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
