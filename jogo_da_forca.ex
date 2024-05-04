defmodule EstadoJogo do
  defstruct palavra: "", letras_corretas: [], letras_incorretas: [], tentativas_restantes: 6
end

defmodule JogoDaForca do
  @palavras ["tigre"]

  def start do
    palavra = escolher_palavra_aleatoria()
    estado_jogo = %EstadoJogo{palavra: palavra, letras_corretas: [], letras_incorretas: [], tentativas_restantes: 6}
    jogar(estado_jogo)
  end

  defp escolher_palavra_aleatoria do
    Enum.random(@palavras)
  end

  def jogar(estado_jogo) do
    IO.puts("Palavra: #{mascara_palavra(estado_jogo)}")
    IO.puts("Letras já tentadas: #{estado_jogo.letras_incorretas ++ estado_jogo.letras_corretas}")
    IO.puts("Tentativas restantes: #{estado_jogo.tentativas_restantes}")

    case estado_jogo.tentativas_restantes do
      0 ->
        IO.puts("Você perdeu! A palavra era #{estado_jogo.palavra}.")
      _ ->
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

  defp mascara_palavra(%EstadoJogo{palavra: palavra, letras_corretas: letras_corretas}) do
    for char <- String.graphemes(palavra), do: if char in letras_corretas, do: char, else: "_"
  end

  defp processar_tentativa(letra, estado_jogo) do
    if letra in estado_jogo.letras_corretas or letra in estado_jogo.letras_incorretas do
      IO.puts("Você já tentou essa letra.")
      jogar(estado_jogo)
    else
      case letra in String.graphemes(estado_jogo.palavra) do
        true ->
          letras_corretas = [letra | estado_jogo.letras_corretas]
          estado_jogo = %{estado_jogo | letras_corretas: letras_corretas}
          jogar(atualizar_palavra_escondida(estado_jogo))
        false ->
          letras_incorretas = [letra | estado_jogo.letras_incorretas]
          tentativas_restantes = estado_jogo.tentativas_restantes - 1
          estado_jogo = %{estado_jogo | letras_incorretas: letras_incorretas, tentativas_restantes: tentativas_restantes}
          jogar(estado_jogo)
      end
    end
  end

  defp atualizar_palavra_escondida(estado_jogo) do
    palavra = estado_jogo.palavra
    letras_corretas = estado_jogo.letras_corretas

    palavra_escondida =
      for char <- String.graphemes(palavra), do: if char in letras_corretas, do: char, else: "_"

    %{estado_jogo | palavra: Enum.join(palavra_escondida)}
  end
end

JogoDaForca.start()
