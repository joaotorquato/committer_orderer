require 'spec_helper'

RSpec.describe CommitOrderer do
  describe '#commits' do
    it 'returns the commits from the repo' do
      orderer = CommitOrderer.commits

      result = JSON.parse(File.new('spec/support/commits.json').read)
      expect(orderer).to match(result)
    end
  end

  describe '#count_commits' do
    it 'counts the commits per person' do
      count = CommitOrderer.new.count_commits

      expect(count).to match({
        "andre-rodrigues" => 3,
        "antoniofilho" => 2,
        "bvicenzo" => 3,
        "danielvidal" => 2,
        "detierno" => 6,
        "j133y" => 5,
        "kassio" => 5,
        "lucasmazza" => 7,
        "rbrancher" => 2,
        "soteras" => 2,
        "stunts" => 4,
      })
    end
  end

  describe '#call' do
    it 'returns the commiters in order' do
      order = CommitOrderer.call

      expect(order).to eq(File.new('spec/support/result.txt').read)
    end
  end
end
