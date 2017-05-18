defmodule CqrsBank.Account do
    use GenServer
    require Logger
    alias CqrsBank.Account
    alias CqrsBank.Events.AccountCreated
    alias CqrsBank.Events.MoneyDeposited

    @moduledoc """
    The Account aggregate root
    """

    defstruct [account_id: nil, account_holder: "", pin: nil, balance: 0, changes: []]

    def create_bank_account(account_id, account_holder, pin) do
        state = %Account{account_id: account_id}
        registration = via_tuple(account_id)
        GenServer.start_link(__MODULE__, state, name: registration)
        account_id 
        |> via_tuple
        |> GenServer.call({:create_account, account_id, account_holder, pin})
    end

    def debug(account_id) do
        account_id
        |> via_tuple
        |> GenServer.call(:debug)
    end

    def deposit_money_into_bank_account(account_id, amount) do
        account_id
        |> via_tuple
        |> GenServer.call({:deposit, account_id, amount})
    end

    defp via_tuple(account_id) do
        {:via, Registry, {:account_to_pid_registry, account_id}}
    end

    def handle_call({:create_account, account_id, account_holder, pin}, _from, state) do
        evt = %AccountCreated{account_id: account_id, account_holder: account_holder, pin: pin}
        new_state = apply_new_event(evt, state)
        {:reply, :ack, new_state}
    end

    def handle_call({:deposit, account_id, amount}, _from, state) do
        evt = %MoneyDeposited{account_id: account_id, amount: amount}
        new_state = apply_new_event(evt, state)
        {:reply, :ack, new_state}
    end
    
    def handle_call(:debug, _from, state) do
        Logger.info fn -> "State: #{inspect state}" end
        {:reply, :ack, state}
    end
    
    defp apply_new_event(%AccountCreated{} = evt, state) do
        Logger.info fn -> "Publish #{inspect evt}" end
        combined_changes = [evt | state.changes]
        %Account{state | account_holder: evt.account_holder, 
                         pin: evt.pin,
                         balance: 0,
                         changes: combined_changes}
    end
    
    defp apply_new_event(%MoneyDeposited{} = evt, state) do
        Logger.info fn -> "Publish #{inspect evt}" end
        new_amount = state.balance + evt.amount
        combined_changes = [evt | state.changes]
        %Account{state | balance: new_amount,
                         changes: combined_changes}
    end
end