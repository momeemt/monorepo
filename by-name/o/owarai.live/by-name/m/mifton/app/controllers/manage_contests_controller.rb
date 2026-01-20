class ManageContestsController < ApplicationController
  include Common
  before_action :permit_admin

  def index
    @contests = Contest.all.order(start_datetime: :desc)
    @draft_contests = DraftContest.all.order(start_datetime: :asc)
  end

  def show
    @contest = Contest.find(params[:id])
    @questions = Question.where(
      contest_id: @contest.id
    )
    @categories = Set.new
    (Contest.all + DraftContest.all).each do |c|
      @categories.add(c.contest_type)
    end
  end

  def draft_show
    @contest = DraftContest.find(params[:id])
    @questions = DraftQuestion.where(
      contest_id: @contest.id
    )
    @categories = Set.new
    (Contest.all + DraftContest.all).each do |c|
      @categories.add(c.contest_type)
    end
  end

  def draft_update
    @contest = DraftContest.find(params[:id])
    @contest.update!(contest_params)

    if params[:back]
      redirect_to manage_contests_url , notice: "下書きコンテスト「#{@contest.name}」を更新しました。"
    else
      redirect_to "/manage_contests/draft/#{@contest.id}" , notice: "下書きコンテスト「#{@contest.name}」を更新しました。"
    end

  end

  def destroy
    @contest = Contest.find_by(name: params[:contest][:name])
    @draft_contest = DraftContest.new(contest_params)
    @questions = Question.where(
      contest_id: @contest.id
    )

    if @draft_contest.save!
      @contest.destroy
      @questions.each do |q|
        DraftQuestion.create(
          title: q.title,
          writer: q.writer,
          score: q.score,
          content: q.content,
          constraints: q.constraints,
          input_example: q.input_example,
          output_example: q.output_example,
          answer: q.answer,
          contest_id: @draft_contest.id
        )
        q.destroy
      end
      redirect_to manage_contests_url , notice: "コンテスト「#{@draft_contest.name}」を非公開にしました。"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def draft_destroy
    @draft_contest = DraftContest.find(params[:id])
    name = @draft_contest.name
    @questions = Question.where(
      contest_id: @draft_contest.id
    )
    @questions.each do |q|
      q.update!(
        contest_id: nil
      )
    end
    @draft_contest.destroy
    redirect_to manage_contests_url , notice: "下書きコンテスト「#{name}」を削除しました。"
  end

  def new
    @contest = Contest.new
  end

  def create
    @draft_contest = DraftContest.find_by(name: params[:contest][:name])
    @contest = Contest.new(contest_params)
    @draft_questions = DraftQuestion.where(
      contest_id: @draft_contest.id
    )

    if @contest.save!
      @draft_contest.destroy
      @draft_questions.each do |q|
        Question.create(
          title: q.title,
          writer: q.writer,
          score: q.score,
          content: q.content,
          constraints: q.constraints,
          input_example: q.input_example,
          output_example: q.output_example,
          answer: q.answer,
          contest_id: @contest.id
        )
        q.destroy
      end
      redirect_to manage_contests_url , notice: "コンテスト「#{@contest.name}」を公開しました。"
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @contest = Contest.find_by(id:params[:id])
    @contest.update!(contest_params)
    redirect_to manage_contests_url , notice: "投稿「#{@contest.name}」を更新しました。"
  end

  def edit
    @contest = Contest.find_by(id:params[:id])
  end

  private

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

end
