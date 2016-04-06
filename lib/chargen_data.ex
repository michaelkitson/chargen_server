defmodule ChargenData do
  @moduledoc """
  Generates data for the Chargen protocol.
  """

  @doc """
  Gets the block of data that the chargen protocol sends over and over.

      iex> byte_size(ChargenData.get_data)
      6862
  """
  def get_data do
    Enum.join(Enum.map(0..93, &get_line/1))
  end

  @doc ~S"""
  Gets a line of ChargenData data. `offset` determines which line. Also appends a newline.

      iex> ChargenData.get_line 0
      "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefgh\n"

      iex> ChargenData.get_line 1
      "\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghi\n"

      iex> ChargenData.get_line 90
      "{|}~!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcd\n"

      iex> ChargenData.get_line 94
      "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefgh\n"
  """
  def get_line(offset) do
    to_string(Enum.map(0..71, fn(x) -> rem((x + offset), 94) + 33 end)) <> "\n"
  end
end