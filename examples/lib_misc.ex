defmodule LibMisc do
  def my_for(max, max, f), do: [f.(max)]
  def my_for(i, max, f), do: [f.(i) | my_for(i+1, max, f)]

  def qsort([]), do: []
  def qsort([pivot | t]) do
    qsort(for x <- t, x < pivot, do: x)
    ++ [pivot] ++
    qsort(for x <- t, x >= pivot, do: x)
  end

  def pythag(n) do
    for a <- Enum.to_list(1..n),
      b <- Enum.to_list(1..n),
      c <- Enum.to_list(1..n),
      a + b + c <= n,
      a * a + b * b === c * c, do: {a, b, c}
  end

  def perms([]), do: [[]]
  def perms(l) do
    for h <- l,
      t <- perms(l -- [h]), do: [h | t]
  end

  def odds_and_evens1(l) do
    odds = for x <- l, rem(x, 2) === 1, do: x
    evens = for x <- l, rem(x, 2) === 0, do: x
    {odds, evens}
  end

  def odds_and_evens2(l), do: odds_and_evens2_acc(l, [], [])

  defp odds_and_evens2_acc([h | t], odds, evens) do
    case rem(h, 2) do
      1 -> odds_and_evens2_acc(t, [h | odds], evens)
      0 -> odds_and_evens2_acc(t, odds, [h | evens])
    end
  end
  defp odds_and_evens2_acc([], odds, evens) do
    {Enum.reverse(odds), Enum.reverse(evens)}
  end

  def sleep(t) do
    receive do
    after t ->
        true
    end
  end

  def flush_buffer() do
    receive do
      _any ->
        flush_buffer()
    after 0 ->
      true
    end
  end

  def priority_receive() do
    receive do
      {:alarm, x} ->
        {:alarm, x}
      after 0 ->
        receive do
          any ->
            any
        end
    end
  end

  def on_exit(pid, fun) do
    spawn(fn ->
      ref = Process.monitor(pid)
      receive do
        {:DOWN, ^ref, :process, _object, reason} ->
          fun.(reason)
      end
    end)
  end

  def dump(term, file) do
    out = file <> ".tmp"
    IO.puts("** dumping to #{out}")
    File.write!(out, term)
    IO.inspect(term)
  end
end

