defmodule CqrsBank.Command do
  @moduledoc """
  commands available for CqrsBank
  """
  def create_bank_account(account_id, name, pin) do
    GenServer.call(:event_history, {:create_bank_account, {account_id, name, pin}})
    GenServer.call(:event_handler, {:bank_account_created, {account_id, name}})
  end

  def deposit_money_into_bank_account(account_id, amount) do
    if can_deposit_money_into_account?(account_id) do
      GenServer.call(:event_history, {:deposit_money_into_bank_account, {account_id, amount}})
      GenServer.call(:event_handler, {:money_deposited_into_bank_account, {account_id, amount}})
    end
  end

  def withdraw_money_from_bank_account(account_id, amount, pin) do

    if can_withdraw?(account_id, amount, pin) do
      GenServer.call(:event_history, {:withdraw_money_from_bank_account, {account_id, amount}})
      GenServer.call(:event_handler, {:money_withdrawn_from_bank_account, {account_id, amount}})
    end
    
  end

  def can_withdraw?(account_id, amount, pin) do
    enough_money = CqrsBank.Query.check_balance(account_id) >= amount
    pin_match = CqrsBank.Query.pin_check(account_id, pin)

    enough_money && pin_match    
  end

  def can_deposit_money_into_account?(account_id) do
    accounts = CqrsBank.Query.get_account_list()
              |> Enum.filter(fn(%{id: id}) -> id == account_id end)

    case accounts do
      [] ->
        false
      _ ->
        true
    end

  end
  
end
