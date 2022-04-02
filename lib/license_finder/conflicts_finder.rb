# frozen_string_literal: true

module LicenseFinder
  class ConflictsFinder
    attr_reader :config, :aggregate_paths, :project_licenses, :main_license
    CONFLICTS_MAP = {
      'MIT': [
        'zlib/libpng license',
        'AGPL', 'Common Development and Distribution License 1.0',
        'Mozilla Public License 1.1'
      ],
      'Simplified BSD': [],
      'New BSD': [],
      'Apache 2.0': [],
      'zlib/libpng license': [],
      'AFL-3.0': [],
      'Mozilla Public License 1.1': [],
      'Mozilla Public License 2.0': [],
      'MPL-1.1+': [],
      'Common Development and Distribution License 1.0': [],
      'GNU Lesser General Public License version 2.1': [],
      'LGPL': [],
      'OSL-3.0': [],
      'GPLv2': [],
      'GPLv3': [],
      'AGPL-3.0': [],
      'AGPL-1.0+': []
    }

    def initialize(config, aggregate_paths)
      @config = config
      @aggregate_paths = aggregate_paths
    end

    def find_conflicts
      finder = LicenseAggregator.new(config, aggregate_paths)
      dependencies = finder.unapproved

      project_licenses = dependencies.first.licenses
      @main_license = project_licenses.first.name

      dependencies.map do |dependency|
        require 'pry-nav';binding.pry
        dependency_license = dependency.license_names_from_spec.first
  
        puts "#{dependency.name} | #{dependency_license}" if has_conflict(dependency.licenses.first.name)
      end
    end

    private

    def has_conflict(dependency_license)
      CONFLICTS_MAP[main_license].include?(dependency_license)
    end
  end
end
