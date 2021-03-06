require 'spec_helper'

RSpec.describe CommitCounter do
  before do
    db = double
    allow(CommitFetcher).to receive(:new).and_return(db)
    allow(db).to receive(:fetch).and_return(
      JSON.parse(File.new('spec/support/commits.json').read)
    )
  end

  describe '#count' do
    it 'counts the commits per person' do
      count = CommitCounter.new.count

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

  describe '#data' do
    it 'fetchs the data from the authors and save on a hash' do
      counter = CommitCounter.new
      counter.count

      first_data = [
        'carlosoteras@gmail.com',
        { name: 'Carlos Henrique',
          email: 'carlosoteras@gmail.com',
          login: 'soteras',
          avatar_url: 'https://avatars3.githubusercontent.com/u/12816947?v=4' }
      ]

      expect(counter.data.first).to eq(first_data)
    end
  end
end
