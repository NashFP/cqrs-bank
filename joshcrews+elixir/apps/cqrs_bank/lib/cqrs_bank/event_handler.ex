defmodule CqrsBank.EventHandler do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :event_handler)
  end
  
  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:bank_account_created, {_account_id, _account_holder}}, _, _state) do
    new_state = calculated_state_from_history()
    GenServer.call(:read_store, {:update_accounts, new_state})
    {:reply, 0, new_state}
  end

  def handle_call({:money_deposited_into_bank_account, {_account_id, _amount}}, _, _state) do
    new_state = calculated_state_from_history()
    GenServer.call(:read_store, {:update_accounts, new_state})
    {:reply, 0, new_state}
  end

  def handle_call({:money_withdrawn_from_bank_account, {_account_id, _amount}}, _, _state) do
    new_state = calculated_state_from_history()
    GenServer.call(:read_store, {:update_accounts, new_state})
    {:reply, 0, new_state}
  end

  #
  # unimplemented
  #
  def handle_call({:invalid_pin, {account_id, amount_requested}}, _, state) do
    {:reply, 0, state}
  end


  #
  # unimplemented
  #
  def handle_call({:account_overdrawn, {account_id, balance, amount_requested}}, _, state) do
    {:reply, 0, state}
  end

  def calculated_state_from_history do
    all_events = GenServer.call(:event_history, :all_history)
    balances = all_events
                |> Enum.filter(fn({event, _, _}) -> event in [:deposited_money_into_bank_account, :withdrew_money_from_bank_account] end)
                |> Enum.map(fn({event, account_id, %{amount: amount}}) -> 
                  new_amount = case event do
                                :deposited_money_into_bank_account ->
                                  amount
                                _ ->
                                  amount * -1
                                end
                  {event, account_id, %{amount: new_amount}}
                end)
                |> Enum.group_by(fn({_event, account_id, _}) -> 
                  account_id
                end)
                |> Enum.map(fn({account_id, events}) -> 
                  sum = Enum.map(events, fn({_, _, %{amount: amount}}) -> amount end)
                        |> Enum.sum
                  {account_id, sum}
                end)
                |> Enum.into(%{})

    all_events
    |> Enum.filter(fn({event, _, _}) -> event == :created_bank_account end)
    |> Enum.map(fn({_event, account_id, %{name: name, pin: pin}}) -> 
      {account_id, %{name: name, pin: pin}}
    end)
    |> Enum.map(fn({account_id, values}) -> 
      balance = Map.get(balances, account_id)
      values= Map.put(values, :balance, balance)
      {account_id, values}
    end)
    |> Enum.into(%{})
  end

end