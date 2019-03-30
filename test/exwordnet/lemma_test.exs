defmodule ExWordNet.LemmaTest do
  use ExUnit.Case

  alias ExWordNet.Lemma

  describe "find/2" do
    test "finds a lemma by string" do
      {:ok, lemma} = Lemma.find("fruit", :noun)

      assert lemma == %ExWordNet.Lemma{
               id: 41_088,
               part_of_speech: :noun,
               pointer_symbols: ["@", "~", "+"],
               synset_offsets: [13_134_947, 4_612_722, 7_294_550],
               tagsense_count: 3,
               word: "fruit"
             }
    end

    test "can lookup different things" do
      {:ok, lemma1} = Lemma.find("fruit", :noun)
      {:ok, lemma2} = Lemma.find("banana", :noun)
      assert lemma1.word == "fruit"
      assert lemma2.word == "banana"
    end

    test "fails on unknown part of speech" do
      assert_raise FunctionClauseError, fn ->
        Lemma.find("fruit", :sdjksdfjkdfskjsdfjk)
      end
    end

    test "does not find by regex" do
      assert {:error, :not_found} = Lemma.find(".", :verb)
    end
  end

  describe "find_all/1" do
    test "finds all parts of speech" do
      result = Lemma.find_all("fruit")

      assert result == [
               %ExWordNet.Lemma{
                 id: 41_088,
                 part_of_speech: :noun,
                 pointer_symbols: ["@", "~", "+"],
                 synset_offsets: [13_134_947, 4_612_722, 7_294_550],
                 tagsense_count: 3,
                 word: "fruit"
               },
               %ExWordNet.Lemma{
                 id: 4482,
                 part_of_speech: :verb,
                 pointer_symbols: ["@", ">", "+"],
                 synset_offsets: [1_652_895, 1_652_731],
                 tagsense_count: 0,
                 word: "fruit"
               }
             ]
    end

    test "returns empty list when not found" do
      assert Lemma.find_all("sdjkhdfsjfdsjhkfds") == []
    end
  end

  describe "synsets/1" do
    test "finds them" do
      {:ok, lemma} = Lemma.find("fruit", :noun)
      synsets = Lemma.synsets(lemma)

      assert synsets == [
               %ExWordNet.Synset{
                 gloss: "the ripened reproductive body of a seed plant",
                 part_of_speech: :noun,
                 word_counts: %{"fruit" => 0}
               },
               %ExWordNet.Synset{
                 gloss: "an amount of a product",
                 part_of_speech: :noun,
                 word_counts: %{"fruit" => 0, "yield" => 0}
               },
               %ExWordNet.Synset{
                 gloss:
                   "the consequence of some effort or action; \"he lived long enough to see the fruit of his policies\"",
                 part_of_speech: :noun,
                 word_counts: %{"fruit" => 0}
               }
             ]
    end
  end

  describe "to_string/1" do
    test "works" do
      {:ok, lemma} = Lemma.find("fruit", :noun)
      assert to_string(lemma) == "fruit, n"
    end
  end
end
