defmodule ExWordNet.Synset do
  @enforce_keys ~w(part_of_speech word_counts gloss)a
  defstruct @enforce_keys

  require ExWordNet.Constants

  def new(part_of_speech, offset)
      when ExWordNet.Constants.is_synset_part_of_speech(part_of_speech) and is_integer(offset) do
    path =
      ExWordNet.Config.db()
      |> Path.join("dict")
      |> Path.join("data.#{ExWordNet.Constants.synset_types()[part_of_speech]}")

    with {:ok, file} <- File.open(path),
         {:ok, _} <- :file.position(file, offset),
         {:ok, line} <- :file.read_line(file) do
      result = process_line(line, part_of_speech)

      {:ok, result}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def words(%__MODULE__{word_counts: word_counts}) when is_map(word_counts) do
    Map.keys(word_counts)
  end

  defp process_line(line, part_of_speech)
       when is_binary(line) and ExWordNet.Constants.is_synset_part_of_speech(part_of_speech) do
    [info_line, gloss] = line |> String.trim() |> String.split(" | ", parts: 2)
    [_synset_offset, _lex_filenum, _synset_type, word_count | xs] = String.split(info_line, " ")
    word_count = String.to_integer(word_count)
    {words_list, _} = Enum.split(xs, word_count * 2)

    word_counts =
      words_list
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [word, count], acc ->
        Map.put(acc, word, String.to_integer(count))
      end)

    # TODO: Read pointers

    %__MODULE__{part_of_speech: part_of_speech, word_counts: word_counts, gloss: gloss}
  end
end
