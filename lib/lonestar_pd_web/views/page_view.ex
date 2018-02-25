defmodule LonestarPdWeb.PageView do
  use LonestarPdWeb, :view

  def pdict_info() do
    {:dictionary, kwd} = Process.info(self(), :dictionary)
    content_tag(:table, border: 1)  do
      [
        pd_row({Key, Value}, :th),
        Enum.map(kwd, &pd_row/1)
      ]
    end
  end

  defp pd_row({key, val}, tag \\ :td) do
    content_tag(:tr) do
      [
        content_tag(tag, inspect(key), style: "padding: 5px;"),
        content_tag(tag, inspect(val), style: "padding: 5px;")
      ]
    end
  end
end
