defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  use Agent

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user) do
    uuid = UUID.uuid4()

    Agent.update(__MODULE__, fn state -> update_state(state, user) end)

    {:ok, uuid}
  end

  def get(cpf), do: Agent.get(__MODULE__, fn state -> get_user(state, cpf) end)

  defp get_user(state, cpf) do
    state
    |> Map.get(cpf)
    |> handle_get()
  end

  defp handle_get(nil), do: {:error, "User not found"}
  defp handle_get(user), do: {:ok, user}

  defp update_state(state, %User{cpf: cpf} = user), do: Map.put(state, cpf, user)
end
