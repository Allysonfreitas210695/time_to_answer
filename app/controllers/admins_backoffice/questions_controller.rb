class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :get_subject, only: [:new, :edit]

  def index
    @questions = Question.includes(:subject)
                         .order(:id)
                         .page(params[:page])
  end

  def new
    @question = Question.new
  end

  def edit; end

  def update
    if @question.update(params_subject)
      redirect_to admins_backoffice_questions_path, notice: 'Questão Atualizado com sucesso'
    else
      render :edit
    end
  end

  def create
    @question = Question.new(params_subject)
    if @question.save
      redirect_to admins_backoffice_questions_path, notice: 'Questão Cadastrado com sucesso'
    else
      render :new
    end
  end

  def destroy
    if @question.destroy
      redirect_to admins_backoffice_questions_path, notice: 'Questão Excluido com sucesso'
    else
      render :index
    end
  end

  private

  def params_subject
    params.require(:question).permit(:description, :subject_id,  answers_attributes: [:id, :description, :correct, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def get_subject
    @subjects = Subject.all
  end
end
