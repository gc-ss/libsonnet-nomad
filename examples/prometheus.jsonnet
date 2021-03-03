local nomad = import '../nomad.libsonnet';
local time = import '../time.libsonnet';

nomad.Job {
  name: 'prometheus',

  groups: [
    nomad.Group {
      name: 'prometheus',
      networks: [
        nomad.BridgeNetwork {
          ports: [
            { name: 'ui', to: 9090 },
          ],
        },
      ],
      services: [
        nomad.Service {
          name: 'prometheus',
          port: 'ui',
          tags: ['urlprefix-/'],

          Checks: [
            nomad.HTTPCheck {
              name: 'prometheus ui port alive',
              path: '/-/healthy',
            },
          ],
        },
      ],
      tasks: [
        nomad.DockerTask {
          name: 'prometheus',
          image: 'prom/prometheus:latest',

          volumes: [
            'local/prometheus.yml:/etc/prometheus/prometheus.yml',
          ],
        },
      ],
    },
  ],
}
