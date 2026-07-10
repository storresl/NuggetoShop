json_path = "priv/data/items.json"
existing_data = File.read!(json_path) |> Jason.decode!(keys: :atoms)

updates = %{
  "Lavadora" => "/images/lavadora.jpg",
  "Termoventilador" => "/images/termoventilador.png",
  "Ninja Air Fryer" => "/images/ninja_air_fryer.png",
  "Tocadisco Sony" => "/images/tocadisco_sony.jpg",
  "Parlantes" => "/images/parlantes.jpg",
  "Impresora" => "/images/impresora.png",
  "Máquina de coser" => "/images/maquina_coser.png",
  "Trotadora" => "/images/trotadora.png",
  "Procesadora alimento" => "/images/procesadora_alimentos.png",
  "Licuadora" => "/images/licuadora.png",
  "Sandwichera" => "/images/sandwichera.png",
  "Microondas" => "/images/microondas.png",
  "Aspiradora tapiz" => "/images/aspiradora_tapiz.png",
  "Raqueta Tenis" => "/images/raqueta_tenis.jpg",
  "Paleta Padel" => "/images/paleta_padel.jpg",
  "Depiladora Láser" => "/images/depiladora_laser.jpg"
}

updated_data = existing_data |> Enum.map(fn item -> 
  if Map.has_key?(updates, item.name) do
    Map.put(item, :photo_path, updates[item.name])
  else
    item
  end
end)

max_id = updated_data |> Enum.map(& &1.id) |> Enum.max(fn -> 0 end)

new_item = %{
  id: max_id + 1,
  name: "Pesa Digital Xiaomi",
  category: "Electrodomésticos",
  price: 10000,
  reference_price: 19990,
  description: "Conectividad bluethooth al celular mediante app \\\"Zepp\\\", modelo Mi Smart Scale 2",
  photo_path: "/images/pesa_digital_xiaomi.jpg",
  status: "Available"
}

combined_data = updated_data ++ [new_item]

File.write!(json_path, Jason.encode!(combined_data, pretty: true))
IO.puts("Successfully updated photos and added new item!")
