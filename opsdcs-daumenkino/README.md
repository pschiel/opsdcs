# Daumenkino Video Player

DCS doesn't let us play videos, but we can show images real fast.

## Preparing the video

1. Save your recording in seperate video and audo track, e.g. `blah.mp4` and `blah.ogg`
2. Download [ffmpeg](https://www.ffmpeg.org/download.html)
3. Convert video into seperate images at desired framerate and size:
    
    `ffmpeg.exe -i blah.mp4 -vf "fps=12,scale=1920:-1" blah_%04d.jpg`

*Note: further compression, resize etc might be needed to reduce overall size.*

## Using in mission

1. Open the miz with 7zip or similar
2. Create a `sounds` folder inside and copy the `blah.ogg` into it
3. Create a `images` folder inside and copy all images `blah_0001.jpg`, ... into it
4. Load [opsdcs-daumenkino.lua](opsdcs-daumenkino.lua) at mission start (DO_SCRIPT_FILE)
5. To play it, use a DO_SCRIPT and call the daumenkino function:

    `Daumenkino:play("blah", 520, 12, true, "cutscene_done")`

    This will:
    - play `blah.ogg` and show `blah*.jpg` images
    - 520 frames/images in total
    - at 12fps
    - using active pause
    - set a ME flag `cutscene_done` at end of playback

## Notes

- You can also use this for slideshows by creating images manually and set fps to a fraction, e.g. fps = 0.2 means one picture every 5 seconds
- It works also with 25fps on a fast computer, however untested on weaker systems (DCS creates a texture for every picture)
- Show Picture has always a border, so best effect is achieved in an empty night mission and placing the player somewhere in the prairie with no lights around
