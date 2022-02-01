module SiteHelper
  def msg_container
    case params[:action]
      when 'index'
        'Últimas perguntas Cadastrada....'
      when 'questions'
        "Resultando para ao tempo \'#{sanitize params[:term]}'\..."
      when 'subject'
        "Mostrando Questões para o assunto \'#{saniteze params[:subject]}'\..."
      end
  end

end
