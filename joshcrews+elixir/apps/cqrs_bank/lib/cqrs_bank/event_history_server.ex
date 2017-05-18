defmodule CqrsBank.EventHistoryServer do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :event_history)
  end
  
  def init(_) do
    {:ok, []}
  end

  def handle_call({:create_bank_account, {account_id, name, pin}}, _, state) do
    event = {:created_bank_account, account_id, %{name: name, pin: pin}}
    {:reply, :ok, state ++ [event]}
  end

  def handle_call({:deposit_money_into_bank_account, {account_id, amount}}, _, state) do
    event = {:deposited_money_into_bank_account, account_id, %{amount: amount}}
    {:reply, :ok, state ++ [event]}
  end

  def handle_call({:withdraw_money_from_bank_account, {account_id, amount}}, _, state) do
    event = {:withdrew_money_from_bank_account, account_id, %{amount: amount}}
    {:reply, :ok, state ++ [event]}
  end

  def handle_call(:all_history, _, state) do
    {:reply, state, state}
  end

end