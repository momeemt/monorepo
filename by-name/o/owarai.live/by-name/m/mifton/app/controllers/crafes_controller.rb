class CrafesController < ApplicationController

  before_action :inDevTest

  def index
    if login?
      @contests = Contest.all.order(start_datetime: :desc)
      render "crafes/logging-in/index"
    else
      @user = User.new
      render "crafes/logged-out/index"
    end
  end

  def new_contest
    @categories = Set.new
    (Contest.all + DraftContest.all).each do |c|
      @categories.add(c.contest_type)
    end
  end

  def create_contest
    @contest = DraftContest.new(contest_params)
    if @contest.save
      redirect_to "/crafes/draft_contests/#{@contest.id}"
    else
      flash[:error] = "コンテスト名は必ず入力してください。"
      redirect_back(fallback_location: root_path)
    end
  end

  def new_question
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

  def create_question
    @question = DraftQuestion.new(question_params)
    if @question.save
      redirect_to "/crafes/draft_questions/#{@question.id}"
    else
      flash[:error] = "問題名は必ず入力してください。"
      redirect_back(fallback_location: root_path)
    end
  end

  def draft_contest_show
    @contest = DraftContest.find(params[:id])
    @questions = DraftQuestion.where(
      contest_id: @contest.id
    )
  end

  def draft_question_show
    @question = DraftQuestion.find(params[:id])
  end

  def notifications
    @notifications = current_user.notifications.where(from_service: "crafes").page(params[:page]).per(20)
  end

  def about
  end

  def schedule
    @contests = Contest.where("start_datetime > ?", Time.now)
  end

  def finished
    @contests = []

    Contest.all.each do |c|
      if c.start_datetime + c.duration * 60 < Time.now
        @contests << c
      end
    end
  end

  def show_contest
    @contest = Contest.find(params[:id])
    @questions = Question.where(
      contest_id: @contest.id
    ).order(score: :asc)
    @writers = Set.new
    @questions.each do |q|
      @writers.add(q.writer)
    end
    join_data = ContestJoinUser.where(
      user_id: current_user.id,
      contest_id: params[:id]
    )
    @did_join_contest = join_data.present?
    @before_the_contest = @contest.start_datetime > Time.now
    @is_in_session = @contest.start_datetime <= Time.now && @contest.start_datetime + @contest.duration * 60 >= Time.now
    @after_the_contest = @contest.start_datetime + @contest.duration * 60 < Time.now
  end

  def questions
  end

  def show_question
    @question = Question.find(params[:id])
  end

  def join_contest
    join_data = ContestJoinUser.where(
      user_id: current_user.id,
      contest_id: params[:id]
    )
    unless join_data.present?
      join_data = current_user.contest_join_users.build(
        contest_id: params[:id]
      )
      join_data.save
      current_user.contest_records.create(
        contest_id: params[:id]
      )
      flash[:success] = "参加登録しました"
    else
      flash[:fall] = "既に登録されています"
    end
    redirect_to "/crafes/contest/#{params[:id]}"
  end

  def leave_contest
    @join_data = current_user.contest_join_users.find_by(contest_id: params[:id])
    @join_data.destroy
    flash[:leave] = "参加を取り消しました"
    redirect_to "/crafes/contest/#{params[:id]}"
  end

  def standings
    @contest = Contest.find(params[:id])
    @join_users = ContestJoinUser.where(
      contest_id: @contest.id
    )
    @contest_records = ContestRecord.where(
      contest_id: @contest.id
    )

  end

  private

  def set_contest
    @contest = Contest.find(params[:id])
  end

  def contest_params
    params.require(:contest).permit(
      :name,
      :times,
      :start_datetime,
      :duration,
      :rated_range,
      :contest_type
    )
  end

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

  def inDevTest
    @users = User.all
    current_user = current_user || User.find_by(user_id: "mifton")
    @random_users = @users.where.not(id: current_user.id).sample(5)
    @random_tags = Tag.all.sample(5)
  end

end
