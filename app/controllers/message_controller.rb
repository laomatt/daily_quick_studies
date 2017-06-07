class MessageController < WebsocketRails::BaseController

  def new_user
    
  end

	def create
		  # The `message` method contains the data received
    # task = Message.new(message_params)
    # task = Message.new message
    return if message[:content].nil?
    message_say = Message.new(content: message[:content], user_id: current_user.id, chatroom_id: message[:room_id])
    message_say.user_id = current_user.id
    if message_say.save
      # *** we are not sending this to all the doms
      # broadcast
      room = message[:room]
      message_say_this = {content: message_say, connection_id: message[:connection]};
      WebsocketRails[room.to_sym].trigger("#{room}_created".to_sym, message_say_this)
      # send_message :create_success, message_say_this
    else
      send_message :create_fail, message_say
    end
	end

	def create_room
		new_room = Chatroom.new message
    new_room.user_id = current_user.id
    if new_room.save
      # *** we are not sending this to all the doms
      # broadcast
      WebsocketRails[:chat_lobby].trigger(:create_room_success, new_room)
      send_message :create_room_success, new_room
    else
      send_message :create_fail, new_room
    end
		
	end
end
