# DogBook

## Http server
To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Database

setup postgresql server. dev.config assumes /etc/hosts to point dog_book_db to a correct ip

once the server is up, run:
`mix ecto.create`


# Models

## Data

mix phx.gen.live Meta Breeder breeders

mix phx.gen.live Meta Color colors

mix phx.gen.live Meta Champion champions

mix phx.gen.live Data Dog dogs breed_id:references:breeds registry_uid:string name:string gender:enum:male:female  birth_date:date breed_specific:enum:bobtail:docked:measured coat:enum:short:long:broken size:enum:normal:dwarf:rabbit observe:boolean testicle_status:enum:ok:cryptochid  breeder_id:references:breeders color_number:references:colors
**has_many of**
parents:references:dog_parents
champions:references:dog_champions

mix phx.gen.schema Data.DogParents dog_parents dog_id:references:dogs parent_id:references:dogs


## Setup Meta data - breeds

``` bash
iex -S mix
```

In iex repl

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
