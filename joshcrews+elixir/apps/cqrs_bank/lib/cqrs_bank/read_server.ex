defmodule CqrsBank.ReadServer do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :read_store)
  end
  
  def init(_) do
    {:ok, %{account_balances: %{}}}
  end

  def handle_call({:check_balance, account_id}, _, state) do
    account = Map.get(state, account_id)
    balance = account.balance
    {:reply, balance, state}
  end

  def handle_call({:pin_check, account_id, submitted_pin}, _, state) do
    account = Map.get(state, account_id)
    pin = account.pin
    {:reply, pin == submitted_pin, state}
  end

  def handle_call(:get_account_list, _, state) do
    reply = Enum.map(state, fn({account_id, values}) -> 
              %{name: values.name, id: account_id}
            end)

    {:reply, reply, state}
  end

  def handle_call(:get_total_deposits, _, state) do
    response = Enum.map(state, fn({_account_id, %{balance: balance}}) -> balance end)
                |> Enum.sum

    {:reply, response, state}
  end

  def handle_call(:list_events, _, state) do
    {:reply, state, state}
  end

  def handle_call({:update_accounts, new_state}, _, _state) do
    {:reply, nil, new_state}
  end

end