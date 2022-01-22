class AdminsBackoffice::WelcomeController < AdminsBackofficeController
  def index
    @total_questions = AdminStatistic.set_total_questions
    @total_users = AdminStatistic.set_total_users
  end
end
