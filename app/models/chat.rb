class Chat < ApplicationRecord
  acts_as_chat

  belongs_to :topic, optional: true
  belongs_to :user
  has_many :messages, dependent: :destroy

  MAX_QUESTIONS = 10

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

  def score
    # Count feedback messages that start with "Correct!" (not "Incorrect")
    messages.where(role: "assistant", message_type: "feedback").count { |m| m.content.strip.start_with?("Correct!") }
  end

  def attempts
    # Count only user answer messages (not system prompts)
    messages.where(role: "user", message_type: "answer").count
  end

  def questions_remaining?
    # Only count question messages, not feedback messages
    messages.where(role: "assistant", message_type: "question").count < MAX_QUESTIONS
  end
end
