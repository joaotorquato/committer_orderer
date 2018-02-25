require 'net/http'

class CommitFetcher
  COMMITS_URL = 'https://api.github.com/repos/Dinda-com-br/braspag-rest/commits'.freeze

  def fetch
    commits = []
    result = 'notempty'
    page_number = 0
    until result.empty?
      result = fetch_page((page_number += 1))
      commits += result
    end
    commits
  end

  private

  def fetch_page(number)
    JSON.parse(Net::HTTP.get(URI(COMMITS_URL + "?page=#{number}")))
  end
end
