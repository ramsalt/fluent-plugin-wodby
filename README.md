# fluent-plugin-wodby

[Fluentd](https://fluentd.org/) filter plugin to enrich logging data with Wodby instance information.

This plugin will query the [Wodby](https://wodby.com) API to retrieve information about the
Wodby instance producing the logs.

## Installation

### RubyGems

```
$ gem install fluent-plugin-wodby
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-wodby"
```

And then execute:

```
$ bundle
```

## Configuration

You can generate configuration template:

```
$ fluent-plugin-config-format filter wodby
```

You can copy and paste generated documents here.

## Copyright

* Copyright(c) 2022-2024: Ramsalt Lab
* License
  * Apache License, Version 2.0
