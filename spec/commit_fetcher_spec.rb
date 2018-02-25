require 'spec_helper'

RSpec.describe CommitFetcher do
  before do
    allow(Net::HTTP).to receive(:get).and_return(
      File.new('spec/support/github/response_page_1.json').read,
      File.new('spec/support/github/response_page_2.json').read,
      File.new('spec/support/github/response_page_3.json').read,
      File.new('spec/support/github/response_page_4.json').read,
      File.new('spec/support/github/response_page_5.json').read
    )
  end

  describe '#fetch' do
    it 'returns the commits from github' do
      fetched_json = CommitFetcher.new.fetch

      full_response = File.new('spec/support/commits.json').read

      expect(fetched_json).to eq(JSON.parse(full_response))
    end
  end
end
