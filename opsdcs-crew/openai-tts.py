# some crappy tts script to generate placeholders for the real thing

from openai import OpenAI
import os

tts_items = {
    # "check": "Check.",

    # "Before Engine Start": "Alright, starting with the before engine start checklist.",
    # "Engine Start": "Everything OK, proceeding with engine start.",
    # "Run Up": "NG is stabilized, let's run her up.",
    # "Systems": "Getting systems ready.",
    # "Before Takeoff": "OK some final checks before take off.",

    # "Throttle closed": "Throttle closed.",
    # "Ignition CB switch to IGN": "Ignition breaker switch to IGN.",
    # "FADEC CB switch to FADEC": "Fadec breaker switch to Fadec.",
    # "Anti-collision lights to ANTI COLL": "Anti-collision lights to anti coll.",
    # "Ignition key set to ON": "Ignition key set to on.",
    # "BATT 1 switch to BATT 1": "Battery 1 switch to batt 1.",
    # "Check FADEC mode is in AUTO": "Check faydeck mode is in auto.",
    # "Wait for CAUTION": "Wait for caution.",
    # "ACK switch to reset CAUTION": "Reset caution with the ack switch.",
    # "Hold MPD TEST switch up": "Hold MPD test switch up.",
    # "BIT_Reset switch UP": "Bit reset switch up.",
    # "Wait for BIT test to complete": "Wait for bit test to complete.",
    # "BIT_Reset switch DOWN": "Bit reset switch down.",

}

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

for key, text in tts_items.items():
    response = client.audio.speech.create(
        model="tts-1-hd",
        voice="onyx", # alloy, echo, fable, onyx, nova, shimmer
        input=text,
    )
    output_file_path = f"sounds/tts/{key}.mp3"
    response.stream_to_file(output_file_path)
    print(f"Saved: {output_file_path}")
