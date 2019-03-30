defmodule ExWordNet.Lemma do
  @moduledoc """
  Provides abstraction over a single word in the WordNet lexicon,
  which can be used to look up a set of synsets.

  Struct members:
  - `:word`: The word this lemma represents.
  - `:part_of_speech`: The part of speech (noun, verb, adjective) of this lemma.
  - `:synset_offsets`: The offset, in bytes, at which the synsets contained in this lemma are
  stored in WordNet's internal database.
  - `:id`: A unique integer id that references this lemma. Used internally within WordNet's database.
  - `:pointer_symbols`: An array of valid pointer symbols for this lemma.
  - `:tagsense_count`: The number of times the sense is tagged in various semantic concordance
  texts. A tagsense_count of 0 indicates that the sense has not been semantically tagged.<Paste>
  """

  @enforce_keys ~w(word part_of_speech synset_offsets id pointer_symbols tagsense_count)a
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          word: String.t(),
          part_of_speech: String.t(),
          synset_offsets: [integer()],
          id: integer(),
          pointer_symbols: [String.t()],
          tagsense_count: integer()
        }

  require ExWordNet.Constants

  @doc """
  Finds all lemmas for this word across all known parts of speech.
  """
  @spec find_all(String.t()) :: [__MODULE__.t()]
  def find_all(word) when is_binary(word) do
    Enum.flat_map(ExWordNet.Constants.parts_of_speech(), fn part_of_speech ->
      case find(word, part_of_speech) do
        {:ok, lemma} when not is_nil(lemma) -> [lemma]
        _ -> []
      end
    end)
  end

  @doc """
  Find a lemma for a given word and part of speech.
  """
  @spec find(String.t(), ExWordNet.Constants.part_of_speech()) ::
          {:ok, __MODULE__.t()} | {:error, any()}
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

  @doc """
  Returns a list of synsets for this lemma.

  Each synset represents a different sense, or meaning, of the word.
  """
  @spec synsets(__MODULE__.t()) :: [ExWordNet.Synset.t()]
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
