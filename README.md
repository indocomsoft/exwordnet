# [WIP] ExWordNet

[![Build Status](https://travis-ci.com/indocomsoft/exwordnet.svg?branch=master)](https://travis-ci.com/indocomsoft/exwordnet)
[![Coverage Status](https://coveralls.io/repos/github/indocomsoft/exwordnet/badge.svg?branch=master)](https://coveralls.io/github/indocomsoft/exwordnet?branch=master)

A pure Elixir interface to the WordNet lexical/semantic database.

`ExWordNet` doesn't require you to convert the original WordNet database into a new database format;
instead it can work directly on the database that comes with WordNet.

`ExWordNet` is inspired by the Ruby project ![rwordnet](https://github.com/doches/rwordnet).

## Note

`ExWordNet` comes bundled with the WordNet database which it uses by default.
However, hex package manager has a maximum tarball size of 8MB, hence the database is xz-compressed.
As such, `ExWordNet` requires `xz` and `tar` to be installed. During the first run, the database
will be uncompressed automatically.

## Installation

The package can be installed by adding `exwordnet` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exwordnet, "~> 0.1.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/exwordnet](https://hexdocs.pm/exwordnet).

## Requirement
1. Elixir 1.8
1. `tar` and `xz`
