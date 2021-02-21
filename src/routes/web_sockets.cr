
ws "/" do |socket|
  sockets = env.get("sockets")
  sockets << socket

  log("Web socket id #{socket.hash} created.")
  socket.on_close do |_|
    log("Web socket id #{socket.hash} closed.")
    sockets.delete(socket)
  end

  socket.on_message do |message|
    log("Message received from web socket id #{socket.hash}, forwarding it on.")
    sockets.each {|s| s.send(message) if s != socket}
  end
end
