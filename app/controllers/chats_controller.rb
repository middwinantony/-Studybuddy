class ChatsController < ApplicationController
  def check_answer
    @topic = Topic.find(params[:topic_id])
    question_text = params[:question]
    user_answer = params[:answer]

    chat = RubyLLM.chat
    prompt = prompt = <<~PROMPT
      You are a quiz evaluator.
      Question: #{question_text}
      User answered: #{user_answer}
      Respond in JSON like this:
      {
        "evaluation": "Correct or Incorrect based on user's answer",
        "correct_answer": "Provide the correct answer here"
      }
    PROMPT
    response = chat.ask(prompt)

    result_json = JSON.parse(response.content) rescue { "evaluation" => response.content, "correct_answer" => "" }

    @result = result_json["evaluation"]
    @correct_answer = result_json["correct_answer"]
    @question_text = question_text
    @user_answer = user_answer

    # Render the show_answer view that is inside topics folder
    redirect_to show_answer_topic_path(@topic, question: question_text, user_answer: user_answer, result: @result, correct_answer: @correct_answer)
  end

  def show_answer
    @topic = Topic.find(params[:topic_id])
    @question_text = params[:question]
    @user_answer = params[:answer]
    @result = flash[:notice] # gets the result from previous action
  end
end
