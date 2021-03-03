local nomad = import '../nomad.libsonnet';

nomad.Job('some-job', {
  groups: [
    nomad.Group('some-group', {
      tasks: [
        nomad.DockerTask {
          name: 'some-task',
          image: 'some-image',
        },
      ],
    }),
  ],
})
