# CQRS Bank

CQRS is an architectural pattern that separates commands (which mutate state) from queries (which return values). 
With CQRS the “read” data store and the “write” data store can be on different severs, can use different storage 
engines, and can be scaled independently. CQRS is often linked with the Event Sourcing pattern which models state 
as a series of events (past tense verbs) rather than a single “latest” value. What works for an accountant’s ledger 
and for Git can work for our “write” store too. Given a series of events we can deal with concurrency and collisions 
more intelligently than “last guy wins”. We can also define varied service level agreements for commands and queries.

## Materials on CQRS

Greg Young's "CQRS, Task Based UIs, Event Sourcing agh!"
http://codebetter.com/gregyoung/2010/02/16/cqrs-task-based-uis-event-sourcing-agh/

## The challlenge

* We are modeling a simple bank that has checking account customers. 
* We need to define a task-based UI to capture user intent and issue commands. 
* The data for our UIs will come from queries to read-side projections.
* Command handlers will receive a command and call the corresponding function on an aggregate.
* Aggregates are loaded and saved via a repository.
* The aggregate will contain the business logic to determine if a command will be processed or rejected.
* If a command is accepted an event will be emitted and applied (state change) to the aggregate.
* One or more event handlers will respond to an event and update read-side projections.
* The task-based UI will reload to show changes to the projections.

### Commands

* create_bank_account(accountId:int, accountHolder:string) -> ack
* deposit_money_into_bank_account(accountId:int, amount:int) -> ack 
* withdraw_money_from_bank_account(accountId:int, amount:int) -> ack

### Queries

* check_balance(accountId:int) -> int
* get_account_list() -> list<{int, string}> 
* get_total_deposits() -> int

### Events

* bank_account_created{accountId:int, accountHolder:string}
* money_deposited_into_bank_account{accountId:int, amount:int}
* money_withdrawn_from_bank_account{accountId:int, amount:int}
* account_overdrawn{accountId:int, balance:int, amount_requested:int}
