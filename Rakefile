# Official gems.
require 'colorize'
require 'rspec/core/rake_task'

# Git repo gems.
require 'bundler/setup'
require 'terramodtest'

namespace :presteps do
  task :ensure do
    puts "Using dep ensure to install required go packages.\n"
    success = system ("dep ensure")
    if not success 
      raise "ERROR: Dep ensure failed!\n".red
    end
  end
end

namespace :static do
  task :style do
    style_tf
  end
  task :lint do
    success = system ("terraform init")
    if not success
      raise "ERROR: terraform init failed!\n".red
    end
    lint_tf
  end
  task :format do
    format_tf
  end
  task :readme_style do
    readme_style_tf
  end
  task :fixture_style do
    fixture_style_tf
  end
end

namespace :integration do
  task :test do
    success = system ("go test -v ./test/ -timeout 45m")
    if not success 
      raise "ERROR: Go test failed!\n".red
    end
  end
end

task :prereqs => [ 'presteps:ensure' ]

task :validate => [ 'static:style', 'static:lint', 'static:readme_style','static:fixture_style']

task :format => [ 'static:format' ]

task :build => [ 'prereqs', 'validate' ]

task :unit => []

task :e2e => [ 'integration:test' ]

task :default => [ 'build' ]

task :full => [ 'build', 'unit', 'e2e' ]
