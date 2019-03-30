defmodule ExWordNet.SynsetTest do
  use ExUnit.Case, async: true

  alias ExWordNet.Synset

  describe "new/2" do
    test "works" do
      {:ok, synset} = Synset.new(:noun, 4_612_722)

      assert synset == %Synset{
               gloss: "an amount of a product",
               part_of_speech: :noun,
               word_counts: %{"fruit" => 0, "yield" => 0}
             }
    end
  end

  describe "words/1" do
    test "works" do
      {:ok, synset} = Synset.new(:noun, 4_612_722)
      assert Synset.words(synset) == ["fruit", "yield"]
    end
  end

  describe "to_string/1" do
    test "works" do
      {:ok, synset} = Synset.new(:noun, 4_612_722)
      assert to_string(synset) == "(n) fruit, yield (an amount of a product)"
    end
  end
end
