require 'erb'

module CapistranoThin
  class CapistranoIntegration

    unless methods.map(&:to_sym).include?(:_cset)
      def _cset(name, *args, &block)
        set(name, *args, &block) unless exists?(name)
      end
    end

    def self.load_into(capistrano_config)
      capistrano_config.load do
        def skel_for(file)
          File.join(File.expand_path('../../skel', __FILE__), file)
        end

        def render_skel(file, target)
          run "mkdir -p #{File.dirname(target)}"
          top.upload StringIO.new(ERB.new(File.read(skel_for(file))).result(binding)), target
        end

        def retrieve_env
          fetch(:rails_env, fetch(:rack_env, fetch(:stage, :production)))
        end

        _cset(:thin_tag) { 'thin' }
        _cset(:thin_user) { 'deploy_user' }
        _cset(:thin_group) { 'deploy_group' }
        _cset(:thin_socket) { 'tmp/sockets/thin.sock' }
        _cset(:thin_threaded ) { 'true' }
        _cset(:thin_no_epoll) { 'true' }

        _cset(:thin_command) { 'bundle exec thin' }
        _cset(:thin_config_file) { "#{current_path}/thin.yml" }
        _cset(:thin_config) { "-C #{thin_config_file}" }

        _cset(:thin_port) { 3000 }
        _cset(:thin_pid) { 'tmp/pids/thin.pid' }
        _cset(:thin_log) { 'log/thin.log' }
        _cset(:thin_max_conns) { 1024 }
        _cset(:thin_max_persistent_conns) { 512 }

        _cset(:thin_servers) { 4 }

        namespace :thin do
          task :god do
            render_skel "god/thin.god.erb",  "#{shared_path}/god/#{application}-thin.god"
          end

          task :config do
            render_skel "thin/thin.yml.erb", thin_config_file
          end

          task :shared_pids do
            run "mkdir -p #{shared_path}/pids"
          end

          task :create_symlink do
            run "rm -Rf #{current_path}/tmp/pids && mkdir -p #{current_path}/tmp && ln -sf #{shared_path}/pids #{current_path}/tmp/pids"
          end

        end # namespace thin

        namespace :deploy do
          task :start do
            run "cd #{current_path} && #{thin_command} #{thin_config} start"
          end

          task :stop do
            run "cd #{current_path} && #{thin_command} #{thin_config} stop"
          end

          task :restart do
            top.thin.config

            run "cd #{current_path} && #{thin_command} #{thin_config} -O restart"
          end
        end

        after 'deploy:setup', 'thin:god', 'thin:shared_pids'

        before 'deploy:restart', 'thin:config'
        after 'deploy:create_symlink ', 'thin:create_symlink'

      end # config.load
    end
  end
end

if Capistrano::Configuration.instance
  CapistranoThin::CapistranoIntegration.load_into(Capistrano::Configuration.instance)
end