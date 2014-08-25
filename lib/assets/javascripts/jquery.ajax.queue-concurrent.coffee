# from https://gist.github.com/dontfidget/1ad9ab33971b64fe6fef
# derived from https://gist.github.com/maccman/5790509

$ = jQuery

queues  = {}

queue = (name) ->
  name = 'default' if name is true
  queues[name] or= {entries: [], running: 0}

next = (name, done) ->
  list = queue(name)

  if done
    queue(name).running--

  unless list.entries.length
    return

  [options, deferred] = list.entries[0]

  if list.running >= (options.queueMaxConcurrency || 1)
    return

  list.entries.shift()

  queue(name).running++

  $.ajax(options)
  .always(-> next(name, true))
  .done(-> deferred.resolve(arguments...))
  .fail(-> deferred.reject(arguments...))

push = (name, options) ->
  list = queue(name)
  deferred = $.Deferred()

  while options && list.entries.length >= options.queueMaxDepth
    [overflowOptions, overflowDeferred] = list.entries.shift()
    overflowDeferred.reject null, "queue overflow"

  list.entries.push([options, deferred])

  next(name)
  deferred.promise()

remove = (name, options) ->
  list = queue(name)

  for [value, _], i in list.entries when value is options
    list.entries.splice(i, 1)
    break

$.ajaxTransport '+*', (options) ->
  if options.queue
    queuedOptions = $.extend({}, options)
    queuedOptions.queue = false
    queuedOptions.processData = false

    send: (headers, complete) ->
      push(options.queue, queuedOptions)
      .done (data, textStatus, jqXHR) ->
        complete(jqXHR.status,
          jqXHR.statusText,
          text: jqXHR.responseText,
          jqXHR.getAllResponseHeaders())

      .fail (jqXHR, textStatus, errorThrown) ->
        complete(jqXHR.status,
          jqXHR.statusText,
          text: jqXHR.responseText,
          jqXHR.getAllResponseHeaders())

    abort: ->
      remove(options.queue, queuedOptions)
