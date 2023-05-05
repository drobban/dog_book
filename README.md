# DogBook

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Setup Meta data - breeds

``` bash
iex -S mix
```

in iex repl

```elixir
DogBook.Meta.BreedImport.process_breed()
```

To inspect import
visit [`localhost:4000/admin/breeds`](http://localhost:4000/admin/breeds) from your browser


# TODO

List will get appended during the process as features and missing parts presents itself.

    [x] Add module to read breed files.
    [ ] Add dog schema. (and relations to other dogs.)
    [ ] Add schema for competition results. (and schema for what kind/types of results they are)
    [ ] Add veterinary data
    [ ] Some proof of concept stats presentation (this will expand...)
