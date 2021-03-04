local time = import 'time.libsonnet';

{
  local base = self,

  Job(name, config): {
    Job: base._Job { name: name } + config,
  },

  SystemJob(name, config): {
    Job: base.Job(name, { Type: 'system' } + config),
  },

  _Job: {
    local job = self,

    name:: error 'Must override "name"',
    groups:: error 'Must override "groups"',
    datacenters:: ['dc1'],

    ID: job.name,
    Datacenters: job.datacenters,
    TaskGroups: job.groups,
  },

  Port: {
    name:: error 'Must override "name"',

    to:: 0,
    static:: 0,

    Label: self.name,
    To: self.to,
    Value: self.static,
  },

  Network: {
    local network = self,

    ports:: [],

    ReservedPorts: std.filterMap(
      function(o) std.objectHas(o, 'static'),
      function(o) base.Port + o,
      network.ports,
    ),

    DynamicPorts: std.filterMap(
      function(o) !std.objectHas(o, 'static'),
      function(o) base.Port + o,
      network.ports,
    ),
  },
  BridgeNetwork: base.Network {
    Mode: 'bridge',
  },
  Service(name, config):
    assert name != '' : 'Must specify name';

    {
      local service = self,

      tags:: [],
      port:: null,

      Name: name,
      PortLabel: service.port,
      Tags: service.tags,
    } + config,
  Task(name, config):
    assert name != '' : 'Must specify name';

    {
      local task = self,

      driver:: error 'Must override "driver"',
      services:: [],
      templates:: [],

      Name: name,
      Driver: task.driver,
      Config: task.config,
      Services: task.services,
      Templates: task.templates,
    } + config,
  DockerTask(name, config):
    base.Task(name, config {
      image:: error 'Must override "image"',

      driver:: 'docker',
      config+:: {
        image: config.image,
      },
    }),
  Group(name, config):
    assert name != '' : 'Must specify name';
    assert std.length(config.tasks) != 0 : 'must override "tasks"';

    local group = {
      name: name,
      services: [],
      networks: [],
    } + config;

    {
      Name: name,
      Tasks: group.tasks,
      Services: group.services,
      Networks: group.networks,
    },
  Check: {
    local check = self,
    Interval: 10 * time.second,
    Timeout: 2 * time.second,
  },
  HTTPCheck: base.Check {
    local check = self,

    path:: error 'Must override "path"',

    Type: 'http',
    Path: check.path,
  },
  TCPCheck: base.Check {
    local check = self,

    name:: null,
    port:: error 'Must override "port"',

    Type: 'tcp',
    PortLabel: check.port,
    Name: check.name,
  },
  Template: {
    local template = self,

    destination:: error 'Must override "destination"',
    data:: error 'Must override "data"',
    env:: false,

    DestPath: template.destination,
    EmbeddedTmpl: template.data,
    EnvVars: template.env,
  },
}
