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

```bash
**done**
mix phx.gen.live Meta Person persons name:string street:string zip_code:integer city:string phone:string

**done**
mix phx.gen.live Meta Breeder breeders number:integer name:string
**relations**
many_to_many persons:references:persons

**done**
mix phx.gen.live Meta Color colors number:integer color:string

**done**
mix phx.gen.live Meta Champion champions number:integer champ_name:string

mix phx.gen.live Data Record records registry_uid:string country:string dog_id:references:dogs

** done **
mix phx.gen.live Data Dog dogs breed_id:references:breeds name:string gender:enum:male:female birth_date:date breed_specific:enum:bobtail:docked:measured coat:enum:short:long:broken size:enum:normal:dwarf:rabbit observe:boolean testicle_status:enum:ok:cryptochid:unknown  breeder_id:references:breeders color_number:references:colors partial:boolean
**relations**
many_to_many parents:references:dog_parents
many_to_many champions:references:dog_champions
has_many records

**done**
mix phx.gen.schema Meta.BreederPersons breeder_persons breeder_id:references:breeders person_id:references:persons

mix phx.gen.schema Data.DogParents dog_parents dog_id:references:dogs parent_id:references:dogs


mix phx.gen.schema Meta.ChampionDogs champion_dogs champion_id:references:champions dog_id:references:dogs
```

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

    [x] Add Breeds schema
    [x] Add Breeder schema
    [x] Add Champions schema
    [x] Add Color schema
    [x] Add dog schema. (and relations to other dogs.)
    [x] Add person schema
    [x] process fn for breeds.
    [ ] process fn for dog import
    [x] dog import format
    [x] process fn for breeder import
    [x] breeder import format
    [x] process fn for champion import
    [x] process fn for color import
    [ ] Upload/Process fn for breed package (zip-file)
    [ ] Add veterinary data
    [ ] Some proof of concept stats presentation (this will expand...)
