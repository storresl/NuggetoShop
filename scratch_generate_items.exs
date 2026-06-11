defmodule ItemGenerator do
  @categories [
    "Camping",
    "Deporte",
    "Videojuegos",
    "Juegos de Mesa",
    "Libros",
    "Música",
    "Muebles",
    "Electrodomésticos"
  ]

  def generate(count \\ 40) do
    Enum.map(1..count, fn id ->
      category = Enum.random(@categories)

      %{
        id: id,
        name: "Item #{id} de #{category}",
        price: "$#{Enum.random(5..50)}.000",
        description:
          "Un excelente producto de la categoría #{category}. Poco uso, en muy buen estado.",
        images: [
          "https://picsum.photos/seed/#{id}a/400/400",
          "https://picsum.photos/seed/#{id}b/400/400",
          "https://picsum.photos/seed/#{id}c/400/400"
        ],
        category: category,
        available: Enum.random([true, true, true, false])
      }
    end)
    |> Jason.encode!(pretty: true)
  end
end

File.write!("priv/data/items.json", ItemGenerator.generate())
