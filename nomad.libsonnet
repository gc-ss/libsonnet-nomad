local time = import 'time.libsonnet';

{
  local base = self,

  Job(name, config): {
    Job: std.prune(base._Job { name: name } + config),
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

  port(label, to, value): {
    Label: label,
    [if to != '' then 'To']: to,
    [if value != '' then 'Value']: value,
  },

  Network: {
    local network = self,

    ports:: [],

    ReservedPorts: std.filterMap(
      function(o) std.objectHas(o, 'static'),
      function(o) base.port(o.name, '', o.static),
      network.ports,
    ),

    DynamicPorts: std.filterMap(
      function(o) !std.objectHas(o, 'static'),
      function(o) base.port(
        o.name,
        if std.objectHas(o, 'to') then o.to else '',
        '',
      ),
      network.ports,
    ),
  },
  BridgeNetwork: base.Network {
    Mode: 'bridge',
  },
  Service: {
    local service = self,

    name:: error 'Must override "name"',
    tags:: [],
    port:: null,

    Name: service.name,
    PortLabel: service.port,
    Tags: service.tags,
  },
  Task: {
    local task = self,

    name:: error 'Must override "name"',
    driver:: error 'Must override "driver"',
    config:: error 'Must override "config"',
    services:: [],
    templates:: [],

    Name: task.name,
    Driver: task.driver,
    Config: task.config,
    Services: task.services,
    Templates: task.templates,
  },
  DockerTask: base.Task {
    local task = self,

    image:: error 'Must override "image"',

    driver: 'docker',
    config: {
      image: task.image,
    },
  },
  Group(name, config):
    assert name != '' : 'must specify name';
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

    DestPath: template.destination,
    EmbeddedTmpl: template.data,
  },
}
