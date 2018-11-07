require "nokogiri"

class CepProxy

  @@cache = {}

  def initialize(cep)
    @zip = Cep.new(cep)
  end

  def fullAddress
    cep = @zip.code
    fetch = @@cache[:cep]

    if (!fetch.nil?)
      p "CEP Encontrado em cache"
      return fetch
    else
      p "Procurando CEP..."
      result = @zip.search(cep)
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

  def search(cep)
    page = `curl 'http://www.buscacep.correios.com.br/sistemas/buscacep/resultadoBuscaCepEndereco.cfm' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Origin: http://www.buscacep.correios.com.br' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: http://www.buscacep.correios.com.br/sistemas/buscacep/buscaCepEndereco.cfm' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8' -H 'Cookie: CFGLOBALS=urltoken%3DCFID%23%3D74633526%26CFTOKEN%23%3De8e9772604170f82%2D621693C5%2DA676%2DFA3A%2DA5676DA34E79515D%26jsessionid%23%3D7001E6295BBEB997E2E2F81A80D465F8%2Ecfusion06%23lastvisit%3D%7Bts%20%272018%2D05%2D17%2019%3A25%3A42%27%7D%23hitcount%3D2%23timecreated%3D%7Bts%20%272018%2D05%2D17%2019%3A25%3A42%27%7D%23cftoken%3De8e9772604170f82%2D621693C5%2DA676%2DFA3A%2DA5676DA34E79515D%23cfid%3D74633526%23; CFID=Z16c97xp1nfat85vel35thx6qc0x7tyryg54wwfrh1nlek21mq-31006826; CFTOKEN=Z16c97xp1nfat85vel35thx6qc0x7tyryg54wwfrh1nlek21mq-16f4607b0194a8a-BF432663-BFC2-6AE9-ACD6CFA002980EFE; opEueMonUID=u_a0b5avab30ejo37281q; JSESSIONID=3BC1E7C0EFE5FD4251110EA093EE40CF.cfusion01; ssvbr0327_buscacep=sac2094_cep; CFGLOBALS=urltoken%3DCFID%23%3D31006826%26CFTOKEN%23%3D16f4607b0194a8a%2DBF432663%2DBFC2%2D6AE9%2DACD6CFA002980EFE%26jsessionid%23%3D3BC1E7C0EFE5FD4251110EA093EE40CF%2Ecfusion01%23lastvisit%3D%7Bts%20%272018%2D11%2D07%2000%3A31%3A47%27%7D%23hitcount%3D9%23timecreated%3D%7Bts%20%272018%2D05%2D17%2019%3A25%3A42%27%7D%23cftoken%3De8e9772604170f82%2D621693C5%2DA676%2DFA3A%2DA5676DA34E79515D%23cfid%3D74633526%23; CFGLOBALS=urltoken%3DCFID%23%3D31006826%26CFTOKEN%23%3D16f4607b0194a8a%2DBF432663%2DBFC2%2D6AE9%2DACD6CFA002980EFE%26jsessionid%23%3D3BC1E7C0EFE5FD4251110EA093EE40CF%2Ecfusion01%23lastvisit%3D%7Bts%20%272018%2D11%2D07%2000%3A31%3A47%27%7D%23hitcount%3D9%23timecreated%3D%7Bts%20%272018%2D05%2D17%2019%3A25%3A42%27%7D%23cftoken%3De8e9772604170f82%2D621693C5%2DA676%2DFA3A%2DA5676DA34E79515D%23cfid%3D74633526%23; ssvbr0327_www2=sac2847' --data 'relaxation=#{cep}&tipoCEP=ALL&semelhante=N' --compressed`

    noko = Nokogiri::HTML(page)

    result = {
      Rua: noko.search("//table[@class='tmptabela']/tr[2]/td[1]").text,
      Bairro: noko.search("//table[@class='tmptabela']/tr[2]/td[2]").text,
      Local: noko.search("//table[@class='tmptabela']/tr[2]/td[3]").text
    }

    return result
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
    p "Remetente: #{@name}, 90, #{address[:"Rua"]},#{address[:"Bairro"]},#{address[:"Local"]}."
    print "\n"
  end

end

f = User.new("Fulano", "52171900")
e = User.new("Fulano", "52171900")

f.print_package
e.print_package
