class Site::AnswerController < SiteController
  def question
    puts 'Rota do site Answer  >>> question'
    puts "#{params[:answer]}"
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  end
end
