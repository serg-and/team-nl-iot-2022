import sys
# import fileinput
import json
from importlib.machinery import SourceFileLoader


def parse_data(string):
    return json.loads(string.rstrip())


def save_value(value, timestamp):
    save_msg = {
        'type': 'save',
        'value': value,
        'timestamp': timestamp
    }
    print(json.dumps(save_msg), flush=True, end='')


# Get the script path from the command line
if len(sys.argv) < 2:
    print('Usage: python start_script.py <script path>')
    sys.exit(1)
script_path = sys.argv[1]
script = SourceFileLoader('script', script_path).load_module('script')

try:
    script.main(sys.stdin, parse_data, save_value)
except Exception as e:
    error_msg = {
        'type': 'error',
        'error': 'Error occured during execution of script',
        'stacktrace': e.with_traceback()
    }
    print(json.dumps(error_msg), flush=True, end='')
