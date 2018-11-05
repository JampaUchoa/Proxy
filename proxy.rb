class CepProxy

  @@cache = {
      "52010220": {
        "Rua": "Jardim Talal",
        "Bairro": "Tal",
        "Cidade": "Recife",
        "Estado": "Pernambuco"
      }
  }

  def initialize(cep)
    @zip = Zip.new(cep)
  end

  def fullAddress

    cep = @zip.code
    fetch = @@cache[:cep]
    if (!fetch.nil?)
      return fetch
    else
      result = @zip.search(:cep)
      @@cache[:cep] = result
      return result
    end
  end

end

class Cep
  attr_accessor :code

  def initialize(zipcode)
    @code = zipcode
  end

  def search(id)
    sleep 0.1 # Simula um GET no sistema dos correios
    return {
      "Rua": "Jardim Talal",
      "Bairro": "Tal",
      "Cidade": "Recife",
      "Estado": "Pernambuco"
    }
  end

end


class User
  attr_accessor :addr

  def initialize(name, cep)
   @name = name
   @addr = CepProxy.new(cep)
  end

  def print_package

    address = @addr.fullAddress
    p "Remetente: #{@name}"
    p "90, #{address[:"Rua"]}, #{address[:"Bairro"]}, #{address[:"Cidade"]}, #{address[:"Estado"]}."

  end
  
end

f = User.new("Fulano", "52020000")
#p f.addr.fullAddress
f.print_package
