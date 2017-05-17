defmodule CqrsBank.Account do
    use GenServer

    def create_bank_account(account_id, account_holder, pin) do
        registration = via_tuple(account_id)
        GenServer.start_link(__MODULE__, [account_id], name: registration)

        via_tuple(account_id)
        |> GenServer.call({:create_account, account_id, account_holder, pin} )
    end

    def deposit_money_into_bank_account(account_id, amount) do
        via_tuple(account_id)
        |> GenServer.call({:deposit, account_id, amount})
    end


    defp via_tuple(account_id) do
        {:via, Registry, {:account_to_pid_registry, account_id}}
    end

    def handle_call({:create_account, account_id, account_holder, pin}, _from, state) do
        %{account_id: account_id, account_holder: account_holder, pin: pin}
        {:reply, :ack, state}
    end

end