defmodule CqrsBank.Query do
  @moduledoc """
  commands available for CqrsBank
  """
  def check_balance(account_id) do
    GenServer.call(:read_store, {:check_balance, account_id})
  end

  def pin_check(account_id, submitted_pin) do
    GenServer.call(:read_store, {:pin_check, account_id, submitted_pin})
  end

  def get_account_list do
    GenServer.call(:read_store, :get_account_list)
  end

  def get_total_deposits do
    GenServer.call(:read_store, :get_total_deposits)
  end

  def list_events do
    GenServer.call(:event_history, :all_history)
  end
  
end
