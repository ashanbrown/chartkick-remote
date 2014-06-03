# Chartkick Remote

## Usage

This is an add-on to ankane's Chartkick to allow the user to specify chart data in a block and have it automatically sourced remotely to avoid making too many queries in the original page render.

For more on the fabulous Chartkick library, see http://ankane.github.io/chartkick/.

To use this addon, you can specify the `remote` option and pass your data as a block:

```ruby
<%= line_chart(remote: true) { Task.group_by_day(:completed_at).count } %>
```

In your controller, add the following to tell the controller to respond to json requests for chart data:

```ruby
include Chartkick::Remote
chartkick_remote
```

You can also still use the block syntax without the remote flag if you want to make the query when rendering the page:

```ruby
<%= line_chart { Task.group_by_day(:completed_at).count } %>
```

Finally, you can turn on remote requests for all blocks, by setting:

```ruby
Chartkick.options = {
  remote: true
}
```

## Installation

First, set up 'chartkick' as described at http://ankane.github.io/chartkick/.

Then, add this line to your application's Gemfile:

```
gem 'chartkick-remote'
```

## How it Works

This gem works by *not* executing "remote" blocks when initially rendering your html page or when making any json request other than the single request that actually needs the data generated in that block.  When responding to a json request, the controller will actually render your template, but only to a string that it will discard, and only so that it can find and execute the one block that is generating the data for this json request.  This means that:
  
  * You can't use results from any code included in any prior "remote" blocks.
  * You should try to do minimal work outside of your block, so that it doesn't get executed unnecessarily for each json request.  Specifically, if you define partial results that you will use in your block, make sure that they are lazily evaluated.






