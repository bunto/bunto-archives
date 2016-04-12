# Bunto Archives

Automatically generate post archives by dates, tags, and categories.

[![Gem Version](https://badge.fury.io/rb/bunto-archives.png)](http://badge.fury.io/rb/bunto-archives)
[![Build Status](https://travis-ci.org/bunto/bunto-archives.svg?branch=master)](https://travis-ci.org/bunto/bunto-archives)

## Getting started

### Installation

1. Add `gem 'bunto-archives'` to your site's Gemfile
2. Add the following to your site's `_config.yml`:

```yml
gems:
  - bunto-archives
```

### Configuration
Archives can be configured by using the `bunto-archives` key in the Bunto configuration (`_config.yml`) file. See the [Configuration](docs/configuration.md) page for a full list of configuration options.

All archives are rendered with specific layouts using certain metadata available to the archive page. The [Layouts](docs/layouts.md) page will show you how to create a layout for use with Archives.
