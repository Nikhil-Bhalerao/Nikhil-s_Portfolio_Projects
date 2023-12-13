import google.generativeai as palm
import base64
import json
import pprint
import credentials

# Configure the client library by providing your API key.
palm.configure(api_key= credentials.api_key)

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

messages_b64 = str(input("Enter Prompt: "))

messages = str(messages_b64)

# Show what will be sent with the API call.
pprint.pprint({'messages': messages})

# Call the model and print the response.
response = palm.chat(
  **defaults,
  messages=messages
)

if not response.candidates:
  print("The model was not able to generate any text.")
else:
  print(response.candidates[0]["content"])