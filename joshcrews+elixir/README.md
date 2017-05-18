# CQRS Bank 

## Getting started...

We began by creating an umbrella to keep out UI bits out of out logic bits
```
$ mix new nashelixir+elixir --app cqrs_bank_umbrella --umbrella
$ cd nashelixir+elixir
```

Now in the apps directory we created apps for the logic and our web UI
```
$ cd nashelixir+elixir/apps
$ mix new cqrs_bank --sup
$ mix phoenix.new cqrs_bank_web --no-ecto --no-brunch
```

