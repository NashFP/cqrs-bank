defmodule CqrsBank.Events.AccountCreated do
    defstruct [account_id: nil, account_holder: "", pin: nil]
end

defmodule CqrsBank.Events.MoneyDeposited do
    defstruct [account_id: nil, amount: 0]
end