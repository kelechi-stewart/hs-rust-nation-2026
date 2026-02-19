# Attendee Instructions

Ever tried driving a car with a third person view?
No?
Well, this is your chance!

In this challenge, your team will be given a car which you can remote-control via simple HTTP requests.
However, this car doesn't have any sensors to know where it is!
Fortunately, you also have access to two cameras watching over the arena, and every car is fitted with an easily machine-recognisable QR code.

With these tools at your disposal, your goal is to please the Helsing Oracle by driving your car to a quadrant of its choosing.
Fastest car to get to the right quadrant each time wins!

## Setup

To start off, connect to the Helsing hackathon Wi-Fi:

- SSID: `hs-hack`
- Password: traction-oneself-divine-recorder

That's it!
Don't hesitate to ask the team if you have any questions about the rest of the instructions.

## Driving your car

Each car has a number: you can find this on the reverse of the ArUco marker on top.
Supposing your marker is `N`, your car's control server will be running at `hackathon-N-car.local:50051`.

It's a simple HTTP server! The car is controlled by simply sending `PUT` requests to the root with a JSON body containing two fields:

0. `speed`, as a float between -1.0 (drive backwards) and 1.0 (drive forwards).
   Smaller values cause you to drive more slowly.
0. `flip`, as a boolean.
   If true, the wheels will drive in opposite directions, causing you to turn roughly in place.

You'll also need to send an `Authorization` header with a 6 digit authorization token - this will be provided by a friendly Helsinger, and is unique for each car.
Don't share it with other teams if you don't want to be sabotaged!

An example `curl` to drive car #9 forward at 50% speed might look like this:

```
curl -X PUT hackathon-9-car.local:5000 \
    --header "Content-Type: application/json" \
    --header "Authorization: 000000" \
    --data '{"speed":0.5,"flip":false}'
```

Things to note:

- There's a 100ms cool-down between requests.
- Any command to your car expires after 1 second (so you need to keep sending commands to keep it driving).
- `speed` values close to 0 may result in the motors not spinning as the torque is too low.

## Viewing the arena

In order to get a view of the arena, you can make a similar request to one of the two cameras.
All teams have access to both cameras, and you may want to use both to get the best view of the arena.

You'll still need a unique authorization token to access each camera.
The cameras are accessible on the network at:

- `hackathon-11-camera:50051/frame`
- `hackathon-12-camera:50051/frame`

An example `curl` might look like:

```
curl hackathon-11-camera.local:50051/frame --header "Authorization: 123456"
```

The response is a JPEG image of the last captured frame.
There is no rate limit on how often you may request a frame, but note that the cameras capture as fast as they can and cache the image - frequent requests may give the same frame.

All cars, and the corners of the arena, are equipped with an identifying ArUco marker in the 4x4 dictionary.
These markers are designed to be easily detectable for use in computer vision.
You will find libraries (such as OpenCV) out there that can detect the coordinates of these, along with the ID corresponding to a given marker, with minimal code required!  \
Feel free to challenge yourself and train your own models, but we'd recommend using an off-the-shelf model or library to get started.

## The Challenge...

Finally, a central "Oracle" server can be polled to get a target quadrant.
This server's IP address on the local network will be provided by the Helsing team (once it is known, at the venue).

You'll once again need an authorization token, which will allow you to issue a simple `GET` request to the `/quadrant` endpoint:

```
curl 192.168.0.56:31415/quadrant --header 'Authorization: 606545'
```

The target quadrant will change every 5 minutes throughout the day, and every minute once we enter "competition mode" at the end of the day (and actively judge whose solution is fastest).
There's no rate-limiting, but issuing more than 1-2 requests per second really isn't necessary.
