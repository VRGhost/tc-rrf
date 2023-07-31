import yaml


class MmSec:
    """The RRF uses mm/min units, while most of slicer settings are expressed as mm/sec.


    This class allows me to use "!mm/sec" prefix in the config YAML file
    with the rest of the process running in mm/min units.
    """

    yaml_tag = R"!mm/sec"

    @classmethod
    def from_yaml(cls, loader, node):
        return int(round(float(node.value) * 60))

    @classmethod
    def to_yaml(cls, dumper, data):
        return dumper.represent_scalar(cls.yaml_tag, data.env_var)


def load(fobj):
    # Add custom tags
    yaml.SafeLoader.add_constructor(MmSec.yaml_tag, MmSec.from_yaml)
    yaml.SafeDumper.add_multi_representer(MmSec, MmSec.to_yaml)
    return yaml.load(fobj, Loader=yaml.SafeLoader)
