import argparse
import os


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--docker-image', action='store', required=True, help='Docker image to be deployed')
    parser.add_argument('-a', '--app-domain', action='store', required=True,
                        help='Domain where the app will be installed e.g. blog.mydomain.com')
    parser.add_argument('-c', '--cloudron-server', action='store', required=True,
                        help='Domain of cloudron server e.g. my.server.com')
    parser.add_argument('-t', '--cloudron-token', action='store', required=True, help='Cloudron auth token')
    parser.add_argument('-i', '--install-if-missing', action='store', required=True, default=False,
                        help='Should the app be installed if not already installed, instead of being updated?')
    parser.add_argument('-b', '--skip-backup', action='store', required=False, help='Skip backup before updating')
    parser.add_argument('-e', '--env-vars', action='store', required=False,
                        help='Environment variables to set in the container')

    args = parser.parse_args()
    return args


def check_if_exists(cloudron_server, cloudron_token, app_domain):
    print('Checking if app exists')
    command = 'cloudron list --server {0} --token {1} | grep {2} | wc -l'.format(
        cloudron_server, cloudron_token, app_domain)
    output = os.popen(command)
    return True if output.read() == 1 else False


def update_app(skip_backup, cloudron_server, cloudron_token, app_domain, docker_image):
    if skip_backup:
        snippet = '--no-backup'
    else:
        snippet = ''

    command = 'cloudron update {0} --server {1} --token {2} --app {3} --image {4}'.format(
        snippet, cloudron_server, cloudron_token, app_domain, docker_image)

    os.system(command)


def install_app(cloudron_server, cloudron_token, app_domain, docker_image):
    command = 'cloudron install --server {0} --token {1} --location {2} --image {3}'.format(
        cloudron_server, cloudron_token, app_domain, docker_image)
    os.system(command)


def install_or_update(docker_image, app_domain, cloudron_server, cloudron_token, install_if_missing, skip_backup):
    app_exists = check_if_exists(cloudron_server, cloudron_token, app_domain)

    if not app_exists:
        if install_if_missing:
            print('App does not exist, installing')
            install_app(cloudron_server=cloudron_server,
                        cloudron_token=cloudron_token,
                        app_domain=app_domain,
                        docker_image=docker_image)
        else:
            print('App does not exist, and install-if-missing is false, so doing nothing')
    else:
        print('App exists, updating')
        if skip_backup:
            print('skip-backup is True, skipping backup')
        update_app(skip_backup=skip_backup,
                   cloudron_server=cloudron_server,
                   cloudron_token=cloudron_token,
                   app_domain=app_domain,
                   docker_image=docker_image)


def set_env(env_vars, cloudron_server, cloudron_token, app_domain):
    if env_vars:
        print('Setting environment variables')
        command = 'cloudron env set {0} --server {1} --token {2} --app {3}'.format(env_vars, cloudron_server,
                                                                                   cloudron_token, app_domain)
        os.system(command)


if __name__ == '__main__':
    args = parse_arguments()

    install_or_update(docker_image=args.docker_image,
                      app_domain=args.app_domain,
                      cloudron_server=args.cloudron_server,
                      cloudron_token=args.cloudron_token,
                      install_if_missing=args.install_if_missing,
                      skip_backup=args.skip_backup)

    set_env(env_vars=args.env_vars,
            cloudron_server=args.cloudron_server,
            cloudron_token=args.cloudron_token,
            app_domain=args.app_domain)
