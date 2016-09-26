defmodule BusCar.Repo.Config do
  defmacro __using__(opts) do
    quote do

      opts = unquote(opts)
      if !opts do
        raise "Invalid BusCar.Repo.Config options passed when __using__"
      end

      @otp_app opts |> Keyword.get(:otp_app)
      @config Application.get_env(:bus_car, @otp_app)

      if !@otp_app do
        raise "BusCar.Repo.Config misconfigured - :otp_app is required"
      end
      if !@config do
        raise "BusCar.Repo.Config misconfigured - could not find config for otp_app #{inspect @otp_app}"
      end

      def opt_app do
        @otp_app
      end

      def config do
        @config
      end
    end
  end
end
