defmodule CqrsBank.AccountRepository do
    @moduledoc """
    The Account repository
    """

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