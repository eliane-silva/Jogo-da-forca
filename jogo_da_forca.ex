defmodule EstadoJogo do
  defstruct categoria: "", palavra: "", palavra_escondida: "", letras_corretas: [], letras_incorretas: [], tentativas_restantes: 6
end

defmodule JogoDaForca do
  @categorias ["animais", "frutas", "times de futebol"]
  @animais ["tigre", "vaca", "elefante", "girafa", "leopardo", "guepardo", "capivara", "formiga", "sapo", "cachorro", "gato", "coelho", "ornitorrinco", "tubarão", "peixe", "macaco"]
  @frutas ["manga", "mangaba", "banana", "laranja", "abacaxi", "abacate", "tangerina", "umbu", "pitomba", "jabuticaba"]
  @times ["flamengo", "fluminense", "vasco", "botafogo", "corinthians", "palmeiras", "santos", "cruzeiro", "internacional", "gremio", "bahia", "treze", "campinense", "vitoria", "fortaleza", "ceara", "bangu", "guarani", "bragantino", "juventude", "chapecoense"]

  def start do
    IO.puts("\nBem vindo ao Jogo da Forca!")

    loop()
  end

  defp loop do
    categoria = escolher_categoria_aleatoria()
    palavra = escolher_palavra_aleatoria(categoria)
    estado_jogo = %EstadoJogo{
      categoria: categoria,
      palavra: palavra,
      palavra_escondida: String.duplicate("_", String.length(palavra)),
      letras_corretas: [],
      letras_incorretas: [],
      tentativas_restantes: 6
    }

    jogar(estado_jogo)

    IO.puts("\nDeseja jogar novamente? (s/n)")
    case String.downcase(IO.gets("")) do
      "s\n" ->
        loop()
      _ ->
        IO.puts("\nObrigado por jogar! Até mais.")
    end
  end

  defp escolher_categoria_aleatoria do
    Enum.random(@categorias)
  end

  defp escolher_palavra_aleatoria(categoria) do
    case categoria do
      "animais" -> Enum.random(@animais)
      "frutas" -> Enum.random(@frutas)
      "times de futebol" -> Enum.random(@times)
    end
  end

  def jogar(estado_jogo) do
    IO.puts("\nCategoria: #{estado_jogo.categoria}")
    IO.puts("Palavra: #{estado_jogo.palavra_escondida}")
    letras_corretas_formatadas = Enum.join(estado_jogo.letras_corretas, " - ")
    letras_incorretas_formatadas = Enum.join(estado_jogo.letras_incorretas, " - ")
    IO.puts("Letras já tentadas: #{String.replace(letras_corretas_formatadas <> " - " <> letras_incorretas_formatadas, "-", "-")}")
    IO.puts("Tentativas restantes: #{estado_jogo.tentativas_restantes}")
    case estado_jogo.tentativas_restantes do
      6 -> IO.puts("______\n|     |\n|\n|\n|\n|\n")
      5 -> IO.puts("______\n|     |\n|     O\n|\n|\n|\n")
      4 -> IO.puts("______\n|     |\n|     O\n|     |\n|\n|\n")
      3 -> IO.puts("______\n|     |\n|     O\n|    /|\n|\n|\n")
      2 -> IO.puts("______\n|     |\n|     O\n|    /|\\ \n|\n|\n")
      1 -> IO.puts("______\n|     |\n|     O\n|    /|\\ \n|    /\n|\n")
      0 -> IO.puts("______\n|     |\n|     O\n|    /|\\ \n|    / \\ \n|\n\n  X  X\n   __\n  /  \\")
    end
    case estado_jogo.tentativas_restantes do
      0 ->
        IO.puts("\nVocê perdeu! A palavra era #{estado_jogo.palavra}.")
      _ ->
        case estado_jogo.palavra_escondida == estado_jogo.palavra do
          true ->
            IO.puts("Parabéns! Você ganhou!")
          false ->
            IO.puts("Digite uma letra:")
            letra = String.trim(IO.gets(""))

            case String.downcase(letra) do
              letra when byte_size(letra) == 1 ->
                processar_tentativa(letra, estado_jogo)
              _ ->
                IO.puts("Por favor, digite apenas uma letra válida.")
                jogar(estado_jogo)
            end
        end
    end
  end

  defp processar_tentativa(letra, estado_jogo) do
    if letra in estado_jogo.letras_corretas or letra in estado_jogo.letras_incorretas do
      IO.puts("Você já tentou essa letra.")
      jogar(estado_jogo)
    else
      case String.contains?(estado_jogo.palavra, letra) do
        true ->
          letras_corretas = [letra | estado_jogo.letras_corretas]
          palavra_escondida = atualizar_palavra_escondida(estado_jogo.palavra, letras_corretas)
          estado_jogo = %{estado_jogo | letras_corretas: letras_corretas, palavra_escondida: palavra_escondida}
          jogar(estado_jogo)
        false ->
          letras_incorretas = [letra | estado_jogo.letras_incorretas]
          tentativas_restantes = estado_jogo.tentativas_restantes - 1
          estado_jogo = %{estado_jogo | letras_incorretas: letras_incorretas, tentativas_restantes: tentativas_restantes}
          jogar(estado_jogo)
      end
    end
  end

  defp atualizar_palavra_escondida(palavra, letras_corretas) do
    palavra
    |> String.graphemes()
    |> Enum.map(fn letra ->
      if letra in letras_corretas do
        letra
      else
        "_"
      end
    end)
    |> Enum.join()
  end
end

JogoDaForca.start()
