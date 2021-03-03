local nomad = import '../nomad.libsonnet';
local time = import '../time.libsonnet';

nomad.Job('traefik', {
  groups: [
    nomad.Group {
      name: 'traefik',
      networks: [
        nomad.Network {
          ports: [
            { name: 'http', static: 8080 },
            { name: 'api', static: 8081 },
          ],
        },
      ],
      services: [
        nomad.Service {
          name: 'traefik',
          Checks: [
            nomad.TCPCheck {
              port: 'http',
              name: 'alive',
            },
          ],
        },
      ],
      tasks: [
        nomad.DockerTask {
          name: 'traefik',
          image: 'traefik:v2.2',
          config+: {
            network_mode: 'host',
            volumes: [
              'local/traefik.toml:/etc/traefik/traefik.toml',
            ],
          },
          templates: [
            nomad.Template {
              destination: 'local/traefik.toml',
              data: |||
                [entryPoints]
                  [entryPoints.http]
                  address = ":8080"
                  [entryPoints.traefik]
                  address = ":8081"

                [api]
                  dashboard = true
                  insecure  = true

                # Enable Consul Catalog configuration backend.
                [providers.consulCatalog]
                  prefix           = "traefik"
                  exposedByDefault = false

                  [providers.consulCatalog.endpoint]
                    address = "127.0.0.1:8500"
                    scheme  = "http"
              |||,
            },
          ],
        },
      ],
    },
  ],
})
