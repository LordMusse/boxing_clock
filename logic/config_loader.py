import yaml
from pathlib import Path

# detta hämtar configurationen från en json-fil
def load_config(category):
    return yaml.safe_load(Path("config.yaml").read_text())[category]


if __name__ == "__main__":
    specified_config = load_config("timer_settings")
    print("This is a test and here are the timer settings")
    print(specified_config)
    print("And this is the value of the first element")
    print(specified_config[list(specified_config.keys())[0]])
