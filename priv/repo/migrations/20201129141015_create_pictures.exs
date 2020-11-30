defmodule Gallery.Repo.Migrations.CreatePictures do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :url, :string, null: false, size: 2000
      timestamps()
    end
  end
end
