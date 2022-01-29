# myproducts.pdf.prawn
Prawn::Font::AFM.hide_m17n_warning = true

prawn_document do |pdf|
  pdf.text 'listando Assuntos'
  pdf.move_down 20
  pdf.table @subjects.collect{|s| [s.id, s.description]}
end
