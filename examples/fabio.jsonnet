local nomad = import '../nomad.libsonnet';

nomad.SystemJob({
  name: 'fabio',
  groups: [
    nomad.Group {
      name: 'fabio',
      networks: [
        nomad.Network {
          ports: [
            { name: 'lb', static: 9999 },
            { name: 'ui', static: 9998 },
          ],
        },
      ],
      tasks: [
        nomad.DockerTask {
          name: 'fabio',
          image: 'fabiolb/fabio',
          config+: {
            network_mode: 'host',
          },
          Resources: {
            Cpu: 100,
            MemoryMB: 64,
          },
        },
      ],
    },
  ],
})
