# Capistrano::Thin

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-thin', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-thin

## Usage

add in your deploy.rb or production.rb

    require 'capistrano-thin'

configure

    set(:thin_tag, 'thin_yourwebsite') # for ps aux
    set(:thin_user, 'deployment')
    set(:thin_group, 'deployment')
    set(:thin_socket, "#{shared_path}/sockets/yourwebsite.sock") # the name of the socket
    set(:thin_threaded , 'true')
    set(:thin_no_epoll, 'true')
    set(:thin_pid, 'tmp/pids/thin.pid')
    set(:thin_log, 'log/staging.log')
    set(:thin_max_conns, 1024)
    set(:thin_max_persistent_conns, 512)
    set(:thin_servers, 2)



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
