class Chat < ApplicationRecord
  acts_as_chat

  belongs_to :topic, optional: true
  belongs_to :user
  has_many :messages, dependent: :destroy

  MAX_QUESTIONS = 5

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
    self[:score] || 0
    # Example: 1 point per correct message
    messages.where(role: "assistant").count { |m| m.content.include?("Correct") }
  end

  def attempts
    self[:attempts] || 0
    # Count only user messages as attempts
    messages.where(role: "user").count
  end

  def questions_remaining?
    messages.where(role: "assistant").count < MAX_QUESTIONS
  end
end
