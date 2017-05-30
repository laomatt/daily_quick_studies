class MessageController < WebsocketRails::BaseController

	def create
		  # The `message` method contains the data received
    # task = Message.new(message_params)
    # task = Message.new message
    message_say = Message.new message
    message_say.user_id = current_user.id
    if message_say.save
      # *** we are not sending this to all the doms
      # broadcast
      room = message[:room]
      WebsocketRails[room.to_sym].trigger(:create_success, message_say)
      send_message :create_success, message_say
    else
      send_message :create_fail, message_say
    end
	end

	def create_room
		new_room = Chatroom.new message
    if new_room.save
      # *** we are not sending this to all the doms
      # broadcast
      # room = message[:room]
      WebsocketRails[:chat_lobby].trigger(:create_room_success, new_room)
      send_message :create_room_success, new_room
    else
      send_message :create_fail, new_room
    end
		
	end
end
