local nomad = import 'nomad.libsonnet';

nomad.Job {
  name: 'example',
  groups: [
    nomad.Group {
      name: 'cache',
      services: [
        nomad.Service {
          name: 'redis-cache',
          port: 'db',
        },
      ],
      Networks: [
        nomad.NetworkBridge {
          DynamicPorts: [
            {
              Label: 'db',
              To: 6379,
            },
          ],
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
