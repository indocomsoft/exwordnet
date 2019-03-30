defmodule ExWordNet.Constants.PartsOfSpeech do
  @moduledoc """
  Contains the constants of ExWordNet as well as macros to be used in guard clauses, specifically
  those regarding parts of speech.
  """

  @short_to_atom %{"n" => :noun, "v" => :verb, "a" => :adj, "r" => :adv}
  @atom_to_short @short_to_atom |> Enum.map(fn {k, v} -> {v, k} end) |> Map.new()

  @short_parts_of_speech Map.keys(@short_to_atom)
  @atom_parts_of_speech Map.keys(@atom_to_short)
  @type atom_part_of_speech() :: :adj | :adv | :noun | :verb

  @spec atom_parts_of_speech :: [atom_part_of_speech()]
  def atom_parts_of_speech, do: @atom_parts_of_speech

  defmacro is_atom_part_of_speech(part_of_speech) do
    quote do
      unquote(part_of_speech) in unquote(@atom_parts_of_speech)
    end
  end

  @spec short_parts_of_speech :: %{required(String.t()) => atom_part_of_speech()}
  def short_parts_of_speech, do: @short_parts_of_speech

  defmacro is_short_part_of_speech(part_of_speech) do
    quote do
      unquote(part_of_speech) in unquote(@short_parts_of_speech)
    end
  end

  @spec short_to_atom_part_of_speech(String.t()) :: atom_part_of_speech()
  def short_to_atom_part_of_speech(part_of_speech)
      when is_short_part_of_speech(part_of_speech) do
    @short_to_atom[part_of_speech]
  end

  @spec atom_to_short_part_of_speech(atom_part_of_speech()) :: String.t()
  def atom_to_short_part_of_speech(part_of_speech)
      when is_atom_part_of_speech(part_of_speech) do
    @atom_to_short[part_of_speech]
  end
end
