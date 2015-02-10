define ruby(
    $version = undef,
    $heap_min_slots = 4587520,
    $heap_slots_increment = 250000,
    $heap_slots_growth_factor = 1,
    $gc_malloc_limit = 50000000
  ) {
  include rvm

  if $version == undef {
    $version = $title
  }

  if !defined(Rvm_system_ruby[$version]) {
    # Set environment variables that control Ruby GC parameters.
    file { '/etc/environment':
      ensure  => file,
      content => template('ruby/environment.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '644'
    }

    rvm_system_ruby { "${version}":
      ensure      => present,
      default_use => true
    }

    rvm_gem { "${version}@global/bundler":
      require => Rvm_system_ruby[$version]
    }

    rvm_gem { "${version}@global/puppet":
      require => Rvm_system_ruby[$version]
    }

    #file { '/usr/local/rvm':
    #  ensure  => directory,
    #  owner   => 'root',
    #  group   => 'rvm',
    #  mode    => 'g+w',
    #  recurse => true,
    #  require => Class['rvm::system']
    #}
  }
}
