class QuestionsController < ApplicationController
  include ApplicationHelper

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find_by(id: params[:id])
    @answer = Answer.new
  end

  def new
    unless logged_in?
      flash[:error] = "You must be logged in to do that!"
      redirect_to users_path
    end
    @question = Question.new()
  end

  def create
    unless logged_in?
      flash[:error] = "You must be logged in to do that!"
      redirect_to users_path
      return
    end
    user = current_user
    @question = user.questions.new(question_params)
    if @question.save
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages
      render :new
    end
  end

  def edit
    unless logged_in?
      flash[:error] = "You must be logged in to do that!"
      redirect_to users_path
      return
    end
    @question = Question.find_by(id: params[:id])
  end

  def update
    @question = Question.find_by(id: params[:id])

    if @question.update_attributes(question_params)
      redirect_to @question
    else
      flash[:error] = @question.errors.full_messages
      render :edit
    end

  end

  def destroy
    @question = Question.find_by(id: params[:id])
    @question.destroy
    redirect_to questions_path
  end

  def upvote
    @question = Question.find_by(id: params[:id])
    unless @question.voted_by_current_user?(voter: current_user, up: true)
      @question.upvote(session[:user_id])
    end
    redirect_to :back
  end

  def downvote
    @question = Question.find_by(id: params[:id])
    unless @question.voted_by_current_user?(voter: current_user, up: false)
      @question.downvote(session[:user_id])
    end
    redirect_to :back
  end


  private

  def question_params
    params.require(:question).permit(:title, :content)
  end

  def vote_params
    params.require(:vote).permit(:up_or_down)
  end

end
