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
        description: """
        Este es un excelente producto de la categoría #{category}. Ha tenido poco uso y se encuentra en muy buen estado de conservación.

        Perfecto para quienes buscan calidad y durabilidad sin pagar el precio de un artículo nuevo. Lo vendo únicamente por motivo de mudanza, ¡aprovecha esta oportunidad!

        Se entrega limpio y probado. Para más detalles, no dudes en contactarme por WhatsApp.
        """,
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
