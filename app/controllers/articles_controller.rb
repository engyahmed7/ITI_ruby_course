class ArticlesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def index
    @articles = Article.accessible_by(current_ability)
  end


  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other, notice: 'Article was successfully deleted.'
  end

  def report
    @article = Article.find(params[:id])
    @article.report
    if @article.reports_count >= 3
      @article.update(status: 'archived')
    end
    redirect_to root_path, status: :see_other, notice: 'Article reported successfully.'
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :image)
  end
end
