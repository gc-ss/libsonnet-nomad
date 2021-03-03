local nomad = import '../nomad.libsonnet';

nomad.Job('some-job', {
  groups: [
    nomad.Group('some-group', {
      services: [
        nomad.Service('some-service', {
          port: 9001,
        }),
      ],
      tasks: [
        nomad.DockerTask('some-task', {
          image: 'some-image',
          config: {
            network_mode: 'host',
          },
        }),
      ],
    }),
  ],
})
