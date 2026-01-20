App.bector = App.cable.subscriptions.create "BectorChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # 新規ポストを表示

  micropost: ->
    @perform "micropost"
