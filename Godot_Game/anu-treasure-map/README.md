1.Location background images are stored in:
res/resources/Location/

2.Map photos or images are stored in:
res/resources/Map/

3.The Locations file is located here:
res/data/locations.json
This file stores information about each location.

4. How to Add a New Location

Step 1
Add a background image to:
res/resources/Location/
Example:
Library.png

Step 2
Add a new entry in locations.json
Example:
"library": {
  "title": "Chifley Library",
  "description": "A large study space.",
  "image_path": "res://resources/Location/Library.png",
  "texts": [
	"Many students study here.",
    "It is quiet and comfortable."
  ]
}

Step 3
Make sure the location id matches the map icon.
Example:
library
cafe
lake
