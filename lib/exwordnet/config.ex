defmodule ExWordNet.Config do
  @moduledoc """
  Contains the configurable settings of ExWordNet
  """

  @db_name "WordNet-3.0"

  # TODO: Make the db location configurable
  @doc """
  Returns the the db location.

  Also extracts the compressed database.
  """
  def db do
    priv = :exwordnet |> :code.priv_dir() |> to_string()

    db = Path.join(priv, @db_name)

    if not File.exists?(db) do
      {_, 0} = System.cmd("tar", ["xf", db <> ".tar.xz", "-C", priv])
    end

    db
  end
end
