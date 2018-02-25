# Committer Orderer Test

This is a program that fetchs the commits from a repo and order it from the most
committer to last committer, saving it on a file on tmp folder.

## Running

To run this application:

    $ ruby order_now.rb

check tmp folder to see the result.

### Automated tests with RSpec

You can run all tests using:

    $ rspec

The specs will generate a file on tmp folder as well, but with mocked responses
from Github API. So in case you can't make a request to the Github, just run
the specs and see the result :)
