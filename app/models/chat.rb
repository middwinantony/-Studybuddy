class Chat < ApplicationRecord
  acts_as_chat

  belongs_to :user
  belongs_to :topic
  has_many :messages, dependent: :destroy

  TITLE_PROMPT = <<~PROMPT
    Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
  PROMPT

  def generate_title_from_first_message
    return unless title == "Untitled"

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.content)
    update(title: response.content)
  end
end
