use Mix.Config

config :http_proxy,
  proxies: [
             %{port: 4000,
               to:   "http://google.com"},
             %{port: 4001,
               to:   "http://yahoo.com"}
            ],
  record: false,
  play: true,
  export_path: "my_example",
  play_path: "test/data"
