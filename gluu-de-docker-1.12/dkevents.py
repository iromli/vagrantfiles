from pprint import pprint

import docker


dk = docker.Client()

try:
    while True:
        for event in dk.events(decode=True):
            pprint(event)
except KeyboardInterrupt:
    print("cancelled by user")
