defmodule CqrsBank.Events.AccountCreated do
    @moduledoc """
    The AccountCreated event
    """
    defstruct [account_id: nil, account_holder: "", pin: nil]
end

defmodule CqrsBank.Events.MoneyDeposited do
    @moduledoc """
    The MoneyDeposited event
    """
    defstruct [account_id: nil, amount: 0]
end