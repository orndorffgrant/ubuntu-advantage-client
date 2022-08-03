
Feature: Service support matrix per platform per release, tested via ua status output

    @series.xenial
    @uses.config.contract_token
    @uses.config.machine_type.lxd.container
    Scenario: lxd.container xenial
        Given a `xenial` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        cc-eal           yes        Common Criteria EAL2 Provisioning Packages
        cis              yes        Security compliance and audit tools
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        fips             yes        NIST-certified core packages
        fips-updates     yes        NIST-certified core packages with priority security updates
        livepatch        yes        Canonical Livepatch service
        ros              yes        Security Updates for the Robot Operating System
        ros-updates      yes        All Updates for the Robot Operating System

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        cc-eal           yes      +disabled +Common Criteria EAL2 Provisioning Packages
        cis              yes      +disabled +Security compliance and audit tools
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        fips             yes      +disabled +NIST-certified core packages
        fips-updates     yes      +disabled +NIST-certified core packages with priority security updates
        livepatch        yes      +n/a      +Canonical Livepatch service
        ros              yes      +disabled +Security Updates for the Robot Operating System
        ros-updates      yes      +disabled +All Updates for the Robot Operating System

        """

    @series.bionic
    @uses.config.contract_token
    @uses.config.machine_type.lxd.container
    Scenario: lxd.container bionic
        Given a `bionic` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        cc-eal           yes        Common Criteria EAL2 Provisioning Packages
        cis              yes        Security compliance and audit tools
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        fips             yes        NIST-certified core packages
        fips-updates     yes        NIST-certified core packages with priority security updates
        livepatch        yes        Canonical Livepatch service
        ros              yes        Security Updates for the Robot Operating System
        ros-updates      yes        All Updates for the Robot Operating System

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        cc-eal           yes      +disabled +Common Criteria EAL2 Provisioning Packages
        cis              yes      +disabled +Security compliance and audit tools
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        fips             yes      +disabled +NIST-certified core packages
        fips-updates     yes      +disabled +NIST-certified core packages with priority security updates
        livepatch        yes      +n/a      +Canonical Livepatch service
        ros              yes      +disabled +Security Updates for the Robot Operating System
        ros-updates      yes      +disabled +All Updates for the Robot Operating System

        """

    @series.focal
    @uses.config.contract_token
    @uses.config.machine_type.lxd.container
    Scenario: lxd.container focal
        Given a `focal` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        fips             yes        NIST-certified core packages
        fips-updates     yes        NIST-certified core packages with priority security updates
        livepatch        yes        Canonical Livepatch service
        usg              yes        Security compliance and audit tools

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        fips             yes      +disabled +NIST-certified core packages
        fips-updates     yes      +disabled +NIST-certified core packages with priority security updates
        livepatch        yes      +n/a      +Canonical Livepatch service
        usg              yes      +disabled +Security compliance and audit tools

        """

    @series.jammy
    @uses.config.contract_token
    @uses.config.machine_type.lxd.container
    Scenario: lxd.container jammy
        Given a `jammy` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        livepatch        yes        Canonical Livepatch service

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        livepatch        yes      +n/a      +Canonical Livepatch service

        """


    @series.xenial
    @uses.config.contract_token
    @uses.config.machine_type.lxd.vm
    Scenario: lxd.vm xenial
        Given a `xenial` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        cc-eal           yes        Common Criteria EAL2 Provisioning Packages
        cis              yes        Security compliance and audit tools
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        fips             yes        NIST-certified core packages
        fips-updates     yes        NIST-certified core packages with priority security updates
        livepatch        yes        Canonical Livepatch service
        ros              yes        Security Updates for the Robot Operating System
        ros-updates      yes        All Updates for the Robot Operating System

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        cc-eal           yes      +disabled +Common Criteria EAL2 Provisioning Packages
        cis              yes      +disabled +Security compliance and audit tools
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        fips             yes      +disabled +NIST-certified core packages
        fips-updates     yes      +disabled +NIST-certified core packages with priority security updates
        livepatch        yes      +enabled  +Canonical Livepatch service
        ros              yes      +disabled +Security Updates for the Robot Operating System
        ros-updates      yes      +disabled +All Updates for the Robot Operating System

        """

    @series.bionic
    @uses.config.contract_token
    @uses.config.machine_type.lxd.vm
    Scenario: lxd.vm bionic
        Given a `bionic` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        cc-eal           yes        Common Criteria EAL2 Provisioning Packages
        cis              yes        Security compliance and audit tools
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        fips             yes        NIST-certified core packages
        fips-updates     yes        NIST-certified core packages with priority security updates
        livepatch        yes        Canonical Livepatch service
        ros              yes        Security Updates for the Robot Operating System
        ros-updates      yes        All Updates for the Robot Operating System

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        cc-eal           yes      +disabled +Common Criteria EAL2 Provisioning Packages
        cis              yes      +disabled +Security compliance and audit tools
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        fips             yes      +disabled +NIST-certified core packages
        fips-updates     yes      +disabled +NIST-certified core packages with priority security updates
        livepatch        yes      +enabled  +Canonical Livepatch service
        ros              yes      +disabled +Security Updates for the Robot Operating System
        ros-updates      yes      +disabled +All Updates for the Robot Operating System

        """

    @series.focal
    @uses.config.contract_token
    @uses.config.machine_type.lxd.vm
    Scenario: lxd.vm focal
        Given a `focal` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        fips             yes        NIST-certified core packages
        fips-updates     yes        NIST-certified core packages with priority security updates
        livepatch        yes        Canonical Livepatch service
        usg              yes        Security compliance and audit tools

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        fips             yes      +disabled +NIST-certified core packages
        fips-updates     yes      +disabled +NIST-certified core packages with priority security updates
        livepatch        yes      +enabled  +Canonical Livepatch service
        usg              yes      +disabled +Security compliance and audit tools

        """

    @series.jammy
    @uses.config.contract_token
    @uses.config.machine_type.lxd.vm
    Scenario: lxd.vm jammy
        Given a `jammy` machine with ubuntu-advantage-tools installed
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          AVAILABLE  DESCRIPTION
        esm-apps         yes        Extended Security Maintenance for Applications
        esm-infra        yes        Extended Security Maintenance for Infrastructure
        livepatch        yes        Canonical Livepatch service

        """

        When I attach `contract_token` with sudo
        When I run `pro status` with sudo
        Then stdout matches regexp:
        """
        SERVICE          ENTITLED  STATUS    DESCRIPTION
        esm-apps         yes      +enabled  +Extended Security Maintenance for Applications
        esm-infra        yes      +enabled  +Extended Security Maintenance for Infrastructure
        livepatch        yes      +enabled  +Canonical Livepatch service

        """
