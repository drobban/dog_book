defmodule DogBook.Repo do
  use Ecto.Repo,
    otp_app: :dog_book,
    adapter: Ecto.Adapters.Postgres
end
