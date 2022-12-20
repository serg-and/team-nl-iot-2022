
!!! warning

    The data structure of the provided sensor data is not final, and may change in future revisions


# Writing Scripts
Scripts work by looping through the data coming from the sensors. Each iteration you gather the data of that timestamp using a provided funtion, and then do something with that data. Each script uses this core concept.

## Limitations
Scripts run in realtime, this means that each loop must complete within the update rate of the sensors. The realtime data would otherwise get out of sync.

## Python Scripts
The main function of a Python script should take three parameters:

- **`raw_data`** - The "raw" data coming from the sensors
- **`parse_data(<raw_data>)`** - A function to parse the raw data, returns a data objects
- **`save_value(<value>, <timestamp>)`** - A function to save a value to the database, this will create a point in the output you select when uploading the script

In the main function create a for loop looping through the items of `raw_data`, for each iteration retrieve the parsed data using the `parse_data` function.

### Examples
#### Line Chart - Heartbeat every 5 seconds
```python
# script entrypoint
def main(raw_data, parse_data, save_value):
    UPDATE_RATE = 5000
    last_timestamp = 0
    
    # loop through the data coming from the sensors
    for i in raw_data:
        # retrieve the parsed data
        data = parse_data(i)

        # do something with the data
        if data['timestamp'] - last_timestamp > UPDATE_RATE:
            save_value(data['value'], data['timestamp'])
            last_timestamp = data['timestamp']
```

## R Scripts
The main function of an R script should take two parameters:

- **`get_data()`** - A function to get the the next set of data from the sensors, returns a list()
- **`save_value(<value>, <timestamp>)`** - A function to save a value to the database, this will create a point in the output you select when uploading the script

In the main function create an infinite loop. For each loop retrieve the sensor data at that moment using the `get_data()` function.

### Examples
#### Line Chart - Heartbeat every 5 seconds
```r
# script entrypoint
main <- function(get_data, save_value) {
    UPDATE_RATE <- 5000
    last_timestamp <- 0
    
    # start an infinite loop
    while (TRUE) {
        # retrieve the sensor data
        data <- get_data()

        if (data$timestamp - last_timestamp > UPDATE_RATE) {
            save_value(data$value, data$timestamp)
            last_timestamp <- data$timestamp
        }
    }
}
```
