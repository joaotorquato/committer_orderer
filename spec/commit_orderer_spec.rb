require 'spec_helper'

RSpec.describe CommitOrderer do
  before do
    db = double
    allow(CommitFetcher).to receive(:new).and_return(db)
    allow(db).to receive(:fetch).and_return(
      JSON.parse(File.new('spec/support/commits.json').read)
    )
  end

  describe '#call' do
    it 'creates a file with the result of the ordering' do
      CommitOrderer.call

      result = File.new(path_from_last_file_of_tmp).read
      expect(result).to eq(File.new('spec/support/result.txt').read)
    end
  end

  def path_from_last_file_of_tmp
    Dir.glob(File.join('tmp', '*.*')).max do |a, b|
      File.ctime(a) <=> File.ctime(b)
    end
  end
end
