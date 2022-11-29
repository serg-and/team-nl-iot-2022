import fileinput
import json
from script import main


def parse_data(string):
    return json.loads(string.rstrip())


def save_data_point(name, value, timestamp):
    print(f"saved {name}={value} at {timestamp}", flush=True, end='')


main(fileinput.input, parse_data, save_data_point)


# for line in fileinput.input():
#     string = line.rstrip()

#     serialized = json.dumps({
#         'message': string
#     })

#     print(serialized, flush=True, end='')
