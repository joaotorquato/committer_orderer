require 'json'

dir = File.expand_path(__dir__)
autoload :CommitOrderer, dir + '/commit_orderer'
autoload :CommitFetcher, dir + '/commit_fetcher'
autoload :CommitCounter, dir + '/commit_counter'
