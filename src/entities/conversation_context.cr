require "json"

module Entities
  class ConversationContext
    JSON.mapping(
      chat_id: String,
      last_message_id: Int32
      last_action: ConversationContext::Action
      keyboard_selections: ConversationContext::KeyboardSelections
    )

    enum Action
      None
      Watch
    end

    # basically: { "downcase_action" => "result" }
    class KeyboardSelections
      JSON.mapping(
        watch: String?
      )
    end
  end
end
