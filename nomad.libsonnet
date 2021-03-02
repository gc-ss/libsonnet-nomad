{
  local base = self,

  NetworkBridge: {
    Mode: 'bridge',
  },
  Service: {
    local service = self,

    name:: error 'Must override "name"',
    port:: error 'Must override "port"',

    Name: service.name,
    PortLabel: service.port,
  },
  Task: {
    local task = self,

    name:: error 'Must override "name"',
    driver:: error 'Must override "driver"',
    config:: error 'Must override "config"',
    services:: [],

    Name: task.name,
    Driver: task.driver,
    Config: task.config,
    Services: task.services,
  },
  TaskDocker: base.Task {
    local task = self,

    image:: error 'Must override "image"',

    driver: 'docker',
    config: {
      image: task.image,
    },
  },
  Group: {
    local group = self,

    name:: error 'Must override "name"',
    tasks:: error 'Must override "tasks"',
    services:: [],
    networks:: [],

    Name: group.name,
    Tasks: group.tasks,
    Services: group.services,
    Networks: group.networks,
  },
  Job: {
    local job = self,

    name:: error 'Must override "name"',
    groups:: error 'Must override "groups"',
    datacenters:: ['dc1'],

    Job: {
      ID: job.name,
      Datacenters: job.datacenters,
      TaskGroups: job.groups,
    },
  },
}
