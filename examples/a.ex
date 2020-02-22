defmodule A do
  def start(tag), do: spawn(fn -> loop(tag) end)

  def loop(tag) do
    sleep()
    val = B.x()
    IO.inspect val
    loop(tag)
  end

  def sleep() do
    receive do
      after 3000 -> true
    end
  end
end
