defmodule ExWordNet.Lemma do
  @enforce_keys ~w(word part_of_speech synset_offsets id pointer_symbols tagsense_count)a
  defstruct @enforce_keys

  require ExWordNet.Constants

  def find_all(word) when is_binary(word) do
    Enum.flat_map(ExWordNet.Constants.parts_of_speech(), fn part_of_speech ->
      case find(word, part_of_speech) do
        {:ok, lemma} when not is_nil(lemma) -> [lemma]
        _ -> []
      end
    end)
  end

  def find(word, part_of_speech)
      when is_binary(word) and ExWordNet.Constants.is_part_of_speech(part_of_speech) do
    path = ExWordNet.Config.db() |> Path.join("dict") |> Path.join("index.#{part_of_speech}")

    case File.read(path) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.with_index()
        |> Enum.find(nil, fn {line, _} ->
          [index_word | _] = String.split(line, " ", parts: 2)
          word == index_word
        end)
        |> lemma_from_entry()
        |> case do
          result = %__MODULE__{} -> {:ok, result}
          _ -> {:error, nil}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def synsets(%__MODULE__{synset_offsets: synset_offsets, part_of_speech: part_of_speech})
      when is_binary(part_of_speech) and is_list(synset_offsets) do
    Enum.flat_map(synset_offsets, fn synset_offset ->
      case ExWordNet.Synset.new(part_of_speech, synset_offset) do
        {:ok, synset = %ExWordNet.Synset{}} -> [synset]
        _ -> []
      end
    end)
  end

  defp lemma_from_entry({entry, id}) when is_binary(entry) and is_integer(id) do
    [word, part_of_speech, synset_count, pointer_count | xs] = String.split(entry, " ")
    synset_count = String.to_integer(synset_count)
    pointer_count = String.to_integer(pointer_count)
    {pointers, [_, tagsense_count | xs]} = Enum.split(xs, pointer_count)
    {synset_offsets, _} = Enum.split(xs, synset_count)

    %__MODULE__{
      word: word,
      part_of_speech: part_of_speech,
      synset_offsets: Enum.map(synset_offsets, &String.to_integer/1),
      id: id + 1,
      pointer_symbols: pointers,
      tagsense_count: String.to_integer(tagsense_count)
    }
  end

  defp lemma_from_entry(_) do
    nil
  end
end
