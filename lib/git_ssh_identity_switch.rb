require 'json'

class GitSshIdentitySwitch
  def initialize(config_path:, init_config: false)
    if init_config
      create_config_file
    else
      load_config(config_path)
    end
  end

  def create_config_file
    @config = {
      'users' => [
      ]
    }
    output = File.open(config_path, 'w')
    output.close
  end

  def load_config(config_path)
    @config = JSON.parse(File.open(config_path) { |f| f.read })
  end


  def usernames
    @config['users'].map { |user| user['username'] }
  end

  def find_user_by_username(username)
    @config['users'].find { |user| user['username'] == ARGV.first }
  end

  def git_env_vars(user)
    [
      ['GIT_AUTHOR_NAME', user['name']],
      ['GIT_AUTHOR_EMAIL', user['email']],
      ['GIT_COMMITTER_NAME', user['name']],
      ['GIT_COMMITTER_EMAIL', user['email']],
      ['GIT_SSH_COMMAND', "ssh -o StrictHostKeyChecking=no -i #{user['pubkey_path']}"]
    ]
  end

  def write_env_vars_to_file(env_vars, output_path)
    output = File.open(output_path, 'w')
    env_vars.each do |(key, value)|
      output.write("export #{key}='#{value}'\n")
    end
    output.close
  end

  def run!(username)
    user = find_user_by_username(ARGV.first)
    output_path = "/tmp/switch-git-identity-#{user['username']}.sh"
    env_vars = git_env_vars(user)
    write_env_vars_to_file(env_vars, output_path)
    output_path
  end

  # Could be needed to support older versions of git (any version that does not support GIT_SSH_COMMAND)
  # shell_script_path = "/tmp/switch-git-identity-#{user['username']}-wrapper.sh"
  # shell_script = File.open(shell_script_path, 'w')
  # shell_script.write("#!/bin/sh\n")
  # shell_script.write("exec /usr/bin/ssh -o StrictHostKeyChecking=no -i #{user['pubkey_path']} \"$@\"\n")
  # shell_script.close
end
