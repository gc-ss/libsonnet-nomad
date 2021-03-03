local nomad = import '../nomad.libsonnet';

nomad.Job {
  name: 'redis',
  groups: [
    nomad.Group {
      name: 'redis',
      networks: [
        nomad.BridgeNetwork {
          ports: [
            { name: 'db', to: 6379 },
          ],
        },
      ],
      services: [
        nomad.Service {
          name: 'redis',
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
