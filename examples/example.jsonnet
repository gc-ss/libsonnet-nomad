local nomad = import '../nomad.libsonnet';

nomad.Job {
  name: 'cache',
  groups: [
    nomad.Group {
      name: 'cache',
      networks: [
        nomad.BridgeNetwork {
          ports: [
            { name: 'db', to: 6379 },
          ],
        },
      ],
      services: [
        nomad.Service {
          name: 'redis-cache',
          port: 'db',
        },
      ],
      tasks: [
        nomad.DockerTask {
          name: 'redis',
          image: 'redis:3.2',
        },
      ],
    },
  ],
}
