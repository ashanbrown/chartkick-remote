# Chartkick Remote

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

You can also still use the block syntax without the remote syntax if you want to make the query when rendering the page:

```ruby
<%= line_chart { Task.group_by_day(:completed_at).count } %>
```

Finally, you can turn on remote requests for all blocks, by setting:

```ruby
Chartkick.options = {
  remote: true
}
```






