class Message < ApplicationRecord
  acts_as_message

  belongs_to :chat
  validates :message_text, presence: true, if: -> { role == "user" }
  validates :role, presence: true
  validates :chat, presence: true
  validate :user_message_limit, if: -> { role == "user" }

  MAX_USER_MESSAGES = 10

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:base, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end
end
