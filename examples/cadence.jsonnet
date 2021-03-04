local nomad = import '../nomad.libsonnet';

nomad.Job('cadence', {
  groups: [
    nomad.Group('cassandra', {
      networks: [
        nomad.Network {
          ports: [
            { name: 'cassandra', static: 9042, to: 9042 },
          ],
        },
      ],
      services: [
        nomad.Service('cassandra', {
          port: 'cassandra',
        }),
      ],
      tasks: [
        nomad.DockerTask('cassandra', {
          image: 'cassandra:3.11',
          config+: {
            ports: [
              'cassandra',
            ],
          },
          Resources: {
            MemoryMB: 2048,
          },
        }),
      ],
    }),
    nomad.Group('statsd', {
      networks: [
        nomad.Network {
          ports: [
            { name: 'grafana', to: 80 },
            { name: 'carbon', to: 2003 },
            { name: 'statsd', to: 8125 },
            { name: 'statsd-admin', to: 8126 },
          ],
        },
      ],
      services: [
        nomad.Service('statsd', {
          port: 'statsd',
        }),
      ],
      tasks: [
        nomad.DockerTask('statsd', {
          image: 'graphiteapp/graphite-statsd',
          config+: {
            ports: [
              'grafana',
              'carbon',
              'statsd',
              'statsd-admin',
            ],
          },
        }),
      ],
    }),
    nomad.Group('cadence', {
      networks: [
        nomad.Network {
          ports: [
            // cadence
            { name: 'frontend', static: 7933, to: 7933 },
            { name: 'history', static: 7934, to: 7934 },
            { name: 'matching', static: 7935, to: 7935 },
            { name: 'worker', static: 7939, to: 7939 },

            // cadence-web
            { name: 'http', static: 8088, to: 8088 },
          ],
        },
      ],
      services: [
        nomad.Service('cadence', {
          port: 'frontend',
        }),
      ],
      tasks: [
        nomad.DockerTask('cadence', {
          image: 'ubercadence/server:master-auto-setup',
          config+: {
            ports: [
              'frontend',
              'history',
              'matching',
              'worker',
            ],
          },
          Env: {
            MYSQL_USER: 'root',
            MYSQL_PWD: 'root',
          },
          templates: [
            nomad.Template {
              destination: 'template/env',
              env: true,
              data: |||
                {{ range service "cassandra" }}
                CASSANDRA_SEEDS="{{ .Address }}"
                {{ end }}
                {{ range service "statsd" }}
                STATSD_ENDPOINT="{{.Address}}:{{ .Port }}"
                {{ end }}
                DYNAMIC_CONFIG_FILE_PATH=config/dynamicconfig/development.yaml
              |||,
            },
          ],
        }),
        nomad.DockerTask('web', {
          image: 'ubercadence/web:latest',
          config+: {
            ports: [
              'http',
            ],
          },
          templates: [
            nomad.Template {
              destination: 'template/env',
              env: true,
              data: |||
                {{ range service "cadence" }}
                CADENCE_TCHANNEL_PEERS="{{ .Address }}:{{ .Port }}"
                {{ end }}
              |||,
            },
          ],
        }),
      ],
    }),
  ],
})
