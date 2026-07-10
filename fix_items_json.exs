json_path = "priv/data/items.json"
items = File.read!(json_path) |> Jason.decode!(keys: :atoms)

defmodule FormatHelper do
  def format_price(nil), do: nil
  def format_price(price) when is_binary(price), do: price
  def format_price(price) when is_integer(price) do
    price_str = Integer.to_string(price)
    
    # Add dots for thousands
    formatted = 
      price_str
      |> String.reverse()
      |> String.codepoints()
      |> Enum.chunk_every(3)
      |> Enum.join(".")
      |> String.reverse()
      
    "$" <> formatted
  end
end

fixed_items = Enum.map(items, fn item -> 
  item
  |> Map.update(:status, "available", fn 
    "Available" -> "available"
    other -> other
  end)
  |> Map.update(:price, nil, &FormatHelper.format_price/1)
  |> Map.update(:reference_price, nil, &FormatHelper.format_price/1)
end)

File.write!(json_path, Jason.encode!(fixed_items, pretty: true))
IO.puts("Fixed items.json prices and statuses!")
