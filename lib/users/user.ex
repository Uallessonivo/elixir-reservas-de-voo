defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(_name, _email, cpf) when is_integer(cpf), do: {:error, "Cpf must be a String"}

  def build(name, email, cpf) do
    {:ok,
     %__MODULE__{
       name: name,
       email: email,
       cpf: cpf,
       id: UUID.uuid4()
     }}
  end
end
