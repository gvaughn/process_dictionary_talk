defmodule LonestarPd.Importer do
  require Logger

  def aggregate_import(stream_in) do
    now = NaiveDateTime.utc_now()

    stream_in
    |> CSV.decode!(headers: true)
    |> Stream.map(fn row ->
      login_name = row["Login Name"]

      case user_id_for_login_name(login_name) do
        :unknown ->
          Logger.warn("Cannot import payment for unknown Login Name: #{login_name}")
          nil

        user_id ->
          process_row_csv(row, now, user_id)
      end
    end)
    |> Stream.reject(&is_nil/1)
    |> Stream.chunk_every(3000)
    |> Enum.reduce(0, fn chunk, acc ->
      {count, nil} =
        LonestarPd.Repo.insert_all(LonestarPd.PaymentItem, chunk, on_conflict: :nothing)

      count + acc
    end)
  end

  defp process_row_csv(row, timestamp, user_id) do
    amount = Decimal.new(row["Payment/CM Amount"])

    %{
      status: "Unused",
      payment_date: Ecto.Date.cast!(row["Payment Date"]),
      payment_id: to_string(row["Reference #"]),
      foreign_id: to_string(row["Payment ID"]),
      payment_type: to_string(row["Payment Type"]),
      order_num: to_string(row["Order #"]),
      amount: amount,
      balance: amount,
      inserted_at: timestamp,
      updated_at: timestamp,
      user_id: user_id
    }
  end

  defp user_id_for_login_name(login_name) do
    # pdict cache to do single lookup per user in csv
    case Process.get(login_name) do
      nil ->
        ret_val =
          if user = LonestarPd.potentially_slow_remote_lookup("login_name", login_name) do
            user.id
          else
            :unknown
          end

        Process.put(login_name, ret_val)
        ret_val

      found ->
        found
    end
  end

  # non pdict version
  # defp user_id_for_login_name(login_name) do
  #   if user = LonestarPd.potentially_slow_remote_lookup("lonestarpd", "login_name", login_name) do
  #     user.id
  #   else
  #     :unknown
  #   end
  # end
end
