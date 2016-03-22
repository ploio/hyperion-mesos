# Hyperion

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Description

![Image of components](https://github.com/portefaix/hyperion-mesos/raw/master/docs/hyperion-mesos.png "Hyperion Swarm")

[hyperion][] creates a Cloud environment :

- Identical machine images creation is performed using [Packer][]
- Orchestrated provisioning is performed using [Terraform][]
- Applications managment is performed using [Mesos][]

## Initialization

Initialize environment:

    $ make init


## Machine image

Read guides to creates the machine for a cloud provider :

* [Google cloud](https://github.com/portefaix/hyperion-mesos/blob/packer/google/README.md)

## Cloud infratructure

Read guides to creates the infrastructure :

* [Google cloud](https://github.com/portefaix/hyperion-mesos/blob/infra/google/README.md)


## Usage



## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE][] for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[hyperion]: https://github.com/portefaix/hyperion-mesos
[LICENSE]: https://github.com/portefaix/hyperion-mesos/blob/master/LICENSE
[Issue tracker]: https://github.com/portefaix/hyperion-mesos/issues

[Mesos]: https://github.com/docker/mesos

[terraform]: https://terraform.io
[packer]: https://packer.io

[badge-license]: https://img.shields.io/badge/license-Apache_2-green.svg
[badge-release]: https://img.shields.io/github/release/portefaix/hyperion-mesos.svg
