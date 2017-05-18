defmodule CqrsBankTest do
  use ExUnit.Case

  test "run the whole thing" do

    CqrsBank.Command.create_bank_account(1, "Josh", "1")
    CqrsBank.Command.deposit_money_into_bank_account(1, 10)
    CqrsBank.Command.deposit_money_into_bank_account(1, 10)
    CqrsBank.Command.deposit_money_into_bank_account(1, 10)
    CqrsBank.Command.deposit_money_into_bank_account(1, 10)
    CqrsBank.Command.deposit_money_into_bank_account(1, 10)
    CqrsBank.Command.withdraw_money_from_bank_account(1, 5, "1")

    #
    # nothing happens, wrong pin
    #
    CqrsBank.Command.withdraw_money_from_bank_account(1, 5, "2")

    #
    # nothing happens, not enough money
    #
    CqrsBank.Command.withdraw_money_from_bank_account(1, 500, "1")

    #
    # nothing happens, no account
    #
    CqrsBank.Command.deposit_money_into_bank_account(2, 10)

    CqrsBank.Command.create_bank_account(2, "Luke", "1")
    CqrsBank.Command.deposit_money_into_bank_account(2, 10)

    assert CqrsBank.Query.check_balance(1) == 45
    assert CqrsBank.Query.check_balance(2) == 10

    assert CqrsBank.Query.get_account_list == [%{name: "Josh", id: 1}, %{name: "Luke", id: 2}]

    assert CqrsBank.Query.get_total_deposits() == 55

    assert CqrsBank.Query.list_events() == [
                                {:created_bank_account, 1, %{name: "Josh", pin: "1"}}, 
                                {:deposited_money_into_bank_account, 1, %{amount: 10}}, 
                                {:deposited_money_into_bank_account, 1, %{amount: 10}}, 
                                {:deposited_money_into_bank_account, 1, %{amount: 10}}, 
                                {:deposited_money_into_bank_account, 1, %{amount: 10}}, 
                                {:deposited_money_into_bank_account, 1, %{amount: 10}}, 
                                {:withdrew_money_from_bank_account, 1, %{amount: 5}}, 
                                {:created_bank_account, 2, %{name: "Luke", pin: "1"}}, 
                                {:deposited_money_into_bank_account, 2, %{amount: 10}}
                              ]
    
  end
end
