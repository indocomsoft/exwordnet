# ExWordNet

[![Build Status](https://travis-ci.com/indocomsoft/exwordnet.svg?branch=master)](https://travis-ci.com/indocomsoft/exwordnet)
[![Coverage Status](https://coveralls.io/repos/github/indocomsoft/exwordnet/badge.svg?branch=master)](https://coveralls.io/github/indocomsoft/exwordnet?branch=master)

A pure Elixir interface to the WordNet lexical/semantic database.

`ExWordNet` doesn't require you to convert the original WordNet database into a new database format;
instead it can work directly on the database that comes with WordNet.

`ExWordNet` is inspired by the Ruby project ![rwordnet](https://github.com/doches/rwordnet).

## Installation

The package can be installed by adding `exwordnet` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exwordnet, "~> 0.1.0"}
  ]
end
```

`ExWordNet` comes bundled with the WordNet database which it uses by default,
so there's absolutely nothing else to download, install, or configure.

The docs can be found at [https://hexdocs.pm/exwordnet](https://hexdocs.pm/exwordnet).
