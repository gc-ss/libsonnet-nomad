# libsonnet-nomad

This repo can be used as a library for generating Nomad jobspecs. It's WIP, so
doesn't offer very much at the moment. Working examples are
given in [`examples`](examples/).

## Why

I wanted to submit jobs to Nomad via the HTTP API, but writing JSON by hand is
no fun.

## Dependencies

* `jsonnet`, via [`go-jsonnet`](https://github.com/google/go-jsonnet) or
  [`jsonnet`](https://github.com/google/jsonnet), to generate JSON from
  `.jsonnet` files

## Resources

See [`examples`](examples/) for examples.

Learn more about Jsonnet at [jsonnet.org](https://jsonnet.org).

## Quickstart

If you don't already have Nomad, get a working cluster running in virtualbox
via [vagrant-nomad](https://github.com/krishicks/vagrant-nomad).

#### bash
```
export NOMAD_ADDR=http://localhost:4646
curl --data @<(jsonnet examples/redis.jsonnet) $NOMAD_ADDR/v1/jobs
```

#### fish
```
set -x NOMAD_ADDR http://localhost:4646
curl --data @(jsonnet examples/redis.jsonnet | psub) $NOMAD_ADDR/v1/jobs
```
