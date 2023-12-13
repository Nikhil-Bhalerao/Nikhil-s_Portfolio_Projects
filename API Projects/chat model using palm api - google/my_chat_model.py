import google.generativeai as palm
import base64
import json
import pprint
import time
import apikey

# Configure the client library by providing your API key.
palm.configure(api_key= apikey.api_key) # when using this please add your own api key here

# These parameters for the model call can be set by URL parameters.
model = 'models/chat-bison-001'
temperature = 0.25
candidate_count = 1
top_k = 40  
top_p = 0.95

defaults = {
  'model': model,
  'temperature': temperature,
  'candidate_count': candidate_count,
  'top_k': top_k,
  'top_p': top_p,
}

print("enter q to quit the program")

while True:
  print("\n")
  messages_b64 = str(input("Enter Prompt: "))

  if messages_b64.lower() != "q":
    messages = str(messages_b64)
    
    # Show what will be sent with the API call.
    pprint.pprint(messages)
    print("\n")
    # Call the model and print the response.
    response = palm.chat(
      **defaults,
      messages=messages
    )

    try:
      print(response.candidates[0]["content"])
    except Exception as e:
      print("No Text Was Genrated", e)
      continue
    
  elif messages_b64.lower() == "q":
    print("Thanks For Using")
    time.sleep(3)
    break
    quit()
    