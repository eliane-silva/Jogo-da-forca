defmodule JogoDaForca do
  @palavras ["elefante", "banana", "computador", "programação", "python", "elixir", "abacaxi"]
  @max_tentativas 6

  def palavra_aleatoria() do
    Enum.random(@palavras)
  end

  def estado_atual(palavra, letras_corretas \\ []) do
    palavra
    |> String.graphemes()
    |> Enum.map(fn letra ->
      if letra in letras_corretas do
        letra
      else
        "_"
      end
    end)
    |> Enum.join(" ")
  end

  def letra_correta?(palavra, letra) do
    letra in String.codepoints(palavra)
  end

  def jogo_terminado?(palavra, letras_corretas, tentativas) do
    palavra
    |> String.graphemes()
    |> Enum.all?(fn letra -> letra in letras_corretas end)
    or tentativas >= @max_tentativas
  end

  def mostrar_estado_atual(palavra, letras_corretas, tentativas) do
    IO.puts("Palavra: #{estado_atual(palavra, letras_corretas)}")
    IO.puts("Tentativas Restantes: #{@max_tentativas - tentativas}")
  end

  def ler_entrada() do
    IO.gets("Digite uma letra: ") |> String.trim() |> String.downcase()
  end

  def jogar() do
    palavra = palavra_aleatoria()
    letras_corretas = []
    tentativas = 0

    loop(palavra, letras_corretas, tentativas)
  end

  defp loop(palavra, letras_corretas, tentativas) do
    mostrar_estado_atual(palavra, letras_corretas, tentativas)
    letra = ler_entrada()

    case letra_correta?(palavra, letra) do
      true ->
        letras_corretas = [letra | letras_corretas]
      false ->
        tentativas = tentativas + 1
    end

    if jogo_terminado?(palavra, letras_corretas, tentativas) do
      mostrar_resultado(palavra, letras_corretas, tentativas)
    else
      loop(palavra, letras_corretas, tentativas)
    end
  end

  defp mostrar_resultado(palavra, letras_corretas, tentativas) do
    if Enum.all?(palavra, fn letra -> letra in letras_corretas end) do
      IO.puts("Parabéns! Você ganhou!")
    else
      IO.puts("Você perdeu! A palavra era: #{palavra}")
    end
  end
end