This project is build with Elixir/Phoenix (`oms_api`) and React (`oms_ui`).

`oms_api` is bootstraped with [mix phx.new](https://hexdocs.pm/phoenix/up_and_running.html) and `oms_ui` is bootstraped with [Create React App](https://github.com/facebook/create-react-app).

Please refer to the apropriate documentation for all available commands.

### Quickstart

`oms_api`

```
cd oms_api
mix deps.get
mix ecto.create
(cd assets && npm install)

mix phx.server
```

`oms_ui`

```
cd oms_ui
npm install

npm start
```

### Tests

`oms_api`

```
mix test
```

`oms_ui`

```
npm test
```
