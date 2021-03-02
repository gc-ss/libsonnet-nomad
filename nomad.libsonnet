{
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
  Group: {
    local group = self,

    name:: error 'Must override "name"',
    tasks:: error 'Must override "tasks"',

    Name: group.name,
    Tasks: group.tasks,
    EphemeralDisk: {
      SizeMB: 300,
    },
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
