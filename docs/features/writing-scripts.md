# Writing Scripts
Scripts work by looping through the data coming from the sensors. Each iteration you gather the data of that timestamp using a provided funtion, and then do something with that data. Each script uses this core concept.

## Limitations
Scripts run in realtime, this means that each loop must complete within the update rate of the sensors. The realtime data would otherwise get out of sync.

## Testing Scripts
Scripts can be tested locally using the `test-script` utility. To test a script first clone and install the project as described in [Getting Started](/web-application/getting-started/), enter the `src/next` directory, run the command `npm run test-script --`. The script requires 2 options, the script to test and a CSV file with sensor data.<br>

```bash
$ npm run test-script --                                                                                             

> team-nl-iot@0.1.0 test-script
> node utils/test-script.mjs

Usage: test-script -- -s <script> -c <csv> [options]

Test scripts locally before uploading

Options:
  -V, --version               output the version number
  -s, --script <script>       path to the script to test
  -c, --csv <csv>             path to CSV file containing data
  -l, --language <extension>  script language (script extension by default) [py, r]
  -h, --help                  display help for command

Read the documentation: https://iot.dev.hihva.nl/2022-2023-sep-jan/group-project/team-nl-beachvolley-data-collection/features/writing-scripts/
```

### Example
```bash
$ npm run test-script -- -s my_script.R -c my_csv.csv

Progress [==============--------------------------] 34% | 821/2376 Rows | ETA: 10s
```

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
            save_value(data['heartbeat'], data['timestamp'])
            last_timestamp = data['timestamp']
```

## R Scripts
The main function of an R script should take two parameters:

- **`get_data()`** - A function to get the the next set of data from the sensors, returns a list()
- **`save_value(<value>, <timestamp>)`** - A function to save a value to the database, this will create a point in the output you select when uploading the script

In the main function create an infinite loop. For each loop retrieve the sensor data at that moment using the `get_data()` function.<br><br>

To use libraries, create a global variable named `packages` with i's value being a vector of library names as strings.

### Examples
#### Bar Chart - Jump heights
```r
# define libraries
packages <- c("pracma", "dplyr")

# script entrypoint
main <- function(get_data, save_value) {
    UPDATE_RATE = 3000
    last_timestamp <- 0
    first <- TRUE
    x <- c()
    y <- c()

    # start an infinite loop
    while (TRUE) {
        # retrieve the sensor data
        data <- get_data()
        
        if (is.null(data$timestamp)) {
            next
        }

        if (first) {
            last_timestamp <- data$timestamp
            first <- FALSE
        }

        x <- append(x, data$timestamp)
        y <- append(y, data$gy)

        if (data$timestamp > last_timestamp + UPDATE_RATE) {
            last_timestamp <- data$timestamp

            # time in seconds
            x <- (lag(x) - x)
            x [is.na(x)] <- 0
            x <- cumsum(x)/1000
            
            # flip
            x <- abs(-x)
            y <- -y
            
            # Create a new smooth-data df
            xy_df <- data.frame(x,y)

            # find peaks
            peaks <- findpeaks(xy_df$y,  threshold = 5)

            if (is.null(peaks)) {
                # no peaks founds, abort
                next
            }

            #edit data to match with x-coordinates
            peaks <- as.data.frame(peaks)
            peaks <- as.data.frame(peaks$V1)

            colnames(peaks)[1] <- "y"
            peaks <- merge(xy_df,peaks)

            peaks <- peaks[!(peaks$y < -5),]

            time_x <- 0.3
            peaks <- peaks[order(peaks$x),]
            jumps_df <- peaks %>%  mutate(time_diff = (x - lag(x)))
            jumps_df$time_diff [is.na(jumps_df$time_diff)] <- time_x + 2
            jumps_df <- jumps_df[!(jumps_df$time_diff < time_x),]
            jumps_df <- jumps_df[!lag(jumps_df$time_diff < 1.0) & (jumps_df$time_diff >0.2),]

            min_time <- 0.1
            max_time <- 1

            #calculating jump height
            jumps_height_df <- subset(jumps_df, time_diff >= min_time & time_diff <= max_time)
            jumps_height_df <- jumps_height_df %>%  mutate(height = (0.5*9.81*(time_diff/2)^2))

            
            for (height in jumps_height_df$height) {
                save_value(height, data$timestamp)
            }
            
            x <- c()
            y <- c()
        }
    }
}
```
