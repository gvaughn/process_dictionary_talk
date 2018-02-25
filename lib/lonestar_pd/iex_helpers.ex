defmodule LonestarPd.IexHelpers do
  def pppd(pid \\ self()) do
    {:dictionary, kwd} = Process.info(pid, :dictionary)
    IO.puts("#{IO.ANSI.green()}for pid: #{inspect(pid)}")

    Enum.each(kwd, fn {key, val} ->
      IO.puts("#{IO.ANSI.blue()}#{inspect(key)}")
      IO.puts("#{IO.ANSI.magenta()}  #{inspect(val)}")
    end)

    :ok
  end

  def rand() do
    IO.puts("#{IO.ANSI.underline()}:rand.uniform()#{IO.ANSI.no_underline()}")
    :rand.uniform()
    pppd()
  end

  def logger() do
    IO.puts(
      "#{IO.ANSI.underline()}Logger.metadata(where: :lonestarelixir)#{IO.ANSI.no_underline()}"
    )

    Logger.metadata(where: :lonestarelixir)
    pppd()
  end

  def agent() do
    IO.puts("#{IO.ANSI.underline()}Agent.start(fn -> pppd() end)#{IO.ANSI.no_underline()}")
    Agent.start(fn -> pppd() end)
    :ok
  end

  def repo() do
    IO.puts(
      "#{IO.ANSI.underline()}LonestarPd.Repo.transaction(fn -> pppd() end)#{
        IO.ANSI.no_underline()
      }"
    )

    LonestarPd.Repo.transaction(fn -> pppd() end)
    :ok
  end

  def parent() do
    {:dictionary, kwd} = Process.info(self(), :dictionary)

    Keyword.get(kwd, :"$ancestors")
    |> List.first()
    |> pppd
  end
end
