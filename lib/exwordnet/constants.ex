defmodule ExWordNet.Constants do
  @moduledoc """
  Contains the constants of ExWordNet as well as macros to be used in guard clauses.
  """

  @parts_of_speech ~w(adj adv noun verb)a
  @type part_of_speech() :: :adj | :adv | :noun | :verb

  @synset_types %{"n" => :noun, "v" => :verb, "a" => :adj, "r" => :adv}
  @synset_parts_of_speech Map.keys(@synset_types)

  @spec parts_of_speech :: [part_of_speech()]
  def parts_of_speech, do: @parts_of_speech

  defmacro is_part_of_speech(part_of_speech) do
    quote do
      unquote(part_of_speech) in unquote(@parts_of_speech)
    end
  end

  @spec synset_types :: %{required(String.t()) => part_of_speech()}
  def synset_types, do: @synset_types

  defmacro is_synset_part_of_speech(part_of_speech) do
    quote do
      unquote(part_of_speech) in unquote(@synset_parts_of_speech)
    end
  end
end
