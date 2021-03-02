local time = import 'time.libsonnet';

{
  local base = self,

  port(label, to, static): {
    Label: label,
    [if to != '' then 'To']: to,
    [if static != '' then 'Static']: static,
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
      function(o) base.port(o.name, o.to, ''),
      network.ports,
    ),
  },

  BridgeNetwork: base.Network {
    Mode: 'bridge',
  },
  Service: {
    local service = self,

    name:: error 'Must override "name"',
    port:: error 'Must override "port"',
    tags:: [],

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

    Name: task.name,
    Driver: task.driver,
    Config: task.config,
    Services: task.services,
  },
  DockerTask: base.Task {
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
  HTTPCheck: {
    local check = self,

    path:: error 'Must override "path"',

    Type: 'http',
    Path: check.path,
    Interval: 10 * time.second,
    Timeout: 2 * time.second,
  },
}
