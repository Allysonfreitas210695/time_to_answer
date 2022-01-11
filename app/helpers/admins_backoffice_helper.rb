module AdminsBackofficeHelper
  def translate_attribute(object = nil, atribute = nil)
    (object && atribute) ? object.model.human_attribute_name(atribute) : 'Informe os parâmetros corretamente'
  end
end
