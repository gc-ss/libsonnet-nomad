local nomad = import '../nomad.libsonnet';

function(password='root', database='default')
  nomad.Job('mysql', {
    groups: [
      nomad.Group('mysql', {
        networks: [
          nomad.Network {
            ports: [
              { name: 'mysql', static: 3306 },
            ],
          },
        ],
        services: [
          nomad.Service('mysql', {
            port: 'mysql',
          }),
        ],
        tasks: [
          nomad.DockerTask('mysql', {
            image: 'mysql:8.0',
            config+: {
              entrypoint: [
                '/entrypoint.sh',
                '--default-authentication-plugin=mysql_native_password',
              ],
              ports: ['mysql'],
            },
            Env: {
              MYSQL_ROOT_PASSWORD: password,
              MYSQL_DATABASE: database,
            },
            Resources: {
              MemoryMB: 1024,
            },
          }),
        ],
      }),
    ],
  })
