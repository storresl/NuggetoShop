new_data = [
  %{name: "Ring Fit - Switch", category: "Videojuegos", price: 80000, reference_price: 169990, description: "Juego de Nintendo Switch, incluyendo el aro de metal para ejercicios. Con caja.", photo_path: "/images/ring_fit.png", status: "Available"},
  %{name: "Elden Ring - PS4", category: "Videojuegos", price: 40000, reference_price: 54980, description: "Actualizable a versión PS5 mediante descarga digital. En excelente estado.", photo_path: "/images/elden_ring.png", status: "Available"},
  %{name: "Hogwarts Legacy - PS5", category: "Videojuegos", price: 40000, reference_price: 64990, description: "Versión física. En excelente estado. Vuelve a Hogwarts, la mejor recreación a la fecha del castillo.", photo_path: "/images/hogwarts_legacy.png", status: "Available"},
  %{name: "Death Stranding 2 - PS5", category: "Videojuegos", price: 50000, reference_price: 84990, description: "Versión física. En excelente estado. Sumergete en la cabeza del maestro de maestros Hideo Kojima sama.", photo_path: "/images/death_stranding_2.png", status: "Available"},
  %{name: "XCOM 2 - PS4", category: "Videojuegos", price: 15000, reference_price: 27990, description: "Versión física. Excelente juego de estrategia por turnos contra alienigenas.", photo_path: "/images/xcom_2.png", status: "Available"},
  %{name: "Desierto Prohibido", category: "Juegos de Mesa", price: 25000, reference_price: 29990, description: "Caja de metal, incluye todos sus accesorios. En perfecto estado.", photo_path: "/images/desierto_prohibido.png", status: "Available"},
  %{name: "Sky Team", category: "Juegos de Mesa", price: 25000, reference_price: 29990, description: "Para dos jugadores, en perfecto estado. Mejor juego del año 2024 (Spiel des Jahres)", photo_path: "/images/sky_team.png", status: "Available"},
  %{name: "Ticket to Ride Londres", category: "Juegos de Mesa", price: 15000, reference_price: 21490, description: "En perfecto estado, muy bueno! Más rápido que la edición normal.", photo_path: "/images/ticket_to_ride_londres.png", status: "Available"},
  %{name: "Pájaros Cantores", category: "Juegos de Mesa", price: 8000, reference_price: 9990, description: "Juego de cartas inspirado en aves. De 2 a 4 jugadores, 30min por partida.", photo_path: "/images/pajaros_cantores.png", status: "Available"},
  %{name: "Sushi Go", category: "Juegos de Mesa", price: 6000, reference_price: 8990, description: "Caja de metal, incluye todos sus accesorios. En perfecto estado.", photo_path: "/images/sushi_go.png", status: "Available"},
  %{name: "Los Inseparables", category: "Juegos de Mesa", price: 12000, reference_price: 17990, description: "Los inseparables es la versión en castellano del juego publicado por la editorial francesa Sweet Games: Les Poilus (The Grizzled), de gran éxito en Francia y USA. Bien difícil!", photo_path: "/images/los_inseparables.png", status: "Available"},
  %{name: "Carcassone + expansión", category: "Juegos de Mesa", price: 35000, reference_price: 49990, description: "Juego base más expansión posadas y catedrales", photo_path: "/images/carcassone.png", status: "Available"},
  %{name: "7 Wonders Duel", category: "Juegos de Mesa", price: 20000, reference_price: 26990, description: "Edición de 2 jugadores del afamado juego 7 Wonders. En excelente estado.", photo_path: "/images/7_wonders_duel.png", status: "Available"},
  %{name: "Código Secreto", category: "Juegos de Mesa", price: 15000, reference_price: 19990, description: "El juego de mesa Código Secreto (o Codenames) es un entretenido party game de deducción y palabras para 2 a 8 jugadores.", photo_path: "/images/codigo_secreto.png", status: "Available"},
  %{name: "Catan - Juego de Tronos", category: "Juegos de Mesa", price: 40000, reference_price: 59990, description: "Versión especial de CATAN inspirado en Game of Thrones, le da una etapa colaborativa al juego base de CATAN, para no terminar tan peleado :)", photo_path: "/images/catan_juego_de_tronos.png", status: "Available"},
  %{name: "Mysterium", category: "Juegos de Mesa", price: 30000, reference_price: 39990, description: "En Mysterium, un jugador asume el papel de fantasma mientras que todos los demás son mediums. Para resolver el crimen, el fantasma primero debe recordar a todos los sospechos", photo_path: "/images/mysterium.png", status: "Available"}
]

json_path = "priv/data/items.json"
existing_data = File.read!(json_path) |> Jason.decode!(keys: :atoms)

max_id = existing_data |> Enum.map(& &1.id) |> Enum.max(fn -> 0 end)

new_data_with_ids = new_data |> Enum.with_index(max_id + 1) |> Enum.map(fn {item, id} -> Map.put(item, :id, id) end)

combined = existing_data ++ new_data_with_ids

File.write!(json_path, Jason.encode!(combined, pretty: true))
IO.puts("Successfully appended items!")
