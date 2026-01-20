class ManageQuestionsController < ApplicationController
  include Common
  before_action :permit_admin

  def index
    @questions = Question.all
    @draft_questions = DraftQuestion.all
  end

  def show
    @question = Question.find(params[:id])
    contests = Contest.all
    @contests_list = [["未選択", nil]]

    contests.each do |c|
      if c.times.present?
        @contests_list << ["#{c.name} ##{c.times}", c.id]
      else
        @contests_list << [c.name, c.id]
      end
    end
  end

  def draft_show
    @question = DraftQuestion.find(params[:id])
    contests = DraftContest.all
    @contests_list = [["未選択", nil]]

    contests.each do |c|
      if c.times.present?
        @contests_list << ["#{c.name} ##{c.times}", c.id]
      else
        @contests_list << [c.name, c.id]
      end
    end
  end

  def draft_update
    @question = DraftQuestion.find(params[:id])
    @question.update!(question_params)

    if params[:back]
      redirect_to manage_questions_url , notice: "下書きコンテスト「#{@question.title}」を更新しました。"
    else
      redirect_to "/manage_questions/draft/#{@question.id}" , notice: "下書きコンテスト「#{@question.title}」を更新しました。"
    end
  end

  def draft_destroy
    @question = DraftQuestion.find(params[:id])
    title = @question.title
    @question.destroy
    redirect_to manage_questions_url , notice: "下書きコンテスト「#{title}」を削除しました。"
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to "/manage_questions"
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update!(question_params)

    if params[:back]
      redirect_to manage_questions_url , notice: "下書きコンテスト「#{@question.title}」を更新しました。"
    else
      redirect_to "/manage_questions/draft/#{@question.id}" , notice: "下書きコンテスト「#{@question.title}」を更新しました。"
    end
  end

  private

  def question_params
   params.require(:question).permit(
     :title,
     :writer,
     :score,
     :content,
     :constraints,
     :input_example,
     :output_example,
     :answer,
     :contest_id
   )
  end

end
