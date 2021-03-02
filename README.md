# libsonnet-nomad

This repo can be used as a library for generating Nomad jobspecs. It's WIP, so
doesn't offer very much at the moment. Two working examples are given in
`examples/`.

## Why

I wanted to submit jobs to Nomad via the HTTP API, but writing JSON by hand is
no fun.

## Dependencies

* `jsonnet`, via [`go-jsonnet`](https://github.com/google/go-jsonnet) or
  [`jsonnet`](https://github.com/google/jsonnet), to generate JSON from
  `.jsonnet` files

## Resources

See `examples/` for examples.

Learn more about Jsonnet at [jsonnet.org](https://jsonnet.org).
