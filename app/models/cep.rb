require 'net/http'

class CEP
  attr_reader :logradouro, :bairro, :localidade, :uf

  END_POINT = "https://viacep.com.br/ws/"
  FORMAT = "/json/"

  def initialize(cep)
    begin
      cep_encontrado = encontar(cep)
      preencher_dados(cep_encontrado)
    rescue ActiveSupport::JSON.parse_error
      Rails.logger.warn("Attempted to decode invalid JSON: #{cep}")
    end
  end

  def endereco
    "#{@logradouro} / #{@bairro} / #{@localidade} - #{@uf}"
  end

  private

  def encontar(cep)
    ActiveSupport::JSON.decode(
      Net::HTTP.get(
        URI("#{END_POINT}#{cep}#{FORMAT}")
      )
    )
  end

  def preencher_dados(cep_encontrado)
    @logradouro      = cep_encontrado["logradouro"]
    @bairro         = cep_encontrado["bairro"]
    @localidade     = cep_encontrado["localidade"]
    @uf             = cep_encontrado["uf"]
  end
end
