require 'spec_helper'

RSpec.describe CommitOrderer do
  before do
    db = double
    allow(CommitFetcher).to receive(:new).and_return(db)
    allow(db).to receive(:fetch).and_return(
      JSON.parse(File.new('spec/support/commits.json').read)
    )
  end

  describe '#count_commits' do
    it 'counts the commits per person' do
      count = CommitOrderer.new.count_commits

      expect(count).to match('a.andremr@gmail.com' => 5,
                             'alexandre.sns@gmail.com' => 3,
                             'antonio.filho@dinda.com.br' => 59,
                             'antonio@compilandosolucao.com.br' => 9,
                             'bnascimento@avenuecode.com' => 2,
                             'carlosoteras@gmail.com' => 2,
                             'contato@marciotoshio.com.br' => 2,
                             'daniel.coca@youse.com.br' => 3,
                             'daniel.vidal@youse.com.br' => 2,
                             'denisantoniazzi@icloud.com' => 2,
                             'dnl_stunts@hotmail.com' => 2,
                             'greenmetal@gmail.com' => 2,
                             'kassio.borges@plataformatec.com.br' => 3,
                             'kassioborgesm@gmail.com' => 2,
                             'lucas.mazza@plataformatec.com.br' => 2,
                             'marcio.ide@dinda.com.br' => 2,
                             'pedro@pmatiello.me' => 11,
                             'rbrancher@gmail.com' => 2)
    end
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
