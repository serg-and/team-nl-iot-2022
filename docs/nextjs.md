# Next.js (Web Application)
The Web Application is written in Next JS, this is a Node JS framework made for react applications.

## APIs
### upload-script [POST]
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
