import sys
# import fileinput
import json
from importlib.machinery import SourceFileLoader


# parses JSON-encoded data from the standard input stream
def parse_data(string):
    return json.loads(string.rstrip())


# saves a value at a given timestamp
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

# Load the user-provided script as a module
script = SourceFileLoader('script', script_path).load_module('script')

# Try running the script's main function
try:
    script.main(sys.stdin, parse_data, save_value)
# If an exception is raised, print the error message to stdout
except Exception as e:
    error_msg = {
        'type': 'error',
        'error': 'Error occured during execution of script',
        'stacktrace': e.with_traceback()
    }
    print(json.dumps(error_msg), flush=True, end='')
