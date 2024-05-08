defmodule ExSeedify.Services.ListNamesFromFile do
  @moduledoc false

  @doc """
  Returns a list containing examples of user names
  """
  @spec call() :: list(String.t())
  def call do
    [File.cwd!(), "priv", "data", "names.txt"]
    |> Path.join()
    |> File.read!()
    |> String.split("\n")
  end
end
