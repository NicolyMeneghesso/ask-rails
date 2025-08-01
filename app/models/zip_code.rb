# Importa a biblioteca padrão do Ruby para fazer requisições HTTP
require "net/http"
# Importa a biblioteca padrão para lidar com JSON
require "json"

class ZipCode
  # Cria métodos apenas de leitura para os atributos
  attr_reader :address_street, :address_city, :address_state

  # Método chamado quando fazemos Cep.new
  def initialize(zipcode)
    zipCode_found = find(zipcode)  # Busca os dados do CEP na API externa
    fill_data(zipCode_found) # Preenche os atributos com os dados recebidos
  end

  private

  # Método responsável por fazer a requisição à API do ViaCEP
  def find(zipcode)
    return {} if zipcode.blank? # Se o CEP for vazio ou nulo, retorna um hash vazio

    # Monta a URL da requisição para a API do ViaCEP
    url = URI("http://viacep.com.br/ws/#{zipcode}/json/")
    # Envia uma requisição GET para a URL e guarda a resposta
    response = Net::HTTP.get_response(url)

    # Se a resposta não for 200 OK, retorna um hash vazio
    return {} unless response.is_a?(Net::HTTPSuccess)

    # Tenta converter o corpo da resposta JSON em um hash Ruby
    JSON.parse(response.body)

    # Caso a resposta não esteja em formato JSON válido, retorna um hash vazio
  rescue JSON::ParserError
    {}
  end

  # Método que extrai os dados do JSON retornado e preenche os atributos
  def fill_data(zipCode_found)
    return if zipCode_found["erro"]  # Se a resposta indicar erro (CEP inexistente), interrompe

    # Atribui os valores dos campos retornados para os atributos da instância
    @address_street = zipCode_found["logradouro"]
    @address_city   = zipCode_found["localidade"]
    @address_state  = zipCode_found["uf"]
  end
end
