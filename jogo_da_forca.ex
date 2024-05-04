defmodule EstadoJogo do
  defstruct palavra: "", palavra_escondida: "", letras_corretas: [], letras_incorretas: [], tentativas_restantes: 6
end

defmodule JogoDaForca do
  @palavras ["tigre"]

  def start do
    palavra = escolher_palavra_aleatoria()
    estado_jogo = %EstadoJogo{
      palavra: palavra,
      palavra_escondida: String.duplicate("_", String.length(palavra)),
      letras_corretas: [],
      letras_incorretas: [],
      tentativas_restantes: 6
    }
    jogar(estado_jogo)
  end

  defp escolher_palavra_aleatoria do
    Enum.random(@palavras)
  end

  def jogar(estado_jogo) do
    IO.puts("Palavra: #{estado_jogo.palavra_escondida}")
    IO.puts("Letras já tentadas: #{estado_jogo.letras_incorretas ++ estado_jogo.letras_corretas}")
    IO.puts("Tentativas restantes: #{estado_jogo.tentativas_restantes}")

    case estado_jogo.tentativas_restantes do
      0 ->
        IO.puts("Você perdeu! A palavra era #{estado_jogo.palavra}.")
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