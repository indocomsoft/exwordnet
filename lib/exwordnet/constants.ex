defmodule ExWordNet.Constants do
  @parts_of_speech ~w(adj adv noun verb)a
  @synset_types %{"n" => :noun, "v" => :verb, "a" => :adj, "r" => :adv}
  @synset_parts_of_speech Map.keys(@synset_types)

  def parts_of_speech, do: @parts_of_speech

  defmacro is_part_of_speech(part_of_speech) do
    quote do
      unquote(part_of_speech) in unquote(@parts_of_speech)
    end
  end

  def synset_types, do: @synset_types

  defmacro is_synset_part_of_speech(part_of_speech) do
    quote do
      unquote(part_of_speech) in unquote(@synset_parts_of_speech)
    end
  end
end
