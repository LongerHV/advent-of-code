import carpenter/table.{type Set, AutoWriteConcurrency, Private}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/string
import rememo/memo
import tempo/time

fn create_table() {
  let table_name = time.now_unique() |> string.inspect

  let assert Ok(cache_table) =
    table.build(table_name)
    |> table.privacy(Private)
    |> table.write_concurrency(AutoWriteConcurrency)
    |> table.read_concurrency(True)
    |> table.decentralized_counters(True)
    |> table.compression(False)
    |> table.set()

  cache_table
}

pub type Message(k, v) {
  Shutdown
  Set(k, v)
  Get(k, Subject(Result(v, Nil)))
}

fn handle_message(
  message: Message(k, v),
  cache: table.Set(k, v),
) -> actor.Next(Message(k, v), table.Set(k, v)) {
  case message {
    Shutdown -> {
      table.drop(cache)
      actor.Stop(process.Normal)
    }
    Set(key, value) -> {
      memo.set(in: cache, for: key, insert: value)
      actor.continue(cache)
    }
    Get(k, client) -> {
      process.send(client, memo.get(from: cache, fetch: k))
      actor.continue(cache)
    }
  }
}

pub fn create(apply fun) {
  let assert Ok(actor) =
    actor.start_spec(actor.Spec(
      fn() {
        let cache = create_table()
        actor.Ready(cache, process.new_selector())
      },
      100,
      handle_message,
    ))
  let result = fun(actor)
  process.send(actor, Shutdown)
  result
}

pub fn set(in actor: Subject(Message(k, v)), for key: k, insert value: v) -> Nil {
  process.send(actor, Set(key, value))
}

pub fn get(from actor: Subject(Message(k, v)), fetch key: k) -> Result(v, Nil) {
  process.call(actor, Get(key, _), 1000)
}

pub fn memoize(with actor, this key: k, apply fun: fn() -> v) -> v {
  case get(from: actor, fetch: key) {
    Ok(value) -> value
    Error(Nil) -> {
      let result = fun()
      set(in: actor, for: key, insert: result)
      result
    }
  }
}
