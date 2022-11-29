def main(raw_data, parse_data, save_data_point):
    for i in raw_data():
        data = parse_data(i)

        if data['value'] > 500:
            save_data_point('value', data['value'], data['timestamp'])