defmodule CqrsBank.AccountRepository do
    use GenServer

    def start_link() do
    end

    def get(account_id) do
        case Registry.lookup(:account_to_pid_registry, account_id) do
            [] -> 
                # load from disk
                {:error, :no_such_account}
            [{pid, _}] ->
                pid
        end
    end

end