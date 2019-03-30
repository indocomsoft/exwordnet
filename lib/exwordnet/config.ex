defmodule ExWordNet.Config do
  @moduledoc """
  Contains the configurable settings of ExWordNet
  """

  @db "priv/WordNet-3.0"

  # TODO: Make the db location configurable
  def db, do: @db
end
