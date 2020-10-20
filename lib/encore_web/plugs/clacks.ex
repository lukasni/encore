defmodule Clacks do
  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.put_resp_header(conn, "x-clacks-overhead", "GNU Terry Pratchett")
  end
end
