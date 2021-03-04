local nomad = import '../nomad.libsonnet';

nomad.Job('redis', {
  groups: [
    nomad.Group('redis', {
      networks: [
        nomad.Network {
          ports: [
            { name: 'db', to: 6379 },
          ],
        },
      ],
      services: [
        nomad.Service('redis', {
          port: 'db',
        }),
      ],
      tasks: [
        nomad.DockerTask('redis', {
          image: 'redis:3.2',
          config+: {
            ports: ['db'],
          },
        }),
      ],
    }),
  ],
})
