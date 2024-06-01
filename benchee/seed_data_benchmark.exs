# benchee/seed_data_benchmark.exs

# To run this benchmark use command:
# mix run benchee/seed_data_benchmark.exs
Benchee.run(%{
  "mix_task" => fn -> Mix.Task.run("seed_data", []) end
})
