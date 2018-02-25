require 'net/http'

class CommitOrderer
  COMMITS_URL = 'https://api.github.com/repos/Dinda-com-br/braspag-rest/commits'.freeze

  def initialize
    @data = {}
  end

  def self.call
    self.new.order
  end

  def self.commits
    JSON.parse(Net::HTTP.get(URI(COMMITS_URL)))
  end

  def count_commits
    result = {}
    CommitOrderer.commits.each do |commit|
      save_committer(commit) if commit['committer']
      save_author(commit) if commit['author']
      login = data.keys.last
      result[login] = 1 unless result[login]
      result[login] += 1 if result[login]
    end
    result
  end

  def order
    count_commits.sort_by { |k,v| v }.reverse.map do |login, counter|
      [data[login][:name],
       data[login][:email],
       data[login][:login],
       data[login][:avatar_url],
       counter].join(';')
    end.join("\n") + "\n"
  end

  private

  attr_accessor :data


  def save_committer(commit)
    data[commit['committer']['login']] = {
      name: commit['commit']['committer']['name'],
      email: commit['commit']['committer']['email'],
      login: commit['committer']['login'],
      avatar_url: commit['committer']['avatar_url']
    }
  end

  def save_author(commit)
    data[commit['author']['login']] = {
      name: commit['commit']['author']['name'],
      email: commit['commit']['author']['email'],
      login: commit['author']['login'],
      avatar_url: commit['committer']['avatar_url']
    }
  end
end
