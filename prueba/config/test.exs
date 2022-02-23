import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prueba, PruebaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "S7KECnRR6melUQBGpxlIECBhfqGAHo9YULVV0JrCeIrFVVhovm6LDPts8Imd4Yo/",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
