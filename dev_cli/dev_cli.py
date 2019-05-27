# Created: May 25, 2019
# Author: Sumanth Nirmal
# Brief: command line interface for dev environment

import sys
import os
import click
import subprocess

DEV_HOME = "/dev-home"
DOCKER_IMAGE = "docker_image"
def _print_version(ctx, _, value):
    if not value or ctx.resilient_parsing:
        return
    from . import __version__
    print(__version__)
    ctx.exit()

def _pre_check():
    """"Pre-check for dev"""
    home = os.path.expanduser("~")
    path = home + DEV_HOME
    if not os.path.isdir(path):
        print('ERROR: Needs a directory %s in %s' %(DEV_HOME, path), file=sys.stderr)
        sys.exit(1)

def _is_running(name):
    """"Check if container is running"""
    is_running = subprocess.run(['docker', 'inspect', "--format='{{.State.Running}}'", name],
    stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout.decode('utf-8')
    if is_running == "'true'\n":
        return "true"
    else:
        return "false"

@click.group()
@click.option('--version', is_flag=True, callback=_print_version, expose_value=False, is_eager=True)
def dev():
    """Development Environment."""

@dev.command('build')
@click.option('-p', '--path', default=os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '../')), help='Enter the path for Dockerfile instead of the default')
@click.option('-t', '--tag', default="dev_docker_iamge", help='Enter the tag for Docker image instead of the default')
def dev_build(path, tag):
    """Build dev docker image."""
    # pre-check
    if not os.path.isfile(os.path.join(path, "Dockerfile")):
        print('ERROR: Unable to find "Dockerfile" in path: %s' %(path), file=sys.stderr)
        sys.exit(1)

    subprocess.run(['docker', 'build', '--tag', tag, path])

@dev.command('enter')
@click.option('-u', '--user', default="$(id -u)", help='Enter dev as given user (e.g. root) instead of default')
@click.option('-n', '--name', default=DOCKER_IMAGE, help='Enter the container name instead of default')
@click.argument('cmd', required=False)
def dev_enter(cmd, user, name):
    """Enter dev environment."""
    _pre_check()
    if _is_running(DOCKER_IMAGE) == "false":
        print('ERROR: %s is not running, please start with: dev start' %DOCKER_IMAGE, file=sys.stderr)
        sys.exit(1)

    subprocess.run(['docker', 'exec', '-ti', '-u', user, name, 'bash', '-li'])
    #docker exec -ti -u "$(id -u)" $DOCKER_CONATINER_NAME bash -li

@dev.command('start')
@click.option('-n', '--name', default=DOCKER_IMAGE, help='Enter the container name instead of default')
@click.option('--update/--no-update', help='Pull docker registries for updates.')
@click.option('--enter/--no-enter', help='Enter dev environment after starting.')
@click.option('-f', '--force/--no-force', help='Force restart of running dev environment.')
@click.argument('addargs', nargs=-1)
def dev_start(name, update, enter, force, addargs):
    """Start dev environment.

    ADDARGS are directly passed to docker run. To pass options,
    separate them with -- from the preceding dev options. For example
    to have dev publish a specific udp port use:

    dev start -- --publish 127.0.0.1:1234:1234/udp

    See https://docs.docker.com/engine/reference/commandline/run/ for
    more information.
    """
    _pre_check()


@dev.command('stop')
@click.option('--name', 'option', default=True, help='Enter the container name to be stopped instead of default.')
@click.option('--all', 'option', flag_value="all", help='Stop all the running docker containers.')
def dev_stop(option):
    """Stop the docker containers for dev environment."""
    if option == False:
        if _is_running(DOCKER_IMAGE) == "true":
            subprocess.run(['docker', 'stop', '-t', '0', DOCKER_IMAGE])
        else:
            print('ERROR: Container %s is not running.' %DOCKER_IMAGE, file=sys.stderr)
            sys.exit(1)
    elif option == "all":
        containers = subprocess.run(['docker', 'ps', '-a', '-q'],
        stdout=subprocess.PIPE).stdout.decode('utf-8')
        print(containers)
        subprocess.run(['docker', 'stop', containers])
    else:
        if _is_running(option) == "true":
            subprocess.run(['docker', 'stop', '-t', '0', option])
        else:
            print('ERROR: Container %s is not running.' %option, file=sys.stderr)
            sys.exit(1)

def cli():
    dev()
