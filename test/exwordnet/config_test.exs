defmodule ExWordNet.ConfigTest do
  use ExUnit.Case

  alias ExWordNet.Config

  setup do
    priv = :code.priv_dir(:exwordnet)
    db = Path.join(priv, "WordNet-3.0")
    File.rm_rf!(db)
    {:ok, db: db}
  end

  describe "db/0" do
    test "extracts dataset and returns correct db", %{db: db} do
      refute File.exists?(db)
      assert Config.db() == db
      assert File.exists?(db)
    end
  end
end
