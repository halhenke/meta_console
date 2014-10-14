# MetaConsole

**This isnt ready yet** for much of anything....so yeah.

OK - so I want this to have most of my stuff thats currently in `meta_methods` script as a Gem.

## Installation

Add this line to your application's Gemfile:

    gem 'meta_console'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install meta_console

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/meta_console/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Me Flailing Around...

### CANT GET THIS TO FUCKING WORK!!!
- is it because of the requires in the actual modules?
*holy fuck - IT WORKS NOW*
- why?
  - I uninstalled the old version
- now if I do
  - `require "meta_console"`
- from pry it works...
- Actually
  - no need to require - its already loaded...

### FOR RAILS
- For Local Installation
- In Gemfile
  - `gem 'meta_console', path: "~/code/Ruby/My First Gem/meta_console"`
