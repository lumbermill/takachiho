import time
from pushjack import APNSSandboxClient

client = APNSSandboxClient(certificate='pushcert.pem',
                    default_error_timeout=10,
                    default_expiration_offset=2592000,
                    default_batch_size=100,
                    default_retries=5)

token = '67d3e0ff1be0aa211e9ad045fb36d8d3bd3e375dd8bc172853e0379b408fe099'
alert = 'Hello world.'

# Send to single device.
# NOTE: Keyword arguments are optional.
res = client.send(token,
                  alert,
                  badge='badge count',
                  sound='sound to play',
                  expiration=int(time.time() + 604800),
                  error_timeout=5,
                  batch_size=200,
                  extra={'custom': 'data'})
client.close()

# Send to multiple devices by passing a list of tokens.
#client.send([token], alert, **options)
# List of all tokens sent.

# List of errors as APNSServerError objects
print(res.errors)

# Dict mapping errors as token => APNSServerError object.
print(res.token_errors)
