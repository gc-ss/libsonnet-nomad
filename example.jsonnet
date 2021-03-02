local nomad = import 'nomad.libsonnet';

nomad.Job {
  name: 'example',
  groups: [
    nomad.Group {
      name: 'cache',
      tasks: [
        nomad.Task {
          name: 'redis',
          driver: 'docker',
          config: {
            image: 'redis:3.2',
          },
          services: [
            {
              name: 'redis-cache',
              port: 'db',
            },
          ],
        },
      ],
    },
  ],
}
