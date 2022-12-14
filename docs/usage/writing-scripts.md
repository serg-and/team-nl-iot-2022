# Writing Scripts
To write a script create a function called `main`, this is the "entrypoint" in to the script. The main function should take three parameters:

- **`raw_data`** - The "raw" data coming from the sensors
- **`parse_data(<raw_data>)`** - A function to parse the raw data, returns a data objects
- **`save_value(<value>, <timestamp>)`** - A function to save a value to the database, this will create a point in the output you select when uploading the script

Scripts work by looping through the data coming from the sensors. In the main function create a for loop looping through the items of `raw_data`, for each iteration retrieve the parsed data using the parse_data function. Each script uses this core concept.

```python
# script entrypoint
def main(raw_data, parse_data, save_value):
    # loop through the data coming from the sensors
    for i in raw_data:
        # retrieve the parsed data
        data = parse_data(i)
        
        # do something with the data
```

### Limitations
Scripts run in realtime, this means that calculation must complete within within the update rate of the sensors. The realtime data would otherwise get out of sync.

## Python Examples
### Line Chart - Heartbeat every 5 seconds
```python
def main(raw_data, parse_data, save_value):
    UPDATE_RATE = 5000
    last_timestamp = 0
    
    for i in raw_data:
        data = parse_data(i)

        if data['timestamp'] - last_timestamp > UPDATE_RATE:
            last_timestamp = data['timestamp']
            save_value(data['value'], data['timestamp'])
```

## R Examples
support coming soon!
