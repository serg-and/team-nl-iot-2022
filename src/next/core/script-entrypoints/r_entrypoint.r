library('rjson')

# Get the script path from the command line
script_path <- commandArgs(trailingOnly=TRUE)[1]
# Load the user-provided script
source(script_path)

# get the latest message send from the mother process
# parse and return the data
get_data <- function() {
    line <- readLines('stdin', n=1, warn=FALSE)
    fromJSON(json_str=line)
}

# function for script writer
# sends data to mother process wchich will
# add the given value to the output chosen by the script
save_value <- function(value, timestamp) {
    # prepare return data
    return_data = list(
        'type'='save',
        'value'=value,
        'timestamp'=timestamp
    )
    # put data on stdout, will be picked up by mother process
    cat(toJSON(return_data))
}

# start the script
main(get_data, save_value)
