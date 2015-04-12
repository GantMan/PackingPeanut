# PackingPeanut

iOS has BubbleWrap for App Persistence : Android has **PackingPeanut**

## Installation

Add this line to your application's Gemfile:

    gem 'PackingPeanut'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install PackingPeanut

## Usage

Example Usage
```
$ App::Persistence['dinner'] = "nachos"
=> true  # This differs from Bubblewrap.... boolean on success for save (more informative)
$ App::Persistence['dinner'] 
=> "nachos"
$ App::Persistence['lunch'] = "tacos"
$ App::Persistence.all
=> {"dinner"=>"nachos", "lunch"=>"tacos"}
$ App::Persistence.storage_file = "some_new_file"
=> "some_new_file"
$ App::Persistence.preference_mode = :world_readable
=> :world_redable
$ App::Persistence['dinner']
=> ""  # empty because we're now in a new storage file.

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Ponder life... for at least like... 5 minutes
6. Create new Pull Request
