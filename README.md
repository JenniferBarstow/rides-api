# README


### Description

This Rails API is built to mimic a scheduled ride service and not an on-demand ride service. In this app for drivers, I show them a list of upcoming rides so they can eventually pick the ones they want. The goal with this endpoint is to show the best rides for each driver, so to that end I have an internal scoring system. This endpoint returns a list of rides that are available for a driver to accept. They are sorted by score, in descending order. Google Direction Service API is utilized for this app in order to get the directions and distances from the origin location of the driver to the starting and ending locations of the available rides


### Versions
- Ruby 3. 2. 2
- Rails 7. 0. 4. 3


### Endpoint

`GET /api/v1/rides`

### Parameters

- `driver_id` - required. The ID of the driver for whom to find rides.
- `page` - optional. The page number of the result set to return. Default is 1.
- `per_page` - optional. The number of results per page to return. Default is 3, for demonstration purposes.

### Request headers

None required.

### Response

Returns a JSON object with the following keys:

- `rides` - an array of ride objects. Each object contains the following keys:
    - `id` - the ID of the ride.
    - `start_address` - the starting address of the ride.
    - `destination_address` - the destination address of the ride.
- `total_count` - the total number of rides available for the driver.
- `links` - a hash containing links to the current, next, and previous pages of the result set. If there is no next or previous page, the corresponding link will be `null`. The keys of the hash are:
    - `self` - the link to the current page.
    - `next` - the link to the next page.
    - `prev` - the link to the previous page.

### Example Request

```
curl --location --request GET 'http://localhost:3000/api/v1/rides?driver_id=1&page=1&per_page=25'

```

### Example Response

```
{
    "rides": [
        {
            "id": 1,
            "start_address": "123 Main St",
            "destination_address": "456 Elm St",
        },
        {
            "id": 2,
            "start_address": "789 Oak St",
            "destination_address": "101 Maple St",
        }
    ],
    "total_count": 6,
    "links": {
        "self": "https://example.com/api/v1/rides?driver_id=1234&page=1&per_page=2",
        "next": "http://localhost:3000/api/v1/rides?driver_id=1&page=2&per_page="
    }
}

```

### Errors

- `404 Not Found` - if the driver with the specified ID is not found.
- `500 Internal Server Error` - if there is an internal server error.

### Authentication

None required.

### Setup

- Database creation
`rake db:create` to create the database
`rake db:migrate` to run the migrations
`rake db:seed` to seed the database with Driver data and Ride data


- How to run the test suite
`rspec spec`

- This application uses the `dotenv`ruby gem to store your `GOOGLE_MAPS_API_KEY` in a `.env` file and ignore it in version control.

1. run `bundle install`.
2. Create a `.env` file in the root of your project.

```
touch .env

```

1. Add your `GOOGLE_MAPS_API_KEY` to the `.env` file. Note that there should be no spaces around the `=` sign.

```
GOOGLE_MAPS_API_KEY=your_api_key_here

```

1. Add `.env` to your `.gitignore` file to ensure that it is not committed to version control.

```
echo .env >> .gitignore

```

This will allow you to use your `GOOGLE_MAPS_API_KEY` without exposing it in your code or version control.

### Caching
The `Rails.cache.fetch` method is used to cache the response from the `DirectionsService` API for a given origin and destination. The `expires_in` option is set to 1 hour, which means that the cache will expire after 1 hour. This value can be changed for desired cache time.

When the code is executed, Rails will first check the cache to see if a response for the given origin and destination is already stored. If a cached response is found, it will be returned immediately without making a request to the API.

If no cached response is found, the code inside the block will be executed, which makes a request to the `DirectionsService` API and returns the response. This response is then cached using the cache key and expiration time specified in the `Rails.cache.fetch` method.

Subsequent requests for the same origin and destination will use the cached response instead of making a new API request, as long as the cache has not yet expired. This can significantly reduce the number of API requests made by the application, which can improve performance and reduce API usage.



### Additional Information

This endpoint uses the following:
- `RideCalculator` class to calculate the score of each ride, which determines the order in which they are returned. The score is based on the earnings, commute distance, and ride distance of the ride.

- `DirectionsService` class to calculate the distance and duration of each ride by calling`Google Directions API`


### Database Information
- Rides start out not being associated with a Ride. If given more time, I would add the functionality for a driver to "pick" or "add" rides to their queue. You do, however, have the abililty to associate a Ride with a Driver in the Rails console by adding the associated `driver_id` value to an instance of a Ride.

### Future Considerations
- I would dry up any duplication in the RideCalculator, add a RideSerializer, add ability and enpoint for a driver to select a ride and one for them to view their selected/scheduled upcoming rides. I would also add additional error handling and see if the need for Sidekiq was needed for anything intensive that I could delegate to background jobs. Authentication would obviously be added if this were a real service. The main focus was on scoring the rides propery in Ride Calculator and reducing extra/duplicate calls in the Directions service.
  



