# ![PackingPeanut Logo](./_art/logo_100.png) PackingPeanut 

iOS has [BubbleWrap](https://github.com/rubymotion/BubbleWrap) for App Persistence : Android has PackingPeanut

There is a sedulous effort to make this syntax fit BubbleWrap's as much as possible, but differences simply exist, either for good, technical, or sometimes diabolical reasons :smiling_imp:

[**GITHUB HOMEPAGE**](http://gantman.github.io/PackingPeanut/)

## Installation

**Step 1:** Add this line to your application's Gemfile:

    gem 'PackingPeanut'

**Step 2:** And then execute:

    $ bundle

## Usage

Example Usage from REPL
```
# PP automatically has context if the module is included
# In this case we need to set the context
$ App::Persistence.context = self
=> #<MainActivity:0x1d20058e>
$ App::Persistence['dinner'] = "nachos"
=> true  # This differs from Bubblewrap.... boolean on success for save (more informative)
$ App::Persistence['dinner'] 
=> "nachos"
$ App::Persistence[:lunch] = "tacos"
=> "tacos" # Use symbols or strings as you please
$ App::Persistence.all
=> [{:dinner=>"nachos"}, {:lunch=>"tacos"}]
$ App::Persistence.storage_file = "some_new_file"
=> "some_new_file"
$ App::Persistence['dinner']
=> ""  # empty because we're now outside the default storage file.
$ App::Persistence.preference_mode = :world_readable
=> :world_redable

```

`App::Persistence` has been Aliasted to `PP::Persistence` for the bold.

## What are preference modes?

Preference Modes are ANdroid Operating modes. Use 0 or MODE_PRIVATE for the default operation, MODE_WORLD_READABLE and MODE_WORLD_WRITEABLE to control permissions. The bit MODE_MULTI_PROCESS can also be used if multiple processes are mutating the same SharedPreferences file. MODE_MULTI_PROCESS is always on in apps targeting Gingerbread (Android 2.3) and below, and off by default in later versions.

Memorizable symbols and their corresponding constants:
```ruby
    PREFERENCE_MODES = {
      private: MODE_PRIVATE,
      readable: MODE_WORLD_READABLE,
      world_readable: MODE_WORLD_READABLE,
      writable: MODE_WORLD_WRITEABLE,
      world_writable: MODE_WORLD_WRITEABLE,
      multi: MODE_MULTI_PROCESS,
      multi_process: MODE_MULTI_PROCESS
    }
```

## Limitations?
Achilles, the Death Star, and video game villians always have a significant catch.   As of right now, you can only store strings, ints, and booleans.   The data is serialized, and should support hashes, arrays, and floats but alas, I claim there be bugs in conversions via RM Android.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Ponder life... for at least like... 5 minutes
6. Create new Pull Request
