local nomad = import '../nomad.libsonnet';
local time = import '../time.libsonnet';

nomad.Job('prometheus', {
  groups: [
    nomad.Group('prometheus', {
      networks: [
        nomad.BridgeNetwork {
          ports: [
            { name: 'ui', to: 9090 },
          ],
        },
      ],
      services: [
        nomad.Service('prometheus', {
          port: 'ui',
          tags: ['urlprefix-/'],

          Checks: [
            nomad.HTTPCheck {
              name: 'prometheus ui port alive',
              path: '/-/healthy',
            },
          ],
        }),
      ],
      tasks: [
        nomad.DockerTask('prometheus', {
          image: 'prom/prometheus:latest',

          volumes: [
            'local/prometheus.yml:/etc/prometheus/prometheus.yml',
          ],
        }),
      ],
    }),
  ],
})
