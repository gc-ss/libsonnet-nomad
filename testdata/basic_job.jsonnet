local nomad = import '../nomad.libsonnet';

nomad.Job('some-job', {
  groups: [
    nomad.Group('some-group', {
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
