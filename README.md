# Dictionary

Welcome to the Dictionary application! This application includes a Multi-value-dictionary that allows each key to store a
list of unique values.

## Pre-requisites for execution:

Requires ruby version `>= 2.5.0` to be installed on the local machine.

## Usage

To experiment with the app here perform the following steps:
1. Install the required pre-prequisites.
2. Grab this repo on your machine `git clone https://github.com/prakash03/dictionary.git`
2. `cd dictionary`
3. Run `bin/console`. This should install other dependencies (like `rspec` for unit testing and `rubocop` for static code analysis) and fire up an interactive prompt.

The prompt now allows us to create and run a Multi-value-dictionary.

Multi-value-dictionary allows the following actions:

1. add
2. remove
3. members
4. keys
5. remove_all
6. clear
7. key_exists?
8. value_exists?
9. all_members
10. items

Code documentation related to each of these actions can be found [here](https://github.com/prakash03/dictionary/blob/master/lib/dictionary/multi_value_dictionary.rb).

### Example usage:

```ruby
$ bin/console
> app = MultiValueDictionary.new
=> #<MultiValueDictionary:0x00007ff25b1e7af8 @dict={}>

> app.add("foo", "bar") # Adds a given key, value pair to dictionary
=> ["bar"]

> app.add("foo", "dome")
=> ["bar", "dome"]

> app.add("rome", "italy")
=> ["italy"]

> app.members("foo") # Displays values corresponding to a key
=> ["bar", "dome"]

> app.dict # Displays the entire dictionary
=> {"foo"=>["bar", "dome"], "rome"=>["italy"]}

> app.members("hello") # Raises an error
MultiValueDictionary::KeyUnavailableError: 'hello' doesnt exist in the dictionary.

> app.items
=> [{"foo"=>"bar"}, {"foo"=>"dome"}, {"rome"=>"italy"}]

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
