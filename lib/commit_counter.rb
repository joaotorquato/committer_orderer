require 'net/http'

class CommitCounter
  attr_accessor :data, :commits, :counter

  def initialize
    @commits = CommitFetcher.new.fetch
    @data = {}
    @counter = {}
  end

  def count
    commits.each do |commit|
      save_authors_data(commit)
      email = commit['commit']['author']['email']
      @counter[email] = 1 unless @counter[email]
      @counter[email] += 1 if @counter[email]
    end
    @counter
  end

  private

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
end
