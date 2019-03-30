defmodule ExWordNet.Synset do
  @moduledoc """
  Provides abstraction over a synset (or group of synonymous words) in WordNet.

  Synsets are related to each other by various (and numerous!) relationships, including
  Hypernym (x is a hypernym of y <=> x is a parent of y) and Hyponym (x is a child of y)

  Struct members:
  - `:part_of_speech`: A shorthand representation of the part of speech this synset represents.
  - `:word_counts`: The list of words (and their frequencies within the WordNet graph) for this
  `Synset`.
  - `:gloss`: A string representation of this synset's gloss. "Gloss" is a human-readable
  description of this concept, often with example usage.
  """

  @enforce_keys ~w(part_of_speech word_counts gloss)a
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          part_of_speech: String.t(),
          word_counts: %{required(String.t()) => integer()},
          gloss: String.t()
        }

  require ExWordNet.Constants

  @doc """
  Creates an `ExWordNet.Synset` struct by reading from the data file specified by `part_of_speech`,
  at `offset` bytes into the file.

  This is how the WordNet database is organized. You shouldn't be calling this function directly;
  instead, use `ExWordNet.Lemma.synsets/1`
  """
  @spec new(String.t(), integer()) :: {:ok, __MODULE__.t()} | {:error, any()}
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

  @doc """
  Gets a list of words included in this synset.
  """
  @spec words(__MODULE__.t()) :: [String.t()]
  def words(%__MODULE__{word_counts: word_counts}) when is_map(word_counts) do
    Map.keys(word_counts)
  end

  defp process_line(line, part_of_speech)
       when is_binary(line) and ExWordNet.Constants.is_synset_part_of_speech(part_of_speech) do
    IO.inspect(line)
    [info_line, gloss] = line |> String.trim() |> String.split(" | ", parts: 2)
    [_synset_offset, _lex_filenum, _synset_type, word_count | xs] = String.split(info_line, " ")
    {word_count, _} = Integer.parse(word_count, 16)
    {words_list, _} = Enum.split(xs, word_count * 2)

    word_counts =
      words_list
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [word, count], acc ->
        {count, _} = Integer.parse(count, 16)
        Map.put(acc, word, count)
      end)

    # TODO: Read pointers

    %__MODULE__{part_of_speech: part_of_speech, word_counts: word_counts, gloss: gloss}
  end
end
