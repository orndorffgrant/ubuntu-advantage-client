Feature: Command behaviour when unattached

    @series.all
    @uses.config.machine_type.lxd.container
    Scenario Outline: Unattached auto-attach does nothing in a ubuntu machine
        Given a `<release>` machine with ubuntu-advantage-tools installed
        # Validate systemd unit/timer syntax
        When I run `systemd-analyze verify /lib/systemd/system/ua-timer.timer` with sudo
        Then stderr does not match regexp:
            """
            .*\/lib\/systemd/system\/ua.*
            """
        When I verify that running `ua auto-attach` `as non-root` exits `1`
        Then stderr matches regexp:
            """
            This command must be run as root \(try using sudo\).
            """
        When I run `ua auto-attach` with sudo
        Then stderr matches regexp:
            """
            Auto-attach image support is not available on lxd
            See: https://ubuntu.com/advantage
            """

        Examples: ubuntu release
           | release |
           | bionic  |
           | focal   |
           | xenial  |
           | impish  |
           | jammy   |

    @series.xenial
    @uses.config.machine_type.lxd.container
    Scenario Outline: Disabled unattached APT policy apt-hook for infra and apps
        Given a `<release>` machine with ubuntu-advantage-tools installed
        When I run `apt update` with sudo
        When I run `apt-cache policy` with sudo
        Then stdout matches regexp:
        """
        -32768 <esm-infra-url> <release>-infra-updates/main amd64 Packages
        """
        And stdout does not match regexp:
        """
        -32768 <esm-apps-url> <release>-apps-updates/main amd64 Packages
        """
        And stdout does not match regexp:
        """
        -32768 <esm-apps-url> <release>-apps-security/main amd64 Packages
        """
        When I append the following on uaclient config:
            """
            features:
              allow_beta: true
            """
        And I run `dpkg-reconfigure ubuntu-advantage-tools` with sudo
        And I run `apt-get update` with sudo
        When I run `apt-cache policy` with sudo
        Then stdout matches regexp:
        """
        -32768 <esm-apps-url> <release>-apps-updates/main amd64 Packages
        """
        And stdout matches regexp:
        """
        -32768 <esm-apps-url> <release>-apps-security/main amd64 Packages
        """
        When I append the following on uaclient config:
            """
            features:
              allow_beta: true
            """
        And I delete the file `/var/lib/ubuntu-advantage/jobs-status.json`
        And I run `python3 /usr/lib/ubuntu-advantage/timer.py` with sudo
        And I run `run-parts /etc/update-motd.d/` with sudo
        Then stdout matches regexp:
        """
        \* Introducing Extended Security Maintenance for Applications.
          +Receive updates to over 30,000 software packages with your
          +Ubuntu Advantage subscription. Free for personal use.

            +https:\/\/ubuntu.com\/16-04

        UA Infra: Extended Security Maintenance \(ESM\) is not enabled.
        """
        # Check that json hook is installed properly
        When I run `ls /usr/lib/ubuntu-advantage` with sudo
        Then stdout matches regexp:
        """
        apt-esm-json-hook
        """
        When I run `cat /etc/apt/apt.conf.d/20apt-esm-hook.conf` with sudo
        Then stdout matches regexp:
        """
        apt-esm-json-hook
        """
        When I create the file `/etc/apt/sources.list.d/empty-release-origin.list` with the following
        """
        deb [ allow-insecure=yes ] https://packages.irods.org/apt xenial main
        """
        Then I verify that running `apt-get update` `with sudo` exits `0`
        When I delete the file `/var/lib/ubuntu-advantage/jobs-status.json`
        And I run `python3 /usr/lib/ubuntu-advantage/timer.py` with sudo
        Then I verify that running `/usr/lib/ubuntu-advantage/apt-esm-hook process-templates` `with sudo` exits `0`

        Examples: ubuntu release
           | release | esm-infra-url                       | esm-apps-url |
           | xenial  | https://esm.ubuntu.com/infra/ubuntu | https://esm.ubuntu.com/apps/ubuntu |

    @series.all
    @uses.config.machine_type.lxd.container
    Scenario Outline: Unattached commands that requires enabled user in a ubuntu machine
        Given a `<release>` machine with ubuntu-advantage-tools installed
        When I verify that running `ua <command>` `as non-root` exits `1`
        Then I will see the following on stderr:
            """
            This command must be run as root (try using sudo).
            """
        When I verify that running `ua <command>` `with sudo` exits `1`
        Then stderr matches regexp:
            """
            This machine is not attached to a UA subscription.
            See https://ubuntu.com/advantage
            """

        Examples: ua commands
           | release | command |
           | bionic  | detach  |
           | bionic  | refresh |
           | focal   | detach  |
           | focal   | refresh |
           | xenial  | detach  |
           | xenial  | refresh |
           | impish  | detach  |
           | impish  | refresh |
           | jammy   | detach  |
           | jammy   | refresh |

    @series.all
    @uses.config.machine_type.lxd.container
    Scenario Outline: Help command on an unattached machine
        Given a `<release>` machine with ubuntu-advantage-tools installed
        When I run `ua help esm-infra` as non-root
        Then I will see the following on stdout:
            """
            Name:
            esm-infra

            Available:
            <infra-status>

            Help:
            esm-infra provides access to a private ppa which includes available high
            and critical CVE fixes for Ubuntu LTS packages in the Ubuntu Main
            repository between the end of the standard Ubuntu LTS security
            maintenance and its end of life. It is enabled by default with
            Extended Security Maintenance (ESM) for UA Apps and UA Infra.
            You can find our more about the esm service at
            https://ubuntu.com/security/esm
            """
        When I run `ua help esm-infra --format json` with sudo
        Then I will see the following on stdout:
            """
            {"name": "esm-infra", "available": "<infra-status>", "help": "esm-infra provides access to a private ppa which includes available high\nand critical CVE fixes for Ubuntu LTS packages in the Ubuntu Main\nrepository between the end of the standard Ubuntu LTS security\nmaintenance and its end of life. It is enabled by default with\nExtended Security Maintenance (ESM) for UA Apps and UA Infra.\nYou can find our more about the esm service at\nhttps://ubuntu.com/security/esm\n"}
            """
        When I verify that running `ua help invalid-service` `with sudo` exits `1`
        Then I will see the following on stderr:
            """
            No help available for 'invalid-service'
            """

        Examples: ubuntu release
           | release  | infra-status |
           | bionic   | yes          |
           | focal    | yes          |
           | xenial   | yes          |
           | impish   | no           |
           | jammy    | yes           |

    @series.all
    @uses.config.machine_type.lxd.container
    Scenario Outline: Run collect-logs on an unattached machine
        Given a `<release>` machine with ubuntu-advantage-tools installed
        When I run `python3 /usr/lib/ubuntu-advantage/timer.py` with sudo
        And I verify that running `ua collect-logs` `as non-root` exits `1`
        Then I will see the following on stderr:
             """
             This command must be run as root (try using sudo).
             """
        When I run `ua collect-logs` with sudo
        Then I verify that files exist matching `ua_logs.tar.gz`
        When I run `tar zxf ua_logs.tar.gz` as non-root
        Then I verify that files exist matching `logs/`
        When I run `sh -c "ls -1 logs/ | sort -d"` as non-root
        Then stdout matches regexp:
        """
        build.info
        cloud-id.txt
        jobs-status.json
        journalctl.txt
        livepatch-status.txt-error
        systemd-timers.txt
        ua-auto-attach.path.txt-error
        ua-auto-attach.service.txt-error
        uaclient.conf
        ua-reboot-cmds.service.txt
        ua-status.json
        ua-timer.service.txt
        ua-timer.timer.txt
        ubuntu-advantage.log
        ubuntu-advantage.service.txt
        ubuntu-advantage-timer.log
        """
        Examples: ubuntu release
          | release |
          | bionic  |
          | focal   |
          | impish  |
          | jammy   |

    @series.all
    @uses.config.machine_type.lxd.container
    Scenario Outline: Unattached enable/disable fails in a ubuntu machine
        Given a `<release>` machine with ubuntu-advantage-tools installed
        When I verify that running `ua <command> esm-infra` `as non-root` exits `1`
        Then I will see the following on stderr:
          """
          This command must be run as root (try using sudo).
          """
        When I verify that running `ua <command> esm-infra` `with sudo` exits `1`
        Then I will see the following on stderr:
          """
          To use 'esm-infra' you need an Ubuntu Advantage subscription
          Personal and community subscriptions are available at no charge
          See https://ubuntu.com/advantage
          """
        When I verify that running `ua <command> esm-infra --format json --assume-yes` `with sudo` exits `1`
        Then stdout is a json matching the `ua_operation` schema
        And I will see the following on stdout:
          """
          {"_schema_version": "0.1", "errors": [{"message": "To use 'esm-infra' you need an Ubuntu Advantage subscription\nPersonal and community subscriptions are available at no charge\nSee https://ubuntu.com/advantage", "message_code": "valid-service-failure-unattached", "service": null, "type": "system"}], "failed_services": [], "needs_reboot": false, "processed_services": [], "result": "failure", "warnings": []}
          """
        When I verify that running `ua <command> unknown` `as non-root` exits `1`
        Then I will see the following on stderr:
          """
          This command must be run as root (try using sudo).
          """
        When I verify that running `ua <command> unknown` `with sudo` exits `1`
        Then I will see the following on stderr:
          """
          Cannot <command> unknown service 'unknown'.
          See https://ubuntu.com/advantage
          """
        When I verify that running `ua <command> unknown --format json --assume-yes` `with sudo` exits `1`
        Then stdout is a json matching the `ua_operation` schema
        And I will see the following on stdout:
          """
          {"_schema_version": "0.1", "errors": [{"message": "Cannot <command> unknown service 'unknown'.\nSee https://ubuntu.com/advantage", "message_code": "invalid-service-or-failure", "service": null, "type": "system"}], "failed_services": [], "needs_reboot": false, "processed_services": [], "result": "failure", "warnings": []}
          """
        When I verify that running `ua <command> esm-infra unknown` `as non-root` exits `1`
        Then I will see the following on stderr:
            """
            This command must be run as root (try using sudo).
            """
        When I verify that running `ua <command> esm-infra unknown` `with sudo` exits `1`
        Then I will see the following on stderr:
          """
          Cannot <command> unknown service 'unknown'.

          To use 'esm-infra' you need an Ubuntu Advantage subscription
          Personal and community subscriptions are available at no charge
          See https://ubuntu.com/advantage
          """
        When I verify that running `ua <command> esm-infra unknown --format json --assume-yes` `with sudo` exits `1`
        Then stdout is a json matching the `ua_operation` schema
        And I will see the following on stdout:
          """
          {"_schema_version": "0.1", "errors": [{"message": "Cannot <command> unknown service 'unknown'.\n\nTo use 'esm-infra' you need an Ubuntu Advantage subscription\nPersonal and community subscriptions are available at no charge\nSee https://ubuntu.com/advantage", "message_code": "mixed-services-failure-unattached", "service": null, "type": "system"}], "failed_services": [], "needs_reboot": false, "processed_services": [], "result": "failure", "warnings": []}
          """

        Examples: ubuntu release
          | release | command  |
          | xenial  | enable   |
          | xenial  | disable  |
          | bionic  | enable   |
          | bionic  | disable  |
          | focal   | enable   |
          | focal   | disable  |
          | impish  | enable   |
          | impish  | disable  |
          | jammy   | enable   |
          | jammy   | disable  |
