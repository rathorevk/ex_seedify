defmodule ExSeedifyTest do
  use ExUnit.Case, async: true

  describe "send_email/1" do
    test "fails with invalid attrs" do
      assert ExSeedify.send_email(:invalid) == {:error, :invalid_attrs}
    end

    test "sends the email" do
      result =
        Enum.reduce_while(1..15, nil, fn _index, _acc ->
          case ExSeedify.send_email(%{name: "Legolas"}) do
            {:ok, _name} = result -> {:halt, result}
            {:error, _reason} = result -> {:cont, result}
          end
        end)

      assert {:ok, _} = result
    end
  end

  describe "list_names/0" do
    test "returns a list of names" do
      result = ExSeedify.list_names()

      assert is_list(result)
      assert result != []
    end
  end
end
