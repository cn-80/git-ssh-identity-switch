# git ssh identity switch
Switch identity when using SSH to make changes to a git repository.

## Usage
1. Install the gem: `gem install git_ssh_identity_switch`
1. Generate a config file and set it up: `switch-git --init`
1. Run `switch-git --list`
1. Select the identity username and switch to it: ``source `switch-git home```
1. Check the environment variables: `env | grep 'GIT_'`
1. Use git as your new identity

**Note:** The identity is switched only within the *current* shell environment.
To setup a default identity, you can add the command to your shell profile.

If you messed up old commits, check out this script to rewrite your author name and email: https://github.com/frz-dev/utilities/blob/master/git/git-author-rewrite.sh

## Configuration
The configuration file is `~/.git_ssh_identity.json`

This can be overridden by using the `-c` flag: `switch-git -c ./config.json`

The configuration file looks like this:

```
{
  "users": [
    {
      "username": "home",
      "pubkey_path": "~/.ssh/id_home.pub",
      "name": "Home",
      "email": "home@localhost"
    },
    {
      "username": "megacorp",
      "pubkey_path": "~/.ssh/id_megacorp.pub",
      "name": "MegaCorp Programmer",
      "email": "programmer-megacorp@localhost"
    }
  ]
}
```

## Developing

Run this to test it:

```shell
source `ruby -Ilib bin/switch-git cn-80`
```
