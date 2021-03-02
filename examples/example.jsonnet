local nomad = import '../nomad.libsonnet';

nomad.Job {
  name: 'cache',
  groups: [
    nomad.Group {
      name: 'cache',
      networks: [
        nomad.NetworkBridge {
          DynamicPorts: [
            {
              Label: 'db',
              To: 6379,
            },
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
        nomad.TaskDocker {
          name: 'redis',
          image: 'redis:3.2',
        },
      ],
    },
  ],
}
