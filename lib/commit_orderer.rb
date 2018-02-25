require 'net/http'

class CommitOrderer
  def initialize
    @data = {}
    @commits = CommitFetcher.new.fetch
  end

  def self.call
    new.export
  end

  def count_commits
    result = {}
    commits.each do |commit|
      save_authors_data(commit)
      email = commit['commit']['author']['email']
      result[email] = 1 unless result[email]
      result[email] += 1 if result[email]
    end
    result
  end

  def ordered_by_desc
    count_commits.sort_by { |_k, v| v }.reverse
  end

  def export
    f = File.new("tmp/committer_orderer_#{Time.new}.txt", 'w')
    ordered_by_desc.map do |email, counter|
      f << txt_line(email, counter)
    end
    f.close
  end

  private

  attr_accessor :data, :commits

  def save_authors_data(commit)
    save_author(commit) if commit['author']
    save_unknow_user(commit) unless commit['author']
  end

  def save_author(commit)
    data[commit['commit']['author']['email']] = {
      name: commit['commit']['author']['name'],
      email: commit['commit']['author']['email'],
      login: commit['author']['login'],
      avatar_url: commit['committer']['avatar_url']
    }
  end

  def save_unknow_user(commit)
    data[commit['commit']['author']['email']] = {
      name: commit['commit']['author']['name'],
      email: commit['commit']['author']['email'],
      login: '',
      avatar_url: ''
    }
  end

  def txt_line(email, counter)
    [data[email][:name],
     data[email][:email],
     data[email][:login],
     data[email][:avatar_url],
     counter].join(';') + "\n"
  end
end
