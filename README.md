# Chartkick Remote [![Gem Version](https://badge.fury.io/rb/chartkick-remote.svg)](http://badge.fury.io/rb/chartkick-remote)&nbsp;[![Travis CI Status](https://travis-ci.org/dontfidget/chartkick-remote.png?branch=master)](https://travis-ci.org/dontfidget/chartkick-remote)&nbsp;[![Code Climate](https://codeclimate.com/github/dontfidget/chartkick-remote.png)](https://codeclimate.com/github/dontfidget/chartkick-remote)&nbsp;[![Code Climate](https://codeclimate.com/github/dontfidget/chartkick-remote/coverage.png)](https://codeclimate.com/github/dontfidget/chartkick-remote)&nbsp;[![Dependency Status](https://gemnasium.com/dontfidget/chartkick-remote.svg)](https://gemnasium.com/dontfidget/chartkick-remote)

## Usage

This is an add-on to ankane's Chartkick to allow the user to specify chart data in a block and have it automatically sourced remotely to avoid making too many queries in the original page render.  Check out the demo at  http://chartkick-remote-demo.heroku.com.


For more on the fabulous Chartkick library, see http://ankane.github.io/chartkick/.


In your controller, add the following to tell the controller to respond to json requests for chart data:

```ruby
include Chartkick::Remote
chartkick_remote
```

Then in your views, pass your data as a block:

```ruby
<%= line_chart { Task.group_by_day(:completed_at).count } %>
```

To prevent remote requests for a particular chart, set `remote` to `false` in the chart options:

```ruby
<%= line_chart(remote: false) { Task.group_by_day(:completed_at).count } %>
```

This will generate the data set immediately when the page is rendered.


You can also pass arguments to chartkick for all views on your controller as options for the `chartkick_remote` call:

```ruby
<%= chartkick_remote height: "500px" %>
```

Finally, if you need to, you can restrict chartkick_remote to particular views: 

```ruby
<%= chartkick_remote only: :show %>
```

This will prevent the remote requests for other views.

## Installation

First, set up 'chartkick' as described at http://ankane.github.io/chartkick/.

Then, add this line to your application's Gemfile:

```ruby
gem 'chartkick-remote'
```

## How it Works

This gem works by *not* executing "remote" blocks when initially rendering your html page or when making any json request other than the single request that actually needs the data generated in that block.  When responding to a json request, the controller will actually render your template, but only to a string that it will discard, and only so that it can find and execute the one block that is generating the data for this json request.  This means that:
  
  * You can't use results from any code included in any prior "remote" blocks.
  * You should try to do minimal work outside of your block, so that it doesn't get executed unnecessarily for each json request.  Specifically, if you define partial results that you will use in your block, make sure that they are lazily evaluated.

## Handling *Many* Requests at Once

Using this methodology, it's easy to write a page that makes many, many json requests, which may swamp your server and possibly even time out if you have a global `timeout` value set for your ajax requests.  `chartkick-remote` provides a javascript script, available as a rails asset, that can be used to limit the number of simultaneous assets on your page. 
  
You can include it by adding the following to your javascript manifest:
 
 ```
 //= require jquery.ajax.queue-concurrent
 ```
  
If you include this javascript in this gist on your page, you can then specify the maximum number of allowable requests globally for your page as follows:

```javascript
  $.ajaxSetup({queue: true, queueMaxConcurrency: 2});
```

This script is based on @maccman's jquery.ajax.queue.coffee script provides a basic queueing transport layer for ajax requests which I've modified to provide an option to set the maximum number of requests that can be made in parallel.  You can see the modifications with a link to the original at https://gist.github.com/dontfidget/1ad9ab33971b64fe6fef.  

## Standalone Mode (for debugging)

Sometimes it's useful to be able to be able to debug a single chart at a time even though there may be several on the page.  Use the `standalone` option to add a link to each chart that opens the page in standalone mode, where only the single chart is shown.  
 
```ruby
chartkick_remote standalone: true
```

