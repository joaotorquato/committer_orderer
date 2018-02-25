require 'net/http'

class CommitOrderer
  def initialize
    @data = {}
    @commits = CommitFetcher.new.fetch
  end

  def self.call
    new.order
  end

  def count_commits
    result = {}
    commits.each do |commit|
      save_data(commit)
      email = commit['commit']['author']['email']
      result[email] = 1 unless result[email]
      result[email] += 1 if result[email]
    end
    result
  end

  def order
    count_commits.sort_by { |_k, v| v }.reverse.map do |email, counter|
      txt_line(email, counter)
    end.join("\n") + "\n"
  end

  private

  attr_accessor :data, :commits

  def save_data(commit)
    save_committer(commit) if commit['committer']
    save_author(commit) if commit['author']
    save_unknow_user(commit) unless commit['committer'] && commit['author']
  end

  def save_committer(commit)
    data[commit['commit']['committer']['email']] = {
      name: commit['commit']['committer']['name'],
      email: commit['commit']['committer']['email'],
      login: commit['committer']['login'],
      avatar_url: commit['committer']['avatar_url']
    }
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
     counter].join(';')
  end
end
