require 'net/http'

class CommitOrderer
  def initialize
    counter = CommitCounter.new
    @counter = counter.count
    @data = counter.data
  end

  def self.call
    new.export
  end

  def ordered_by_desc
    counter.sort_by { |_k, v| v }.reverse
  end

  def export
    f = File.new("tmp/committer_orderer_#{Time.new}.txt", 'w')
    ordered_by_desc.map do |email, number_commits|
      f << txt_line(email, number_commits)
    end
    f.close
  end

  private

  attr_accessor :data, :counter

  def txt_line(email, number_commits)
    [data[email][:name],
     data[email][:email],
     data[email][:login],
     data[email][:avatar_url],
     number_commits].join(';') + "\n"
  end
end
