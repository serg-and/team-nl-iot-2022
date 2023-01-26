# API Documentation
## upload-script [POST]
Upload a data analysis script<br><br>
**URI**<br>
[POST]() /api/upload-script<br>

**Example Request**<br>
Headers
```json
{Content-Type: "application/json"}
```
Body
```json
{
  "code": "def main(raw_data, parse_data, save_data_point):\n    for i in raw_data():\n        data = parse_data(i)",
  "language": "py",
  "name": "script",
  "description": "script description",
  "outputType": "line_chart",
  "outputName": "Heartbeat"
}
```

**Response `200`**<br>
`ok`

## download [Get]
Download raw sensor data CSV for a session<br><br>
**URI**<br>
[GET]() /api/download/<session_id>_<member_id>.csv?filename=filename<br>

**Example Request**<br>
GET /api/download/43_21.csv?filename=session_data.csv

**Response `200`**<br>
...CSV file contents

